/*
 By Osvaldas Valutis, www.osvaldas.info
 Available for use under the MIT License
 */

'use strict';

;( function( $, window, document, undefined )
{
    $( '.inputfile' ).each( function()
    {
        var $input	 = $( this ),
            $label	 = $input.next( 'label' ),
            labelVal = $label.html();

        $input.on( 'change', function( e )
        {
            var fileName = '';

            if( this.files && this.files.length > 1 )
                fileName = ( this.getAttribute( 'data-multiple-caption' ) || '' ).replace( '{count}', this.files.length );
            else if( e.target.value )
                fileName = e.target.value.split( '\\' ).pop();

            if( fileName )
                $label.find( 'span' ).html( fileName );
            else
                $label.html( labelVal );
        });

        // Firefox bug fix
        $input
            .on( 'focus', function(){ $input.addClass( 'has-focus' ); })
            .on( 'blur', function(){ $input.removeClass( 'has-focus' ); });
    });
})( jQuery, window, document );

$(document).ready(function(){
    $(".open-chat").click(function(e){
        e.preventDefault();

        Intercom('show');
    });
    
    $("#seller-essays").DataTable({
        bProcessing: true,
        bServerSide: true,
        iDisplayLength: 25,
        sAjaxSource: $('#seller-essays').data('source'),
        aoColumnDefs: [
            { bSortable: false, aTargets: [ 6,7 ] }
        ],
        aaSorting: [[5, "desc"]],
        fnServerParams: function ( aoData ) {
            aoData.push( { name: "seller_id", value: $('#seller-essays').data('seller-id') } );
        },
        fnDrawCallback : function() {
            $('[data-toggle="tooltip"]').tooltip();
            $("table#seller-essays").find('td:nth-child(7),th:nth-child(7)').hide();
        }

    });

    $('.essay-thumbnails').slick({
        dots: true
    });

    $("#essay_question, #essay_preview").redactor({
    });

    var text_max = 255;
    var text_min = 100;
    $('#essay_short_description').bind("change keyup input propertychange", function() {
        var text_length = $(this).val().length;

        if(text_length <= text_min){
            var text_to_go = text_min - text_length;
            $('#char-counter-1').text(text_to_go + ' character to go');
            if(text_to_go == 0){
                $('#char-counter-1').text('Min achieved!');
            }
        } else {
            $('#char-counter-1').text('Min achieved!');
        }
        if(text_length <= text_max){
            var text_remaining = text_max - text_length;
            $('#char-counter-2').text(text_remaining + ' character remaining');
        }
    });

    // $("#submit-paper").click(function(e){
    //     e.preventDefault();
    //
    //     var short_desc_length = $('#essay_short_description').val().length;
    //     if(short_desc_length < text_min){
    //         alert("Minimum characters for short description should be " + text_min);
    //     } else if(short_desc_length > text_max){
    //         alert("Maximum characters for short description should be " + text_max);
    //     } else {
    //         $(this).parents("form").submit();
    //     }
    // });

    $(".select-2").select2({
        //theme: "bootstrap"
    });
});
