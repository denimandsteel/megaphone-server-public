var setupDragula = function() {
  var updateProductOrders = function() {
    $('.products-container > .product-details').each(function(index, element) {
      $.ajax({
        method: "PUT",
        url: "/products/" + $(element).data("product-id"),
        dataType: "JSON",
        data: { product: { order: index + 1 } }
      });
    });
  };

  dragula([document.querySelector('.products-container')], {
    moves: function(el, container, handle) {
      return handle.className === 'grab-handle';
    },
    accepts: function(el, target, source, sibling) {
      return true; // elements can be dropped in any of the `containers` by default
    },
    invalid: function(el, handle) {
      return false; // don't prevent any drags from initiating by default
    }
  }).on('drop', function(el, container, source) {
    updateProductOrders();
  });
};

var setupDescriptionCount = function() {
  if ($('#product_description').length > 0) {
    var setCount = function() {
      var count = $('#product_description').val().length;
      $('.js_product_description_count .count').text(count);
      $('.js_product_description_count').toggleClass('over', count > 200);
    };
    $('#product_description').on('keyup', setCount);
    setCount();
  }
};

$(document).ready(setupDragula);
$(document).on("page:load", setupDragula);
$(document).ready(setupDescriptionCount);
$(document).on("page:load", setupDescriptionCount);
