

search_centers( x, spt::SplineTable ) = search_centers( x, spt.ndim, spt.knots, spt.orders, spt.naxes, spt.nknots )

"""

    evaluate_simple( x, spt::SplineTable )

evalute the spline at `x`.
"""
function evaluate_simple( x, spt::SplineTable )

    centers = search_centers( x, spt.ndim, spt.knots, spt.orders, spt.naxes, spt.nknots )
    
    # following https://github.com/icecube/photospline/blob/master/src/python/photosplinemodule.cpp#L934
    (centers == false) && ( return 0. )

    calc_derivs = fill( false, spt.ndim )

    ndsplineeval( 
        x, centers, calc_derivs, 
        spt.knots, spt.coeffs, spt.orders, spt.ndim, spt.nknots
    )
end