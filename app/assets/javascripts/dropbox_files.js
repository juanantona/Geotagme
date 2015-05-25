// AJAX call to download photos that aren't in db app

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