# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
ready = ->
  console.log "trying to start SSE..."
  if(gon? && gon.build_jobs_live_updates_path?)
    path = gon.build_jobs_live_updates_path
    console.log "SSE started on " + path
    source = new EventSource(path)
    source.addEventListener "update_build_jobs", (event) ->
      json = JSON.parse(event.data)
      console.log json
      
      build_job_id = json.build_job_id
      
      update_attr "full_version_for_", build_job_id, json.full_version
      update_attr "artefacts_for_", build_job_id, json.artefacts
      update_attr "duration_for_", build_job_id, json.duration
      update_attr "revision_for_", build_job_id, json.revision
      
      refresh_tables json
  else 
    console.log "error starting SSE"
      
update_attr = (attr, build_job_id, new_value) ->
  attr_id = "#" + attr + build_job_id
  if $(attr_id).html() != new_value && new_value.length > 0
    console.log "updating " + attr + " to " + new_value
    $(attr_id).html(new_value)

refresh_tables = (json) ->
  if $("#status_for_" + json.build_job_id).html() != json.status
    location.reload()
        
$(document).ready(ready)
$(document).on('page:load', ready) 