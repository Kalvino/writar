$(document).ready(function(){
    $("#faq_answer").froalaEditor({
        heightMin: 200,
        toolbarButtons: ['fullscreen', 'bold', 'italic', 'underline', 'strikeThrough', 'subscript', 'superscript',
            'fontFamily', 'fontSize', '|', 'color', 'emoticons', 'inlineStyle', 'paragraphStyle', '|', 'paragraphFormat',
            'align', 'formatOL', 'formatUL', 'outdent', 'indent', 'quote', 'insertHR', '-', 'insertLink', 'insertVideo',
            'insertTable', 'undo', 'redo', 'clearFormatting', 'selectAll', 'html']
    });
});
