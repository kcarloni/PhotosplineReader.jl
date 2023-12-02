## PhotosplineReader.jl

[![Dev](https://img.shields.io/badge/docs-dev-blue.svg)](https://kcarloni.github.io/PhotosplineReader.jl/dev)
[![Build Status](https://github.com/kcarloni/PhotosplineReader.jl/workflows/CI/badge.svg)](https://github.com/kcarloni/PhotosplineReader.jl/actions)

source code adapted to julia from https://github.com/icecube/photospline, with help from `FITSIO.jl` and `BasicBSpline.jl`.

## Quick start
```julia
julia> using PhotosplineReader

julia> using PhotosplineReader.FITSIO

julia> fpath = "PhotosplineReader.jl/test/examples/IceCube_data_release_202209013_kdes/E_dec_photospline_v006_3D.fits";

julia> spt = FITS(fpath) do f
           SplineTable(f)
       end
3-dimensional SplineTable of b-spline orders [1, 1, 3],
with extents: 
	 (0.83, 10.21) 
	 (-0.17, 1.00) 
	 (0.57, 4.42) 


julia> x = [ 2.8, 0.2, 3.0 ]
3-element Vector{Float64}:
 2.8
 0.2
 3.0

julia> evaluate_simple( x, spt )
0.7973871961087491
```
