$(document).on('ready page:load', function() {
  console.log('here!');
  $('.input-daterange').datepicker().on('changeDate', function (ev) {
    var startDate = $('.input-daterange input').first().datepicker('getDates')[0];
    var endDate = $('.input-daterange input').last().datepicker('getDates')[0];
    $('#submit-range').attr('href', "/payments/report?start=" + startDate.toDateString() + "&end=" + endDate.toDateString());
  });
});
