$(document).on 'turbolinks:load', ->

  pickerIcons =
    time: 'fa fa-clock-o fa-1x'
    date: 'fa fa-calendar fa-1x'
    up: 'fa fa-arrow-up fa-1x'
    down: 'fa fa-arrow-down fa-1x'
    previous: 'fa fa-chevron-left fa-1x'
    next: 'fa fa-chevron-right fa-1x'
    today: 'fa fa-circle fa-1x'
    clear: 'fa fa-trash fa-1x'
    close: 'fa fa-times fa-1x'

  pickerOptions = ($el) ->
    icons: pickerIcons
    format: $el.data('format') or 'DD MMM YYYY HH:mm'
    viewMode: $el.data('view-mode')
    showClear: $el.data('show-clear')
    showClose: $el.data('show-close')

  # Lovely date pickers with <input data-datetimepicker />
  $('[data-datetimepicker]').each ->
    $(@).datetimepicker pickerOptions($(@))

  # More beautiful looking selects with <select data-selectpicker></select>
  $('[data-selectpicker] + .select2').remove()
  $('[data-selectpicker]').removeClass('select2-hidden-accessible').select2 theme: 'bootstrap'

  # Auto-size all text areas
  $('textarea').autosize()
