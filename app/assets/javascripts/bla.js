$(document).ready(function() {
    $.ajax({
        url: "/bli",
        type: "GET",
        success: function(data){
            data.moreThings.forEach(function(thing){
                $("#thingsList").append($("<li>").html(thing));
            });
        },
        error: function(){
            console.log("nop");
        }
    });
});