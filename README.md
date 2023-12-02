## PhotosplineReader.jl

[![Dev](https://img.shields.io/badge/docs-dev-blue.svg)](https://kcarloni.github.io/PhotosplineReader.jl/dev)
[![Build Status](https://github.com/kcarloni/PhotosplineReader.jl/workflows/CI/badge.svg)](https://github.com/kcarloni/PhotosplineReader.jl/actions)

source code adapted to julia from https://github.com/icecube/photospline, with help from `FITSIO.jl` and `BasicBSpline.jl`.

## Quick start
```julia
julia> using PhotosplineReader

julia> using PhotosplineReader.StaticArrays

julia> using PhotosplineReader.FITSIO

julia> spt = FITS("./test/examples/IceCube_data_release_202209013_kdes/E_dec_photospline_v006_3D.fits") do f
           PhotosplineReader.SplineTable(f)
       end
3-dimensional SplineTable of b-spline orders [1, 1, 3],
with extents: 
	 (0.83, 10.21) 
	 (-0.17, 1.00) 
	 (0.57, 4.42) 

julia> x = @SVector[ 2.8, 0.2, 3.0 ]
3-element SVector{3, Float64} with indices SOneTo(3):
 2.8
 0.2
 3.0

julia> PhotosplineReader.evaluate_simple( x, spt )
0.7973871961087491
```
