

# check for uniform knots -- computational speed-up
function try_make_uniform( kvec )

    kunif = range( kvec[1], kvec[end], length=length(kvec) )

    if all( isapprox.(kunif, kvec) );   return kunif
    else;                               return kvec
    end
end
