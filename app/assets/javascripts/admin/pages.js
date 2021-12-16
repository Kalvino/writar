$(document).ready(function(){
    $("#page_content").froalaEditor({
        heightMin: 600,
        toolbarButtons: ['fullscreen', 'bold', 'italic', 'underline', 'strikeThrough', 'subscript', 'superscript',
            'fontFamily', 'fontSize', '|', 'color', 'emoticons', 'inlineStyle', 'paragraphStyle', '|', 'paragraphFormat',
            'align', 'formatOL', 'formatUL', 'outdent', 'indent', 'quote', 'insertHR', '-', 'insertLink', 'insertTable',
            'undo', 'redo', 'clearFormatting', 'selectAll', 'html']
    });
});
