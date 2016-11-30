$(document).on 'turbolinks:load', ->
  $icon = $('#team_icon, #church_process_icon')
  $color = $('#team_color, #church_process_color')

  $('[data-toggle=color]').click (e) ->
    e.preventDefault()
    color = $(@).data('color')
    $color.val color
    $(@).parents('.input-group-btn').find('> a').css(color: '#' + color)

  $('[data-toggle=icon]').click (e) ->
    e.preventDefault()
    $el = $(@)
    icon = $el.data('icon')
    $icon.val $el.data('value') or icon
    $el.parents('.input-group-btn').find('> a .fa').removeClass().addClass('fa fa-' + icon + ' fa-1x')
