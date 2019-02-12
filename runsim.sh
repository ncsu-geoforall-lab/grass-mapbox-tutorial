#!/bin/sh
# Easy GRASS VIZ 
# Author: Corey White
# 2/11/19
#TODO Automate starting grass and running sample from bash script
g.extension r.stream.distance
g.extension r.lake.series 
r.watershed elevation=elevation accumulation=flowacc drainage=drainage stream=streams threshold=100000 --overwrite
r.to.vect input=streams output=streams type=line --overwrite
r.stream.distance stream_rast=streams direction=drainage elevation=elevation method=downstream difference=above_stream --overwrite
r.lake.series elevation=above_stream start_water_level=0 end_water_level=4 water_level_step=0.5 output=inun seed_raster=streams --overwrite

#Get r.out.leaflet plugin
DIRECTORY=./images/grass-web-publishing
if [ ! -d "$DIRECTORY" ]; then
  git clone https://github.com/ncsu-geoforall-lab/grass-web-publishing.git
  mv grass-web-publishing images/
fi
 
python ./images/grass-web-publishing/r.out.leaflet/r.out.leaflet.py raster="inun_0.0,inun_0.5,inun_1.0,inun_1.5,inun_2.0,inun_2.5,inun_3.0,inun_3.5,,inun_4.0" output="./images"

exit 0