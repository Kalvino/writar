(function ( $ ) {

    $.fn.calculateCost = function(options) {

        // This is the easiest way to have default options.
        var settings = $.extend({
            academicLevel   : this.find('input:radio[name="order[academic_level]"]:checked').val(),
            deadline        : this.find('input:radio[name="order[hours_to_deadline]"]:checked').val(),
            pageCount       : this.find('#order_pages').val(),
            spacing         : this.find('input:radio[name="order[spacing]"]:checked').val(),
            wordsPerPage    : 275
        }, options);

        var spacingX = settings.spacing == "double" ? 1 : 2;
        var pageNum = parseInt(settings.pageCount);
        var totalWords = settings.wordsPerPage * settings.pageCount * spacingX;
        var deadline = moment().add(parseInt(settings.deadline),'hours').format('Do MMMM YYYY [at] h:mm a');
        
        $("#words-per-page").text(totalWords + " Words");
        $("b#estimated-deadline").text(deadline);
        switch(settings.academicLevel){
            case 'highschool':
                price = priceFor.highschool(settings.deadline) * spacingX * pageNum;
                price = $("#order-cost").hasClass('font-bold') ? price.toFixed(2) :  price;
                $("#order-cost").text("$" + price);
                break;
            case 'college':
                price = priceFor.college(settings.deadline) * spacingX * pageNum;
                price = $("#order-cost").hasClass('font-bold') ? price.toFixed(2) :  price;
                $("#order-cost").text("$" + price);
                break;
            case 'high school':
                price = priceFor.highschool(settings.deadline) * spacingX * pageNum;
                price = $("#order-cost").hasClass('font-bold') ? price.toFixed(2) :  price;
                $("#order-cost").text("$" + price);
                break;
            case 'university':
                price = priceFor.university(settings.deadline) * spacingX * pageNum;
                price = $("#order-cost").hasClass('font-bold') ? price.toFixed(2) :  price;
                $("#order-cost").text("$" + price);
                break;
            case 'masters':
                price = priceFor.masters(settings.deadline) * spacingX * pageNum;
                price = $("#order-cost").hasClass('font-bold') ? price.toFixed(2) :  price;
                $("#order-cost").text("$" + price);
                break;
            case 'phd':
                price = priceFor.phd(settings.deadline) * spacingX * pageNum;
                price = $("#order-cost").hasClass('font-bold') ? price.toFixed(2) :  price;
                $("#order-cost").text("$" + price);
                break;
            default:
                console.log(settings.academicLevel)
        }
    };

}( jQuery ));

var priceFor = {
    highschool: function(deadline) {
        deadline = parseInt(deadline);
        cost = 0;

        if (deadline <= 8) {
            cost = 24;
        } else if (deadline >= 9 && deadline <= 24) {
            cost = 22;
        } else if (deadline >= 25 && deadline <= 48) {
            cost = 20;
        } else if (deadline >= 49 && deadline <= 72) {
            cost = 18;
        } else if (deadline >= 73 && deadline <= 120) {
            cost = 16;
        } else if (deadline >= 121 && deadline <= 168) {
            cost = 14;
        } else {
            cost = 12
        }
        return cost;
    },

    college: function(deadline){
        deadline = parseInt(deadline);
        cost = 0;

        if (deadline <= 8) {
            cost = 26;
        } else if (deadline >= 9 && deadline <= 24) {
            cost = 24;
        } else if (deadline >= 25 && deadline <= 48) {
            cost = 22;
        } else if (deadline >= 49 && deadline <= 72) {
            cost = 20;
        } else if (deadline >= 73 && deadline <= 120) {
            cost = 18;
        } else if (deadline >= 121 && deadline <= 168) {
            cost = 16;
        } else {
            cost = 14
        }
        return cost;
    },

    university: function(deadline){
        deadline = parseInt(deadline);
        cost = 0;

        if (deadline <= 8) {
            cost = 28;
        } else if (deadline >= 9 && deadline <= 24) {
            cost = 26;
        } else if (deadline >= 25 && deadline <= 48) {
            cost = 24;
        } else if (deadline >= 49 && deadline <= 72) {
            cost = 22;
        } else if (deadline >= 73 && deadline <= 120) {
            cost = 20;
        } else if (deadline >= 121 && deadline <= 168) {
            cost = 18;
        } else {
            cost = 16
        }
        return cost;
    },

    masters: function(deadline){
        deadline = parseInt(deadline);
        cost = 0;

        if (deadline <= 8) {
            cost = 30;
        } else if (deadline >= 9 && deadline <= 24) {
            cost = 28;
        } else if (deadline >= 25 && deadline <= 48) {
            cost = 26;
        } else if (deadline >= 49 && deadline <= 72) {
            cost = 24;
        } else if (deadline >= 73 && deadline <= 120) {
            cost = 22;
        } else if (deadline >= 121 && deadline <= 168) {
            cost = 20;
        } else {
            cost = 18
        }
        return cost;
    },

    phd: function(deadline){
        deadline = parseInt(deadline);
        cost = 0;

        if (deadline <= 8) {
            cost = 60;
        } else if (deadline >= 9 && deadline <= 24) {
            cost = 35;
        } else if (deadline >= 25 && deadline <= 48) {
            cost = 33;
        } else if (deadline >= 49 && deadline <= 72) {
            cost = 31;
        } else if (deadline >= 73 && deadline <= 120) {
            cost = 29;
        } else if (deadline >= 121 && deadline <= 168) {
            cost = 27;
        } else {
            cost = 25
        }
        return cost;
    }
}

