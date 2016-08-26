function appendNewText(schema)  {
  var newText = " " + schema + " ";
  var para = document.getElementById("q");
  para.value = para.value + newText;
}