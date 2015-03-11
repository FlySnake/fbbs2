# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
ready = ->
  console.log "start listening SSE on " + gon.live_updates_path
  source = new EventSource(gon.live_updates_path)
  source.addEventListener "update_build_jobs", (event) ->
    #console.log event.data
    json = JSON.parse(event.data)
    console.log json
    
    build_job_id = json.build_job_id
    
    update_attr "full_version_for_", build_job_id, json.full_version
    update_attr "artefacts_for_", build_job_id, json.artefacts
    update_attr "duration_for_", build_job_id, json.duration
    update_attr "revision_for_", build_job_id, json.revision
    
    #$("#full_version_for_" + build_job_id).html(json.full_version)
    
    #if $("#artefacts_for_" + build_job_id).html() != json.artefacts && json.artefacts.length > 0
    #  $("#artefacts_for_" + build_job_id).html(json.artefacts)
      
    #$("#duration_for_" + build_job_id).html(json.duration)
    #$("#revision_for_" + build_job_id).html(json.revision)
    
    if $("#status_for_" + build_job_id).html() != json.status
      location.reload()
      
update_attr = (attr, build_job_id, new_value) ->
  attr_id = "#" + attr + build_job_id
  if $(attr_id).html() != new_value && new_value.length > 0
    console.log "updating " + attr + " to " + new_value
    $(attr_id).html(new_value)
  
    
$(document).ready(ready)
$(document).on('page:load', ready) 