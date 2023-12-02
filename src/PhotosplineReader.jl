module PhotosplineReader

using FITSIO
using BasicBSpline
using StaticArrays

# structs
export SplineTable

# evaluation functions:
export evaluate_simple

include("_utils.jl")
include("_SplineTable.jl")
include("_core.jl")
include("_functions.jl")

end
