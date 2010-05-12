$(function() {
  
  $("form").validate({
    /*debug: true,*/
    messages: {
      email: {
        required: "I need your email address, please!",
        email: "I need your <em>full</em> email address, like name@example.com"
      },
      message: "I know you can muster something more interesting!"
    },
    highlight: function(element, errorClass, validClass) {
      $(element).addClass(errorClass).removeClass(validClass);
    },
    unhighlight: function(element, errorClass, validClass) {
      $(element).removeClass(errorClass).addClass(validClass);
    }
  });

});
