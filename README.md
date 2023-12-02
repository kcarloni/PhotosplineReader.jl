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
PhotosplineReader.SplineTable{3}(3, [1, 1, 3], [150, 150, 80], [152, 152, 84], [0.8343855738639832 -0.17364817766693033 0.569375; 10.211658477783203 1.0 4.4193750000000005], Float32[0.0 0.0 … 0.0 0.0; 0.0 0.0 … 0.0 0.0; … ; 0.0 0.0 … 0.0 0.0; 0.0 0.0 … 0.0 0.0;;; 0.0 0.0 … 0.0 0.0; 0.0 0.0 … 0.0 0.0; … ; 0.0 0.0 … 0.0 0.0; 0.0 0.0 … 0.0 0.0;;; 0.0 0.0 … 0.0 0.0; 0.0 0.0 … 0.0 0.0; … ; 0.0 0.0 … 0.0 0.0; 0.0 0.0 … 0.0 0.0;;; … ;;; 0.0 0.0 … 0.0 0.0; 0.0 0.0 … 0.0 0.0; … ; 0.0 0.0 … 0.0 0.0; 0.0 0.0 … 0.0 0.0;;; 0.0 0.0 … 0.0 0.0; 0.0 0.0 … 0.0 0.0; … ; 0.0 0.0 … 0.0 0.0; 0.0 0.0 … 0.0 0.0;;; 0.0 0.0 … 0.0 0.0; 0.0 0.0 … 0.0 0.0; … ; 0.0 0.0 … 0.0 0.0; 0.0 0.0 … 0.0 0.0], sStepRangeLen{Float64, Base.TwicePrecision{Float64}, Base.TwicePrecision{Float64}, Int64}[0.7714508563880152:0.06293471747596792:10.274593195259172, -0.18152501107409094:0.007876833407160607:1.0078768334071606, 0.41937500000000016:0.049999999999999996:4.569375])

julia> spt.extents
2×3 SMatrix{2, 3, Float64, 6} with indices SOneTo(2)×SOneTo(3):
  0.834386  -0.173648  0.569375
 10.2117     1.0       4.41938

julia> spt.knots
3-element Vector{StepRangeLen{Float64, Base.TwicePrecision{Float64}, Base.TwicePrecision{Float64}, Int64}}:
 0.7714508563880152:0.06293471747596792:10.274593195259172
 -0.18152501107409094:0.007876833407160607:1.0078768334071606
 0.41937500000000016:0.049999999999999996:4.569375

julia> spt.orders
3-element SVector{3, Int64} with indices SOneTo(3):
 1
 1
 3

julia> x = @SVector[ 2.8, 0.2, 3.0]
3-element SVector{3, Float64} with indices SOneTo(3):
 2.8
 0.2
 3.0

julia> PhotosplineReader.evaluate_simple( x, spt )
0.7973871961087491
```
