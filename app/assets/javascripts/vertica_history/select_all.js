window.onload = function(){
  $(".select-all-btn").click(function(){
    var checkBoxes = $(self).parent().children("input[type=checkbox]");
    checkBoxes.prop("checked", !checkBoxes.prop("checked"));
  });
};