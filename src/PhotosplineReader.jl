module PhotosplineReader

using FITSIO
using BasicBSpline
using Interpolations
using StaticArrays
using Printf

# structs
export SplineTable

export spline_interpolation

# evaluation functions:
export evaluate_simple

include("_utils.jl")
include("_SplineTable.jl")
include("_core.jl")
include("_functions.jl")

end
