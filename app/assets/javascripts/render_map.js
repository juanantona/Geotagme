 var osmUrl = 'http://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
     osmAttrib = '&copy; <a href="http://openstreetmap.org/copyright">OpenStreetMap</a> contributors',
     osm = L.tileLayer(osmUrl, {maxZoom: 18, attribution: osmAttrib});

 var arrayOfLatLngs = [];
              arrayOfLatLngs.push(new L.LatLng(30.74656, -5.33936));
              arrayOfLatLngs.push(new L.LatLng(29.95018, -6.78406));
              arrayOfLatLngs.push(new L.LatLng(30.47472, -5.42175));
              arrayOfLatLngs.push(new L.LatLng(42.71473, 1.71387));

 var bounds = new L.LatLngBounds(arrayOfLatLngs);    

 var map = new L.Map('mymap', 
 {
      center: bounds.getCenter(),
      zoom: 5,
      layers: [osm],
 });

map.fitBounds(bounds);

var popup = L.popup();

function onMapClick(e) 
{
  popup
  .setLatLng(e.latlng)
  .setContent("You clicked the map at " + e.latlng.toString())
  .openOn(map);
}
map.on('click', onMapClick);

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






    
   

           