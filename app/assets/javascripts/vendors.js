var userLinks = function() {
  $("tr[data-link]").click(function() {
    window.location = $(this).data("link")
  });
};

var addLocations = function() {
  $('.add-location').on('click', function() {
    var time = new Date().getTime();
    var regexp = new RegExp($(this).data('id'), 'g');
    var $newLocationFields = "<div class='vendor-location-fields'>" + $(this).data('fields').replace(regexp, time) + "</div>";

    $('.vendor-locations').append($newLocationFields);
    return false;
  });
};

var markLocationAsDeleted = function() {
  $('form').on('change', '.location-destroy-checkbox', function() {
    if (this.checked) {
      $(this).closest('.vendor-location-fields').addClass('delete-location');
    } else {
      $(this).closest('.vendor-location-fields').removeClass('delete-location');
    }
  });
};

var setVendorCity = function() {
  $('.vendor-locations').on('change', '.neighbourhood-dropdown', function() {
    var vendorCity = $(this).find('option:selected').closest("optgroup").attr('label');
    var hiddenCityField = $(this).siblings("input[type=hidden]");

    hiddenCityField.val(vendorCity)
  })
};

$(document).ready(userLinks);
$(document).on("page:load", userLinks);
$(document).ready(addLocations);
$(document).on("page:load", addLocations);
$(document).ready(markLocationAsDeleted);
$(document).on("page:load", markLocationAsDeleted);
$(document).ready(setVendorCity);
$(document).on("page:load", setVendorCity);
