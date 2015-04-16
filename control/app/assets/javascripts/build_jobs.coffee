# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
        
setup_select_notify_me = ->
  $ ->
    $('#select-me-button').click ->
      if(gon? && gon.current_user_id?)
        $("#select-user").val(gon.current_user_id).trigger("change")

connect_sse = ->
  console.log "Trying to start SSE..."
  if(gon? && gon.build_jobs_live_updates_path?)
    path = gon.build_jobs_live_updates_path
    console.log "SSE path " + path
    if window.event_source
      console.log "Stopping SSE before restarting"
      window.event_source.close()
    source = new EventSource(path)
    window.event_source = source
    
    $(document).on 'page:before-change', ->
       console.log "Stopping SSE on page change"
       source.close()
    
    source.onerror = ->
      console.log "Error occured while listening SSE"
    
    source.addEventListener "update_build_jobs", (event) ->
      if event.data == 'keep_alive'
        console.log 'keep_alive'
      else
        onevent event
  else 
    console.log "Error starting SSE"  

check_existing_builds = ->
  set_build_not_exists()
  on_change_form_check_existing()
  $('#select-branch, #select-base_version, #select-target_platform').change ->
    on_change_form_check_existing()
    
on_change_form_check_existing = ->
  branch_id = $('#select-branch').val()
  base_version_id = $('#select-base_version').val()
  target_platform_id = $('#select-target_platform').val()
  console.log "branch_id=" + branch_id
  console.log "base_version_id=" + base_version_id
  console.log "target_platform_id=" + target_platform_id
  if(gon? && gon.check_existing_path?)
    url = gon.check_existing_path
    params = {branch_id: branch_id, base_version_id: base_version_id, target_platform_id: target_platform_id}
    $.ajax type: 'GET', url: url, data: params, success: (data, status, xhr) -> 
        console.log("ajax request " + status + ", build exists: " + data.exists)
        if data.exists
          set_build_exists(data.path)
        else
          set_build_not_exists()
      
set_build_exists = (href)->
  console.log "the build is already exists"
  $('#existing_build_notification').show()
  $('#existing_build_path').attr('href', href)
  
set_build_not_exists = ->
  console.log "no existing builds"
  $('#existing_build_notification').hide()
  $('#existing_build_path').attr('href', '#')

onevent = (event) ->
  json = JSON.parse(event.data)
  console.log json
  build_job_id = json.build_job_id
  update_attr "full_version_for_", build_job_id, json.full_version
  update_attr "artefacts_for_", build_job_id, json.artefacts
  update_attr "duration_for_", build_job_id, json.duration
  update_attr "revision_for_", build_job_id, json.revision
  refresh_tables json
    
update_attr = (attr, build_job_id, new_value) ->
  attr_id = "#" + attr + build_job_id
  if new_value?
    if $(attr_id).html() != new_value && new_value.length > 0
      console.log "updating " + attr + " to " + new_value
      $(attr_id).html(new_value)

refresh_tables = (json) ->
  current_status = $("#status_for_" + json.build_job_id).html()
  if current_status and current_status != json.status
    console.log("current status " + current_status + " != " + json.status + "; refreshing...")
    #location.reload()
    if window.event_source
      console.log "Stopping SSE before reloading page contents"
      window.event_source.close()
    #disable page scrolling to top after loading page content
    Turbolinks.enableTransitionCache(true)
    # pass current page url to visit method
    Turbolinks.visit(location.toString())
    #enable page scroll reset in case user clicks other link
    Turbolinks.enableTransitionCache(false)
    
ready = ->
  setTimeout (-> connect_sse()), 1000
  setup_select_notify_me()
  check_existing_builds() 
        
$(document).ready(ready)
$(document).on('page:load', ready) # with turbolinks it causes multiple connection sse when walking across pages with sse


  
