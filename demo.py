#!/usr/bin/env python

import grass.script as gscript

def main():
    #Location: nc_spm_08_grass7
    #Run Hand Methodology with 3m inundation at 0.5m intervals
    gscript.run_command("r.watershed", elevation="elevation", accumulation="flowacc", drainage="drainage", stream="streams", threshold=100000, overwrite=True)
    gscript.run_command("r.to.vect", input="streams", output="streams", type="line", overwrite=True)
    gscript.run_command("r.stream.distance", stream_rast="streams", direction="drainage", elevation="elevation", method="downstream", difference="above_stream", overwrite=True)
    gscript.run_command("r.lake.series", elevation="above_stream", start_water_level=0, end_water_level=3, water_level_step=0.5, output="inun", seed_raster="streams", overwrite=True)

if __name__ == '__main__':
    main()