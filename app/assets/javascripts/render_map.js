 var osmUrl = 'http://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
     osmAttrib = '&copy; <a href="http://openstreetmap.org/copyright">OpenStreetMap</a> contributors',
     osm = L.tileLayer(osmUrl, {maxZoom: 18, attribution: osmAttrib});

 var arrayOfLatLngs = [];
        arrayOfLatLngs.push(new L.LatLng(46.52033333333333,7.32));
        arrayOfLatLngs.push(new L.LatLng(-22.946,-43.181666666666665));

 var bounds = new L.LatLngBounds(arrayOfLatLngs);    

 var map = new L.Map('mymap', 
 {
        center: bounds.getCenter(),
        zoom: 5,
        layers: [osm],
 });

map.fitBounds(bounds);

var popup = L.popup();

function showPopup(coord){
        var lat =  Number(coord.split(',')[0]);
        var lon =  Number(coord.split(',')[1]);
        var latlon = new L.LatLng(lat, lon);
        popup
        .setLatLng(latlon)
        .setContent("This photo was taken here")
        .openOn(map);
        map.setView(latlon)
};
   






    
   

           