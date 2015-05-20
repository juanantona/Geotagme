// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.
$(document).ready(function() 
{
    $.ajax(
    {
        url: "/download_photos",
        type: "GET",
        success: function(data){
            data.moreThings.forEach(function(thing){
                $("#photo_carrusel").append($("<li>").html(thing));
            });
        },
        error: function(){
            console.log("nop");
        }
    });
});