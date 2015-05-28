// AJAX call to download photos that are not in db app

$(document).ready(function() 
{
    if($("#dashboard").length>0)
    {
         $.ajax(
         {
            url: "/render_new_photos",
            type: "GET",
            success: function(data){
                data.newPhotos.forEach(function(photo)
                {
                    $("#photo-carrusel").append($("<li>").html(photo.photo_timestamps));
                    var lon = Number(photo.geolocation.split(" ")[1].replace('(',''));
                    var lat = Number(photo.geolocation.split(" ")[2].replace(')',''));
                    var coord = [];
                        coord.push(lon);
                        coord.push(lat); 
                    var img = '<img src=' + photo.url + ' id=' + coord + ' class="thumbnail" onclick="showPopup(id)"/>';
                    $("#photo-carrusel").append(img);
                    L.marker([lon, lat], {draggable: false}).addTo(map)
                });
            },
            
            error: function()
            {
                console.log("nop");
            }
         });
    }
   
});