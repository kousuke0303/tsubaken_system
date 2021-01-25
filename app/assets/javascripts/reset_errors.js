$(".reset-errors").click(function(){
  $("label").each(function(index, el){
    if($(el).parent().hasClass("field-with-errors")){
      $(el).unwrap();
    }
  })
  $("input").each(function(index, el){
    if($(el).parent().hasClass("field-with-errors")){
      $(el).unwrap();
    }
  })
});
