$('.prefectures-all').on('click', function(){
  $.ajax({
    type: "GET",
    url: "<%= prefecture_index_path %>",
    cache: false
  });
})
;
