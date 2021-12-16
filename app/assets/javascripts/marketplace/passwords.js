$(document).ready(function(){
    if($("#not-main").length){
        $("ul#myTab a").click(function(){
            var url = $(this).attr("href");
            window.location.href = url;
        });
    }
});
