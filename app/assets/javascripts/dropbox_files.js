// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.
$(document).ready(function() 
{
    $.ajax(
    {
        url: "/download_photos",
        type: "GET",
        success: function(data){
            data.moreThings.forEach(function(photo)
            {
                $("#photo_carrusel").append($("<li>").html(photo.photo_timestamps));
                var img = '<img src=' + photo.url + ' class="thumbnail">';
                $("#photo_carrusel").append(img);
            });
        },
        
        error: function()
        {
            console.log("nop");
        }
    });
});