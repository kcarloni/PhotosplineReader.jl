

# see https://github.com/icecube/photospline/blob/master/include/photospline/detail/bspline_eval.h#L10
function search_centers!( centers, x, nd, knots, orders, naxes, nknots )

    for d in 1:nd 

        # ensure we are w/in the knot boundaries
        if ( x[d] <= knots[d][1] ) || ( x[d] > knots[d][end] )
            return false
        end

        # If we're only a few knots in, take the center to be
		# the nearest fully-supported knot.

        if ( x[d] < knots[d][ 1+orders[d] ] )
            centers[d] = 1+orders[d]

        elseif ( x[d] >= knots[d][ 1+naxes[d] ] )
            centers[d] = naxes[d]

        else
            # binary search:
            min = orders[d] + 1
            max = nknots[d] - 1

            c = (max + min) ÷ 2

            while ( x[d] < knots[d][c] ) || ( x[d] >= knots[d][ c+1 ] )

                c = (max + min) ÷ 2

                if ( x[d] < knots[d][c] );  max = c - 1
                else;                       min = c + 1
                end
            end

            centers[d] = c
        end

        # ...
        (centers[d] == naxes[d]+1) && (centers[d] -= 1)
        
    end
    return true
end

function search_centers( x, nd, knots, orders, naxes, nknots )
    centers = Vector{Int}(undef, nd)
    search_success = search_centers!( centers, x, nd, knots, orders, naxes, nknots)
    if search_success
        return centers
    else
        return false
        # throw( DomainError(x, "is outside of $(extrema.(knots))") )
    end
end

# see https://github.com/icecube/photospline/blob/master/include/photospline/detail/bspline_eval.h#L58
function ndsplineeval_core( centers, local_basis, coeffs, orders, nd )

    nchunks = prod( orders .+ 1 )
    result = 0.

    iter_pos = Base.Iterators.product( range.(0, orders)... )
    for pos in iter_pos

        basis_tree_term = prod( local_basis[b+1, d] for (d,b) in enumerate(pos) )
        coeff_term = coeffs[ (centers .- orders .+ pos)... ]

        result += basis_tree_term * coeff_term
    end
    return result 
end

# convenience constructor: 
KnotVector( kvec::T ) where T <: StepRangeLen = UniformKnotVector(kvec)

function ndsplineeval( x, centers, derivatives_bool, knots, coeffs, orders, nd, nknots )

    local_basis = Array{Float64}(undef, maximum(orders)+1, nd )

    # iterate over dimensions to get local basis: 
    for d in 1:nd
        bsp_space = BSplineSpace{ orders[d] }( KnotVector(knots[d]) )

        if derivatives_bool[d]
            throw( ErrorException( "haven't really checked derivs yet sorry ") )
            # local_basis[:, d] .= bsplinebasisall( BSplineDerivativeSpace{1}(bsp_space), centers[d]-1, x[d] )

        else

            # handle edges... see https://github.com/icecube/photospline/blob/master/include/photospline/bspline.h#L44
            if ( centers[d]-1 == orders[d] ) && ( x[d] < knots[d][centers[d]] ) 
                local_basis[ 1, d ] = bsplinebasis( bsp_space, 1, x[d] )
                local_basis[ 2:(orders[d]+1), d ] .= 0.

            elseif ( centers[d] == nknots[d] - ( orders[d] + 1) ) && ( x[d] > knots[d][centers[d]+1] )
                local_basis[ 1:orders[d], d] .= 0.
                local_basis[ orders[d]+1, d ] = bsplinebasis( bsp_space, centers[d], x[d] )

            else
                local_basis[1:(orders[d]+1), d] .= bsplinebasisall( bsp_space, centers[d]-orders[d], x[d] )
            end
        end
    end
    return ndsplineeval_core( centers, local_basis, coeffs, orders, nd )
end
