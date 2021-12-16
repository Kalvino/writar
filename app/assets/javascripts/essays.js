$(document).ready(function(){

    $(".download-paper").click(function(e){
        e.preventDefault();

        $('.download-paper').addClass("disabled").text("Please wait...");

        window.location.href = $(this).attr("href");
    });

    if($("#essays_show").length){
        $("html,body").animate({ scrollTop: 228 }, 'slow');
    }

    $(".readmore").readmore({
        speed: 100,
        moreLink: '<a href="#"><i class="fa fa-plus-square"></i> Read more</a>',
        lessLink: '<a href="#"><i class="fa fa-minus-square"></i> Read less</a>',
        collapsedHeight: 500,
        afterToggle: function(trigger, element, expanded) {
            if(! expanded) { // The "Close" link was clicked
                $('html, body').animate( { scrollTop: element.offset().top }, { duration: 500 } );
            }
            $(".readmore").next('a').css({'margin-top': '15px', 'text-align': "center"});
        },
        beforeToggle: function() {
            $(".readmore").next('a').css({'margin-top': '15px', 'text-align': "center"});
        }
    });

    $(".readmore").next('a').css({'margin-top': '15px', 'text-align': "center"});

    var searchBox = $("#query");
    if (searchBox.length) {
        var essays_autocomplete_url = searchBox.parents('form').attr("action");

        searchEngine = new Bloodhound({
            identify: function (o) {
                return o.id;
            },
            queryTokenizer: Bloodhound.tokenizers.whitespace,
            datumTokenizer: Bloodhound.tokenizers.obj.whitespace('title'),
            dupDetector: function (a, b) {
                return a.id === b.id;
            },
            remote: {
                url: essays_autocomplete_url + '?query=%QUERY',
                wildcard: '%QUERY'
            }
        });

        searchBox.typeahead({
            minLength: 5,
            highlight: true,
            hint: true
        }, {
            source: searchEngine,
            displayKey: 'title',
            templates:{
                suggestion:function(data) {
                    return "<div><strong>"+ data.title +"</strong><p class='search'>"+ data.question +"</p></div>";
                }
            }
        });

        searchBox.bind('typeahead:select', function(ev, suggestion) {
            window.location.href = suggestion.url;
        });
    }
});
