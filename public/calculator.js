$(document).ready(
  function(){
    $("#calculator").html('\
      <fieldset><legend>Calculator</legend>\
      <p> <label>Weight</label> <input type="text" class="num" id="weight"/></p>\
      <p> <label>Calories per 100g</label> <input type="text" class="num" id="calories"/></p>\
      <p><button id="calculate">Calculate</button></p>\
      <div id="result"> </div></fieldset>\
    ')
    $("#calculate").click(
      function(){
        $("#result").text($("#weight").val() * $("#calories").val() / 100)
      }
    );
  }
);
