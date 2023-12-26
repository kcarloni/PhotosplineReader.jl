## PhotosplineReader.jl

[![Dev](https://img.shields.io/badge/docs-dev-blue.svg)](https://kcarloni.github.io/PhotosplineReader.jl/dev)
[![Build Status](https://github.com/kcarloni/PhotosplineReader.jl/workflows/CI/badge.svg)](https://github.com/kcarloni/PhotosplineReader.jl/actions)

source code adapted to julia from https://github.com/icecube/photospline, with help from `FITSIO.jl` and `BasicBSpline.jl`.

## Quick start
```julia
julia> using PhotosplineReader

julia> using PhotosplineReader.FITSIO

julia> fpath = "PhotosplineReader.jl/test/examples/IceCube_data_release_202209013_kdes/E_dec_photospline_v006_3D.fits";

julia> spt = SplineTable( fpath )
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

julia> spt(x)
0.7973871961087491

julia> spt(x...)
0.7973871961087491
```

## Interfacing with Interpolations.jl
```julia
julia> using Interpolations

julia> spt = SplineTable( fpath )
3-dimensional SplineTable of b-spline orders [1, 1, 3],
with extents:
    (0.83, 10.21)
    (-0.17, 1.00)
    (0.57, 4.42)

julia> itp = spline_interpolation( spt );

julia> typeof( itp )
Interpolations.FilledExtrapolation{Float64, 3, ScaledInterpolation{Float32, 3, Interpolations.BSplineInterpolation{Float32, 3, Array{Float32, 3}, Tuple{BSpline{Linear{Throw{OnGrid}}}, BSpline{Linear{Throw{OnGrid}}}, BSpline{Cubic{Line{OnGrid}}}}, Tuple{Base.Slice{UnitRange{Int64}}, Base.Slice{UnitRange{Int64}}, Base.Slice{UnitRange{Int64}}}}, Tuple{BSpline{Linear{Throw{OnGrid}}}, BSpline{Linear{Throw{OnGrid}}}, BSpline{Cubic{Line{OnGrid}}}}, Tuple{StepRangeLen{Float64, Base.TwicePrecision{Float64}, Base.TwicePrecision{Float64}, Int64}, StepRangeLen{Float64, Base.TwicePrecision{Float64}, Base.TwicePrecision{Float64}, Int64}, StepRangeLen{Float64, Base.TwicePrecision{Float64}, Base.TwicePrecision{Float64}, Int64}}}, Tuple{BSpline{Linear{Throw{OnGrid}}}, BSpline{Linear{Throw{OnGrid}}}, BSpline{Cubic{Line{OnGrid}}}}, Float64}

julia> itp( x... )
0.7973871961087493

julia> Interpolations.gradient( itp, x... )
3-element StaticArraysCore.SVector{3, Float64} with indices SOneTo(3):
 -1.0382749146578347
 -0.4631499529505209
  0.08274258979323065
```