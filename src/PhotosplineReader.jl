module PhotosplineReader

using FITSIO
using BasicBSpline
using StaticArrays
using Printf

# structs
export SplineTable

# evaluation functions:
export evaluate_simple
export (f::SplineTable)(x) = evaluate_simple(x, f)

include("_utils.jl")
include("_SplineTable.jl")
include("_core.jl")
include("_functions.jl")

end
