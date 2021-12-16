/*
 By Osvaldas Valutis, www.osvaldas.info
 Available for use under the MIT License
 */

'use strict';

;(function ($, window, document, undefined) {
    $('.inputfile').each(function () {
        var $input = $(this),
            $label = $input.next('label'),
            labelVal = $label.html();

        $input.on('change', function (e) {
            var fileName = '';

            if (this.files && this.files.length > 1)
                fileName = ( this.getAttribute('data-multiple-caption') || '' ).replace('{count}', this.files.length);
            else if (e.target.value)
                fileName = e.target.value.split('\\').pop();

            if (fileName)
                $label.find('span').html(fileName);
            else
                $label.html(labelVal);
        });

        // Firefox bug fix
        $input
            .on('focus', function () {
                $input.addClass('has-focus');
            })
            .on('blur', function () {
                $input.removeClass('has-focus');
            });
    });
})(jQuery, window, document);

var essaysTable;

$(document).ready(function () {

    Highcharts.setOptions({
        lang: {
            thousandsSep: ','
        }
    });

    $('.essay-thumbnails').slick({
        dots: true
    });

    essaysTable = $('#essays').DataTable({
        bProcessing: true,
        bServerSide: true,
        sAjaxSource: $('#essays').data('source'),
        iDisplayLength: 25,
        aoColumnDefs: [
            {bSortable: false, aTargets: [6, 7]}
        ],
        aaSorting: [[5, "desc"]],
        fnDrawCallback: function () {
            $('[data-toggle="tooltip"]').tooltip();
        },
    });

    $(".filter-papers").click(function(e){
        e.preventDefault();

        $('.filter-papers').removeClass('active');
        $(this).addClass("active");

        var url = $(this).data("source");
        essaysTable.ajax.url(url).load();
    });

    $("button#skip").click(function (e) {
        e.preventDefault();

        var pageNo = parseInt($("#skip2page").val());
        if(pageNo != NaN){
            pageNo -= 1;
            essaysTable.page(pageNo).draw( 'page' );
        }
    });

    var uploadUrl = $('form#paper-upload').data('froala-upload-url');
    var uploadParam = 'froala_upload[file]';
    var authToken = $('meta[name="csrf-token"]').attr('content');

    var sharedConfig = {
        heightMin: 300,
        zIndex: 4000,
        imageUploadURL: uploadUrl,
        imageUploadParam: uploadParam,
        imageUploadParams: {
            authenticity_token: authToken
        }
    }

    var essayPreviewConfig = $.extend({}, sharedConfig, {
        toolbarButtons: ['fullscreen', 'bold', 'italic', 'underline', 'strikeThrough', 'subscript', 'superscript',
            'fontFamily', 'fontSize', '|', 'color', 'emoticons', 'inlineStyle', 'paragraphStyle', '|', 'paragraphFormat',
            'align', 'formatOL', 'formatUL', 'outdent', 'indent', 'quote', 'insertHR', '-', 'insertLink', 'insertImage', 'insertVideo',
            'insertTable', 'undo', 'redo', 'clearFormatting', 'selectAll', 'html']
    });

    var essayQuestionConfig = $.extend({}, sharedConfig, {
        fileUploadURL: uploadUrl,
        fileUploadParam: uploadParam,
        fileUploadParams: {
            authenticity_token: authToken
        }
    });

    $("#essay_preview").froalaEditor(essayPreviewConfig);
    $("#essay_question").froalaEditor(essayQuestionConfig);

    var text_max = 255;
    var text_min = 100;
    $('#essay_short_description').bind("change keyup input propertychange", function () {
        var text_length = $(this).val().length;

        if (text_length <= text_min) {
            var text_to_go = text_min - text_length;
            $('#char-counter-1').text(text_to_go + ' character to go');
            if (text_to_go == 0) {
                $('#char-counter-1').text('Min achieved!');
            }
        } else {
            $('#char-counter-1').text('Min achieved!');
        }
        if (text_length <= text_max) {
            var text_remaining = text_max - text_length;
            $('#char-counter-2').text(text_remaining + ' character remaining');
        }
    });

    $("#submit-paper").click(function (e) {
        e.preventDefault();

        var short_desc_length = $('#essay_short_description').val().length;
        if (short_desc_length < text_min) {
            alert("Minimum characters for short description should be " + text_min);
        } else if (short_desc_length > text_max) {
            alert("Maximum characters for short description should be " + text_max);
        } else {
            $(this).parents("form").submit();
        }
    });

    $(".select-2").select2({
        theme: "bootstrap"
    });

    $('a.status').click(function (e) {
        e.preventDefault();

        var link = $(this);
        var status = link.data("status");
        var type = link.data("type") || "Paper";
        var label,data;
        if(type == "Question") {
            data = { question: { status: status } }
        } else if(type == "Order"){
            data = { order: { status: status } }
        } else {
            data = { essay: { status: status } }
        }

        label = "This action will mark this "+ type + " as " + status;
        
        swal({
            title: "Are you sure?",
            text: label,
            type: "warning",
            showCancelButton: true,
            confirmButtonColor: "#DD6B55",
            confirmButtonText: "Yes, Confirm!",
            closeOnConfirm: false
        }, function () {
            $.ajax({
                url: link.attr("href"),
                type: "PATCH",
                data: data,
                success: function (data) {
                    $('a.status.active').removeClass("active");
                    link.addClass("active");
                    swal("Success!", data.message, "success");
                },
                error: function (xhr, ajaxOptions, thrownError) {
                    sweetAlert("Oops...", "You may not have permission to perform this operation", "error");
                }
            });
        });
    });

    $("a#refresh-thumbnails").click(function (e) {
        e.preventDefault();

        var link = $(this);

        swal({
            title: "Are you sure?",
            text: "This action will regenerate thumbnails for this paper!",
            type: "warning",
            showCancelButton: true,
            confirmButtonColor: "#DD6B55",
            confirmButtonText: "Yes, Confirm!",
            closeOnConfirm: false,
            showLoaderOnConfirm: true
        }, function () {
            $.ajax({
                url: link.attr("href"),
                type: "POST",
                dataType: "json",
                success: function (data) {
                    swal("Success!", "Thumbnail generation for this paper has been queued!", "success");
                },
                error: function (xhr, ajaxOptions, thrownError) {
                    sweetAlert("Oops...", xhr.responseJSON.error, "error");
                }
            });
        });
    })

});
