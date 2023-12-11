
# --------------------
# type definition
# --------------------

struct SplineTable{N}

    ndim :: Int
    orders :: SVector{N, Int}
    naxes  :: SVector{N, Int}
    nknots :: SVector{N, Int}

    extents:: SArray{Tuple{2, N}, Float64}

    coeffs
    knots 
end

# --------------------
# constructors
# --------------------

function SplineTable( ndim, orders, extents, knots, coeffs )

    nknots = length.( knots )
    naxes = size( coeffs )

    SplineTable{ndim}(
        ndim, orders, naxes, nknots, 
        extents,
        coeffs, 
        knots,
    )
end

"""
    SplineTable( f::FITS )

read `FITS` file `f` into a `SplineTable` struct.
"""
function SplineTable( f::FITS )

    ndim = ndims( f[1] )
    
    hdr = read_header( f[1] ) 
    orders = [ hdr["ORDER$i"] for i in 0:(ndim-1) ]
    
    # need to reverse ordering...
    coeffs = permutedims( read( f[1] ), ndim:-1:1 )
    
    knots = [ try_make_uniform(read(f[i])) for i in 2:(ndim+1) ]
    extents = read( f[ndim+2] )

    return SplineTable( ndim, orders, extents, knots, coeffs)
end

# -----------------

(f::SplineTable)(x) = evaluate_simple(x, f)

function Base.show( io::IO, spt::SplineTable )

    print(io, spt.ndim, "-dimensional SplineTable of b-spline orders ", spt.orders, ",\n")
    print(io, "with extents:")
    for d in 1:spt.ndim
        @printf(io, "\n    (%.2f, %.2f)", spt.extents[:, d]...)
    end
    
end