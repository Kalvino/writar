var questionsTable;

$(document).ready(function(){
    $("#question_content").froalaEditor({
        heightMin: 200,
        toolbarButtons: ['fullscreen', 'bold', 'italic', 'underline', 'strikeThrough', 'subscript', 'superscript',
            'fontFamily', 'fontSize', '|', 'color', 'emoticons', 'inlineStyle', 'paragraphStyle', '|', 'paragraphFormat',
            'align', 'formatOL', 'formatUL', 'outdent', 'indent', 'quote', 'insertHR', '-', 'insertLink', 'insertVideo',
            'insertTable', 'undo', 'redo', 'clearFormatting', 'selectAll', 'html']
    });

    questionsTable = $('#questions').DataTable({
        bProcessing: true,
        bServerSide: true,
        sAjaxSource: $('#questions').data('source'),
        iDisplayLength: 10,
        aoColumnDefs: [
            { bSortable: false, aTargets: [ 3 ] }
        ],
        aaSorting: [[2,"desc"]]
    });

    $(".filter-questions").click(function(e){
        e.preventDefault();

        $('.filter-questions').removeClass('active');
        $(this).addClass("active");

        var url = $(this).data("source");
        questionsTable.ajax.url(url).load();
    });


    $("button#qskip").click(function (e) {
        e.preventDefault();

        var pageNo = parseInt($("#skip2page").val());
        if(pageNo != NaN){
            pageNo -= 1;
            questionsTable.page(pageNo).draw( 'page' );
        }
    });


    if($("#questions-chart").length){
        var question_statuses_url = $("#questions-chart").data("url");
        $.ajax({
            type: "GET",
            url: question_statuses_url,
            success: function(data){
                $("#questions-chart").highcharts(data);
            }
        });
    }
});
