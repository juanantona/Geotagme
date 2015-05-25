// AJAX call to download photos that aren't in db app

$(document).ready(function() 
{
    $.ajax(
    {
        url: "/render_new_photos",
        type: "GET",
        success: function(data){
            data.newPhotos.forEach(function(photo)
            {
                $("#photo-carrusel").append($("<li>").html(photo.photo_timestamps));
                var img = '<img src=' + photo.url + ' class="thumbnail">';
                $("#photo-carrusel").append(img);
            });
        },
        
        error: function()
        {
            console.log("nop");
        }
    });
});