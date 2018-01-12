$(document).on('ready page:load', function() {
  var startDateParam = getUrlParameter('start');
  var endDateParam = getUrlParameter('end');
  var vendorParam = getUrlParameter('vendor');

  if (startDateParam && endDateParam) {
    initStartDate = moment(Date.parse(startDateParam)).format("MM/DD/YYYY");
    initEndDate = moment(Date.parse(endDateParam)).format("MM/DD/YYYY");
  } else {
    initEndDate = moment().endOf('day').format("MM/DD/YYYY");
    initStartDate = moment().startOf('day').format("MM/DD/YYYY");
  }

  $('.input-daterange input').first().val(initStartDate);
  $('.input-daterange input').last().val(initEndDate);

  $('.input-daterange').datepicker().on('changeDate', function (ev) {
    var startDate = $('.input-daterange input').first().datepicker('getDates')[0];
    var endDate = $('.input-daterange input').last().datepicker('getDates')[0];
    $('#submit-range').attr('href', "/payments/report?start=" + startDate.toDateString() + "&end=" + endDate.toDateString() + (vendorParam ? '&vendor=' + vendorParam: ''));
  });
});

var getUrlParameter = function getUrlParameter(sParam) {
  var sPageURL = decodeURIComponent(window.location.search.substring(1)),
      sURLVariables = sPageURL.split('&'),
      sParameterName,
      i;

  for (i = 0; i < sURLVariables.length; i++) {
    sParameterName = sURLVariables[i].split('=');

    if (sParameterName[0] === sParam) {
      return sParameterName[1] === undefined ? true : sParameterName[1];
    }
  }
};
