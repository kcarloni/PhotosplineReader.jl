
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

read a `FITS` file into a `SplineTable` struct.
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
(f::SplineTable{N})(x...) where N = evaluate_simple( SVector{N, Float64}(x), f )

function Base.show( io::IO, spt::SplineTable )

    print(io, spt.ndim, "-dimensional SplineTable of b-spline orders ", spt.orders, ",\n")
    print(io, "with extents:")
    for d in 1:spt.ndim
        @printf(io, "\n    (%.2f, %.2f)", spt.extents[:, d]...)
    end
    
end


# -----------------

"""
    spline_interpolation( spt::SplineTable )
    spline_interpolation( f::FITS )

make an Interpolation object from a given SplineTable.
note that this method assumes that spline padding knots are symmetric on both sides,
and that it Interpolations supports only up to cubic-order B-splines.
"""
function spline_interpolation( spt::SplineTable )

    buffers = ( spt.nknots .- size(spt.coeffs) ) .÷ 2
    knots = Tuple(
        spt.knots[d][( 1+buffers[d] ):( end-buffers[d]) ]
        for d in 1:spt.ndim
    )
    nknots = length.( knots )

    orders = ( 
        Constant(), Linear(), Quadratic(), Cubic() ) 
    
    bsp = Tuple( BSpline(orders[o+1]) for o in spt.orders )

    itp = Interpolations.BSplineInterpolation(
        eltype(spt.coeffs),
        spt.coeffs, 
        bsp, 
        range.(1, nknots)
    )
    sitp = scale(itp, knots... );
    esitp = extrapolate(sitp, 0.)
end

spline_interpolation( f::FITS ) = 
    spline_interpolation( SplineTable(f) )