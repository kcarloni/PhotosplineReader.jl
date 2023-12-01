
source code adapted to julia from `https://github.com/icecube/photospline`,

with help from `FITSIO.jl` and `BasicBSpline.jl`


```julia

(@v1.8) pkg> activate .
  Activating project at `/mnt/ceph1-npx/user/kcarloni/software_julia-packages/PhotosplineReader.jl`

julia> include("read_splinetable.jl")
evaluate_simple (generic function with 1 method)

julia> fdir = "examples/IceCube_data_release_202209013_kdes/"
"examples/IceCube_data_release_202209013_kdes/"

julia> fname = "sig_E_psi_photospline_v006_4D.fits"
"sig_E_psi_photospline_v006_4D.fits"

julia> f = FITS( fdir*fname )
File: examples/IceCube_data_release_202209013_kdes/sig_E_psi_photospline_v006_4D.fits
Mode: "r" (read-only)
HDUs: Num  Name     Type   
      1             Image  
      2    KNOTS0   Image  
      3    KNOTS1   Image  
      4    KNOTS2   Image  
      5    KNOTS3   Image  
      6    EXTENTS  Image  

julia> spt = SplineTable( f );

julia> close( f )

julia> spt.extents
2×4 SMatrix{2, 4, Float64, 8} with indices SOneTo(2)×SOneTo(4):
 -3.04991    0.89732  -5.95443  0.569375
 -0.371133  10.1487    0.74443  4.41938

julia> spt.knots
4-element Vector{StepRangeLen{Float64, Base.TwicePrecision{Float64}, Base.TwicePrecision{Float64}, Int64}}:
 -3.0681350994464043:0.01822298523780999:-0.3529102990127157
 0.8343855738639832:0.06293471747596792:10.211658477783203
 -6.0:0.04557046979865772:0.79
 0.41937500000000016:0.049999999999999996:4.569375

julia> spt.orders
4-element SVector{4, Int64} with indices SOneTo(4):
 1
 1
 1
 3

julia> x = @SVector[ -2.8, 4, -4, 3]
4-element SVector{4, Float64} with indices SOneTo(4):
 -2.8
  4.0
 -4.0
  3.0

julia> evaluate_simple( x, spt )
0.004577046073730665

julia> using BenchmarkTools

julia> @benchmark evaluate_simple( x, spt )
BenchmarkTools.Trial: 10000 samples with 1 evaluation.
 Range (min … max):  13.915 μs …  4.560 ms  ┊ GC (min … max): 0.00% … 0.00%
 Time  (median):     17.988 μs              ┊ GC (median):    0.00%
 Time  (mean ± σ):   18.867 μs ± 45.485 μs  ┊ GC (mean ± σ):  0.00% ± 0.00%

        ▄▄       ▄█▇▆▃    ▂▃▁                                  
  ▂▁▂▂▃▇███▅▃▂▂▃▆██████▆▅██████▇▆▆▅▄▃▄▃▃▃▃▃▃▂▂▂▂▂▂▃▃▂▂▂▂▂▂▂▂▂ ▄
  13.9 μs         Histogram: frequency by time        26.4 μs <

 Memory estimate: 7.73 KiB, allocs estimate: 101.


```
