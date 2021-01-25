$(".reset-errors").click(function(){
  $("label").each(function(index, element){
    if($(element).parent().hasClass("field-with-errors")){
      $(element).unwrap();
    }
  })
  $("input").each(function(index, element){
    if($(element).parent().hasClass("field-with-errors")){
      $(element).unwrap();
    }
  })
});
