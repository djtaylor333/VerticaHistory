window.onload = function(){
  $(".select-all-btn").click(function(){
    var checkBoxes = $(this).closest('form').find(".attribute-checkbox input[type=checkbox]");
    checkBoxes.prop("checked", $(this).prop("checked"));
  });
};