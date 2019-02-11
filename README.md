# GRASS MapBoxGL Tutorial

## How to Host Your Animated GRASS simulations with MapBoxGL JS and GitHub

![HAND Methodology](./images/readmeBanner.gif)

## Requirements
* [GitHub Account](https://github.com/)
* [MapBox Account](https://www.mapbox.com/)
* [GRASS GIS - v7.6.0](https://grass.osgeo.org/download/)

## GitHub
1. Create [GitHub Account](https://github.com/) 
2. Create new [GitHub Repository](https://help.github.com/articles/creating-a-new-repository) 
3. G

## GRASS
1. Download GRASS 7.6.0
1. Run your favorite simulation
2. Use r.out.leaflet to generate bbox and pngs

## MapBox
1. Create account
2. Get public token
3. go to https://docs.mapbox.com/mapbox-gl-js/example/animate-images/
4. Create an empty file called index.html and copy and paste the following code into the document. [Original Code From MapBox](https://docs.mapbox.com/mapbox-gl-js/example/animate-images/)

```html
<!DOCTYPE html>
<html>
<head>
    <meta charset='utf-8' />
    <title>Animate a series of images</title>
    <meta name='viewport' content='initial-scale=1,maximum-scale=1,user-scalable=no' />
    <script src='https://api.tiles.mapbox.com/mapbox-gl-js/v0.53.0/mapbox-gl.js'></script>
    <link href='https://api.tiles.mapbox.com/mapbox-gl-js/v0.53.0/mapbox-gl.css' rel='stylesheet' />
    <style>
        body { margin:0; padding:0; }
        #map { position:absolute; top:0; bottom:0; width:100%; }
    </style>
</head>
<body>

<div id='map'></div>
<script>
mapboxgl.accessToken = '<YOUR MAPBOX TOKEN>';
var map = new mapboxgl.Map({
    container: 'map',
    style: 'mapbox://styles/mapbox/dark-v9',
    maxZoom: 5.99,
    minZoom: 4,
    zoom: 5,
    center: [-75.789, 41.874]
});

var frameCount = 5;
var currentImage = 0;

function getPath() {
    return "https://docs.mapbox.com/mapbox-gl-js/assets/radar" + currentImage + ".gif";
}

map.on('load', function() {

    map.addSource("radar", {
        type: "image",
        url: getPath(),
        coordinates: [
            [-80.425, 46.437],
            [-71.516, 46.437],
            [-71.516, 37.936],
            [-80.425, 37.936]
        ]
    });
    map.addLayer({
        id: "radar-layer",
        "type": "raster",
        "source": "radar",
        "paint": {
            "raster-fade-duration": 0
        }
    });

    setInterval(function() {
        currentImage = (currentImage + 1) % frameCount;
        map.getSource("radar").updateImage({ url: getPath() });
    }, 200);
});
</script>

</body>
</html>
```



