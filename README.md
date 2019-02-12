# GRASS MapBoxGL Tutorial

## How to Host Your Animated GRASS simulations with MapBoxGL JS and GitHub

![HAND Methodology](./images/readme/readmeBanner.gif)

## Requirements
* [GitHub Account](https://github.com/)
* [MapBox Account](https://www.mapbox.com/)
* [GRASS GIS - v7.6.0](https://grass.osgeo.org/download/)

## GitHub
1. Create [GitHub Account](https://github.com/) 
2. Fork and clone this project or create your own [GitHub Repository](https://help.github.com/articles/creating-a-new-repository) 
```

```
3. From your new repository click settings
![GitHub Settings](./images/readme/GitHubSettings.png)

4. From the settings page scroll down until you see *GitHub Pages* from the dropdown select *master branch*

![GitHub gh-pages](./images/readme/readmeGHPages.png)

5. Now all of your code will be hosted by GitHub at

https://<YourGitHubUserName>.github.io/GRASS_MapBoxGL_Tutorial/

## GRASS

> Install GRASS GIS if you don't have it

1. Run your favorite simulation
2. Use r.out.leaflet to generate bbox and pngs
    1. Inside of the images directory clone grass-web-publishing
    ```
    git clone https://github.com/ncsu-geoforall-lab/grass-web-publishing.git
    ```

> Full code at [https://github.com/ncsu-geoforall-lab/grass-web-publishing](https://github.com/ncsu-geoforall-lab/grass-web-publishing) thanks Vaclav!

3. From a running GRASS Session run the following in the terminal.

```
python ./r.out.leaflet/r.out.leaflet.py raster="example1,example2,example3" output="../images"
```

You will now see a few new files in the images directory

* data_file.csv
* data_file.js
* New pngs

Inside of data_file.js you will see the name of each of your new png files and the bounding boxes. We will load this file into our html document to get access to this information later.

## MapBox
1. Create an empty file in your project called index.html and copy the following code into the document.

```html
<!DOCTYPE html>
<html>
<head>
    <meta charset='utf-8' />
    <title>GRASS Animate Simulation</title>
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
<script src="./images/data_file.js">
<script>
//Sets up the map
mapboxgl.accessToken = '<YOUR MAPBOX TOKEN>';
var map = new mapboxgl.Map({
    container: 'map',
    zoom: 12,
    center: [-78.6319,35.7099],
    pitch: 45,
    style: 'mapbox://styles/mapbox/satellite-v9'
});

</script>

</body>
</html>
```

2. Create account at [MapBox](https://mapbox.com)

3. Once you are logged into MapBox retrieve your public token from [https://account.mapbox.com/](https://account.mapbox.com/)

4. Replace <YOUR MAPBOX TOKEN> from the index.html file you just created with your public token.

5. Add navigation controls to the map
```js
//Sets up the map
mapboxgl.accessToken = '<YOUR MAPBOX TOKEN>';
var map = new mapboxgl.Map({
    container: 'map',
    zoom: 12,
    center: [-78.6319,35.7099],
    pitch: 45,
    style: 'mapbox://styles/mapbox/satellite-v9'
});

//Add Navigation Controls
map.addControl(new mapboxgl.NavigationControl());

```

6. Next you will add a static raster layer to the map

```js

//We need to wait for the map to load before we add the raster layer
map.on('load', function() {
 
    //Create a new map source with the bounding box and url to your raster data.
    map.addSource("grass", {
        type: "image",
        //Gets the first image listed in images/data_file.js
        url: `./images/${layerInfos[0].file}`, 
        //Gets the bounds of the first image listed in images/data_file.js
        coordinates: `./images/${layerInfos[0].bounds}`
    });

    //Now add a new layer to the map from the source you created
    map.addLayer({
        id: "grass-layer",
        "type": "raster",
        "source": "grass",
        "paint": {
            "raster-fade-duration": 0
        }
    });
 
});

```

7. Now we will create an animation from the images

```js
//The total numbers of images found in data_file.js 
var frameCount = layerInfo.length;
//Default used to start animation with first image
var currentImage = 0;

//Gets the current image
function getPath() {
    return `./images/${layerInfos[currentImage].file}`;
}
 
//We need to wait for the map to load before we add the raster layer
map.on('load', function() {
 
    //Create a new map source with the bounding box and url to your raster data.
    map.addSource("grass", {
        type: "image",
        //Replace static file with function
        url: getPath(), 
        //Gets the bounds of the first image listed in images/data_file.js
        coordinates: `./images/${layerInfos[0].bounds}`
    });

    //Now add a new layer to the map from the source you created
    map.addLayer({
        id: "grass-layer",
        "type": "raster",
        "source": "grass",
        "paint": {
            "raster-fade-duration": 0
        }
    });

    //Will update image every 200ms
    setInterval(function() {
        currentImage = (currentImage + 1) % frameCount;
        map.getSource("grass").updateImage({ url: getPath() });
    }, 200);
 
});

```

Now when you load your index.html into the browser you should see the animation.

**This is what your index.html file should now look like with the mapbox token replaced**

```html
<!DOCTYPE html>
<html>
<head>
    <meta charset='utf-8' />
    <title>GRASS Animate Simulation</title>
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
<!-- Loads data from data_file.js -->
<script src="./images/data_file.js">
<script>

//Sets up the map
mapboxgl.accessToken = '<YOUR MAPBOX TOKEN>';
var map = new mapboxgl.Map({
    container: 'map',
    zoom: 12,
    center: [-78.6319,35.7099],
    pitch: 45,
    style: 'mapbox://styles/mapbox/satellite-v9'
});

//The total numbers of images found in data_file.js 
var frameCount = layerInfo.length;
//Default used to start animation with first image
var currentImage = 0;
 
//Gets the current image 
function getPath() {
    return `./images/${layerInfos[currentImage].file}`;
}
 
//We need to wait for the map to load before we add the raster layer
map.on('load', function() {
 
    //Create a new map source with the bounding box and url to your raster data.
    map.addSource("grass", {
        type: "image",
        //Replace static file with function
        url: getPath(), 
        //Gets the bounds of the first image listed in images/data_file.js
        coordinates: `./images/${layerInfos[0].bounds}`
    });

    //Now add a new layer to the map from the source you created
    map.addLayer({
        id: "grass-layer",
        "type": "raster",
        "source": "grass",
        "paint": {
            "raster-fade-duration": 0
        }
    });

    //Will update image every 200ms
    setInterval(function() {
        currentImage = (currentImage + 1) % frameCount;
        map.getSource("grass").updateImage({ url: getPath() });
    }, 200);
 
});

</script>

</body>
</html>
```

[Original Code From MapBox](https://docs.mapbox.com/mapbox-gl-js/example/animate-images/)

