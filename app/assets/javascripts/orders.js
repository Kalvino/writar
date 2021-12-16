$(document).ready(function() {
    $("a#next, a[href='#tab2']").click(function (e) {
        e.preventDefault();

        $("#price-calculation").removeClass("hidden");
        $("#paper-details").addClass("hidden");
        $('li[data-target="#step1"]').addClass('active');
        $('li[data-target="#step2"]').addClass('active');
        $('li[data-target="#step3"]').removeClass('active');
        $("html, body").animate({ scrollTop: 0 }, "slow");
        $('form#order-form').calculateCost();
    });

    $("a#back, a[href='#tab1']").click(function (e) {
        e.preventDefault();

        $("#price-calculation").addClass("hidden");
        $("#paper-details").removeClass("hidden");
        $('li[data-target="#step1"]').addClass('active');
        $('li[data-target="#step2"]').removeClass('active');
        $('li[data-target="#step3"]').removeClass('active');
        $("html, body").animate({ scrollTop: 0 }, "slow");
        $('form#order-form').calculateCost();
    });

    $(".touchspin").TouchSpin({
        verticalbuttons: true,
        min : 1,
        verticalupclass: 'fa fa-plus',
        verticaldownclass: 'fa fa-minus'
    });

    if($('form#order-form').length){
        $('form#order-form').calculateCost();
    }

    if($('form#inquiry').length){

        estimateDeadline();
        wordCount();

        $('input:radio[name="order[hours_to_deadline]"]').change(function(){
            estimateDeadline();
        });

        $('input:radio[name="order[spacing]"]').change(function(){
            wordCount();
        });

        $("#order_pages").change(function(){
            wordCount();
        });
    }

    if($('.summernote-v1').length){
        var $placeholder = $('.placeholder');

        $('.summernote-v1').summernote({
            toolbar: [
                // [groupName, [list of button]]
                ["style", ["style"]],
                ["font", ["bold", "underline", "clear"]],
                // ["fontname", ["fontname"]],
                // ["color", ["color"]],
                ["para", ["ul", "ol", "paragraph"]],
                ["table", ["table"]],
                ["insert", ["link", "picture", "video"]],
                // ["view", ["fullscreen", "codeview", "help"]]
            ],
            onfocus: function () {
                $placeholder.hide();
            },
            oninit: function () {
                $placeholder.show();
            },
            onblur: function () {
                $placeholder.hide();
            }
        });
    }
});

function estimateDeadline(){
    var deadline = $('form#inquiry').find('input:radio[name="order[hours_to_deadline]"]:checked').val();
    var estimate = moment().add(parseInt(deadline),'hours').format('Do MMMM YYYY [at] h:mm a');

    $("b#estimated-deadline").text(estimate);
}

function wordCount(){
    var spacing         = $('form#inquiry').find('input:radio[name="order[spacing]"]:checked').val();
    var pageCount       = $('form#inquiry').find('#order_pages').val();
    var wordsPerPage    = 275;
    var spacingX        = spacing == "double" ? 1 : 2;
    var totalWords      = wordsPerPage * pageCount * spacingX;

    $("#words-per-page").text(totalWords + " Words");
}
