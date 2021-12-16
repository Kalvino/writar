$(document).ready(function(){
    $("#submit-paypal-form").click(function(e){
        e.preventDefault();

        var form = $("#update-paypal-email-form");
        var url  = form.attr("action");

        $.ajax({
            type: "PATCH",
            url: url,
            dataType: "json",
            data: form.serialize(),
            success: function(data){
                if(data.updated == "false"){
                    form.find(".alert.alert-danger").text(data.errors.join(",")).removeClass("hidden");
                } else {
                    form.find(".alert.alert-danger").addClass("hidden");
                    form.addClass("hidden");
                    $(".alert.alert-success").text(data.msg).removeClass("hidden");
                    $("#tb").removeClass("hidden");
                    $("#pp-email").text(data.email);
                }
            }
        });
    });

    $("#edit-paypal-email").click(function(e){
        e.preventDefault();

        $("form#update-paypal-email-form").removeClass("hidden");
    });
});
