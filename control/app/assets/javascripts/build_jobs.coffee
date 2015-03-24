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
    source = new EventSource(path)
    
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

process_submit_form = ->
  $('#start_build_job_form').submit ->
    console.log "on start build job clicked"
    # check if this commit is built already
    show_question = true
    check_existing_build()
    if not show_question
      return true
    
    $('#modal_existing_build_job').modal('show')
   
    $('#button_start_anyway').click ->
      console.log "clicked start anyway"
      $('#start_build_job_form').unbind() # prevent recursion on submit since we are already in submit handler
      $('#start_build_job_form').submit()

    $('#button_show_existing').click ->
      console.log "clicked show existing"
    false
    
check_existing_build = ->
  branch_id = $('#select-branch').val()
  base_version_id = $('#select-base_version').val()
  target_platform_id = $('#select-target_platform').val()
  console.log "branch_id=" + branch_id
  console.log "base_version_id=" + base_version_id
  console.log "target_platform_id=" + target_platform_id
  
  url = gon.check_existing_path
  params = {branch_id: branch_id, base_version_id: base_version_id, target_platform_id: target_platform_id}

  is_exists = false
  $.ajax type: 'GET', url: url, data: params, async: false, success: (data, status, xhr) -> 
      console.log("ajax request " + status + ", build exists: " + data.is_exists)   
      is_exists = true
  console.log("is_exists=" + is_exists)
  is_exists

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
  if $(attr_id).html() != new_value && new_value.length > 0
    console.log "updating " + attr + " to " + new_value
    $(attr_id).html(new_value)

refresh_tables = (json) ->
  if $("#status_for_" + json.build_job_id).html() != json.status
    location.reload()
    
ready = ->
  connect_sse()
  setup_select_notify_me()
  process_submit_form()
        
$(document).ready(ready)
$(document).on('page:load', ready) # with turbolinks it causes multiple connection sse when walking across pages with sse


  
