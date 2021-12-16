$(document).ready(function(){
   // const instance = Layzr()
    $("img").lazyload();
    $(".send-message").click(function(e){
        e.preventDefault();
        
        if($( e.currentTarget ).is( ":button" )){
            $(this).addClass("disabled").text("Please Wait...");
        } else {
            $(this).addClass("disabled").val("Please Wait...");
        }

        $('#message_content').prop('readonly',true);

        var form = $(this).parents("form");
        var submitUrl = form.attr("action");
        data = new FormData(form[0]);

        $.ajax({
            type: "POST",
            url: submitUrl,
            dataType: "script",
            data: data,
            processData: false,
            contentType: false
        });
    });

    $(".chosen").chosen();

    if($('.summernote').length){
        $('.summernote').summernote({
            placeholder: "Please provide specific and detailed instructions about your paper"
        });
    }

    if($("#sparkline").length){
        $("#sparkline").sparkline($("#sparkline").data("items"), {
            type: 'line',
            width: '100%',
            height: '50',
            lineColor: '#1ab394',
            fillColor: "transparent"
        });
    }

    // cost of order
    if($('form#order-form').length){
        $('form#order-form').calculateCost();

        $('input:radio[name="order[academic_level]"]').change(function(){
            $('form#order-form').calculateCost();
        });

        $('input:radio[name="order[hours_to_deadline]"]').change(function(){
            $('form#order-form').calculateCost();
        });

        $('input:radio[name="order[spacing]"]').change(function(){
            $('form#order-form').calculateCost();
        });

        var elem = $("#order_pages");

        // Save current value of element
        elem.data('oldVal', elem.val());

        // Look for changes in the value
        elem.bind("propertychange change click keyup input paste", function(event){
            // If value has changed...
            if (elem.data('oldVal') != elem.val()) {
                // Updated stored value
                elem.data('oldVal', elem.val());

                $('form#order-form').calculateCost();
            }
        });
    }

    $('.submit-btn').on('click', function () {
        var $btn = $(this).button('loading');
    });

    $(".open-chat").click(function(e){
        e.preventDefault();

        Intercom('show');
    });

    if($('.dataTable').length){
        $('.dataTable').dataTable();
    }
});
