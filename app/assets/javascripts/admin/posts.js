$(document).ready(function(){
    $("#post_body").froalaEditor({
        heightMin: 500,
        imageUploadURL: $('form#blog-editor').data('froala-upload-url'),
        imageUploadParam: 'froala_upload[file]',
        imageUploadParams: {
            authenticity_token:  $('meta[name="csrf-token"]').attr('content')
        },
        toolbarButtons: ['fullscreen', 'bold', 'italic', 'underline', 'strikeThrough', 'subscript', 'superscript',
            'fontFamily', 'fontSize', '|', 'color', 'emoticons', 'inlineStyle', 'paragraphStyle', '|', 'paragraphFormat',
            'align', 'formatOL', 'formatUL', 'outdent', 'indent', 'quote', 'insertHR', '-', 'insertLink', 'insertImage', 'insertVideo',
            'insertTable', 'undo', 'redo', 'clearFormatting', 'selectAll', 'html']
    });

    $("#category_content").froalaEditor({
        heightMin: 300,
        imageUploadURL: $("#category_content").data('froala-upload-url'),
        imageUploadParam: 'froala_upload[file]',
        imageUploadParams: {
            authenticity_token:  $('meta[name="csrf-token"]').attr('content')
        },
        toolbarButtons: ['fullscreen', 'bold', 'italic', 'underline', 'strikeThrough', 'subscript', 'superscript',
            'fontFamily', 'fontSize', '|', 'color', 'emoticons', 'inlineStyle', 'paragraphStyle', '|', 'paragraphFormat',
            'align', 'formatOL', 'formatUL', 'outdent', 'indent', 'quote', 'insertHR', '-', 'insertLink', 'insertImage', 'insertVideo',
            'insertTable', 'undo', 'redo', 'clearFormatting', 'selectAll', 'html']
    });
});