# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

setup_sortables = ->
  $('#sortable_target_platorms').sortable()
  $('#sortable_target_platorms').disableSelection()
  $('#enviroments_form').submit ->
    items = $('#sortable_target_platorms').sortable('toArray')
    array = []
    for i in items
      item_text = $('#' + i).text()
      console.log item_text
      array.push item_text
    $('#enviroment_target_platforms_order').val(JSON.stringify(array)) 
      
$(document).ready(setup_sortables)
$(document).on('page:load', setup_sortables)