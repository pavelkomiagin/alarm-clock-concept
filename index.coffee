Alarms = []
currentAlarmNumber = null

changeTime = (value, max, actionType) ->
  if actionType is 'increase'
    value++
    value = 0 if value > max
  else
    value--
    value = max if value < 0

  value = "0#{value}" if value < 10
  value

getFrequencyText = (frequency) ->
  days = ['Mo', 'Tue', 'We', 'Th', 'Fr', 'Sa', 'Su'].filter (element, index) ->
    index in frequency

  days = ['Everyday'] if days.length is 7
  days.join ' '

setAlarm = (alarmNumber, hours, minutes, frequency) ->
  minutes = "0#{minutes}" if minutes < 10
  $alarm_card = $($('.alarm_card')[alarmNumber])
  $alarm_card.find('.time').html "#{hours}:#{minutes}"
  $alarm_card.find('.frequency').html getFrequencyText(frequency)

  Alarms[alarmNumber] =
    hours: hours
    minutes: minutes
    frequency: frequency

$ ->
  $('.switcher').on 'click', (e) ->
    e.stopPropagation()
    $(@).toggleClass 'on'

  $('.alarm_card').on 'click', ->
    $day = $('.day')
    $day.removeClass('active')

    window.currentAlarmNumber = $(@).data('index')
    currentAlarm = Alarms[window.currentAlarmNumber]

    currentAlarm.frequency.forEach (value) ->
      $($day[value]).addClass('active')

    hours = currentAlarm.hours
    hours = "0#{hours}" if hours < 10
    minutes = currentAlarm.minutes
    $('.hours .value').text(hours)
    $('.minutes .value').text(minutes)

    $('.alarm_cards').removeClass('shown').addClass('hidden')
    $('.alarm_change_card_wrapper').removeClass('hidden').addClass('shown')

  $('.day').on 'click', ->
    $(@).toggleClass 'active'

  $('.saving_button').on 'click', ->
    $('.alarm_cards').removeClass('hidden').addClass('shown')
    $('.alarm_change_card_wrapper').removeClass('shown').addClass('hidden')

    hours = parseInt $('.hours .value').text()
    minutes = parseInt $('.minutes .value').text()
    frequency = []
    $('.day').each (index, element) ->
      frequency.push(index) if $(element).hasClass('active')

    setAlarm(window.currentAlarmNumber, hours, minutes, frequency)

  ######## Set time ########
  $('.hours .up').on 'click', ->
    newHours = changeTime parseInt($('.hours .value').text()), 23, 'increase'
    $('.hours .value').text newHours

  $('.hours .down').on 'click', ->
    newHours = changeTime parseInt($('.hours .value').text()), 23, 'decrease'
    $('.hours .value').text newHours

  $('.minutes .up').on 'click', ->
    newMinutes = changeTime parseInt($('.minutes .value').text()), 59, 'increase'
    $('.minutes .value').text newMinutes

  $('.minutes .down').on 'click', ->
    newMinutes = changeTime parseInt($('.minutes .value').text()), 59, 'decrease'
    $('.minutes .value').text newMinutes

  setAlarm(0, 18, 0, [0, 1, 2, 3, 4, 5, 6])
  setAlarm(1, 6, 0, [1, 2, 3])
  setAlarm(2, 12, 0, [3, 4, 5, 6])