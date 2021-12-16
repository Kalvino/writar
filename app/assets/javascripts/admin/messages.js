$(document).ready(function(){
    $("a.send-as").click(function(e){
        e.preventDefault();

        
        var adminID = $(this).data("id");
        var adminName = $(this).data("name");
        var emailMD5 = $(this).data("md5");
        var adminAvatar = "https://www.gravatar.com/avatar/"+ emailMD5 +"?s=48&d=identicon";

        $("#message_user_id").val(adminID);
        $("button.send-message").text("Send as (" + adminName + ")");
        $("#new-message .social-avatar").find("img").attr("src", adminAvatar);
    });
});
