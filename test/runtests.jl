using Test

using PhotosplineReader: SplineTable
using PhotosplineReader.FITSIO


const ICECUBE_BASE = joinpath(@__DIR__, "examples/IceCube_data_release_202209013_kdes/")

@testset "Basic I/O" begin
    spt = FITS(joinpath(ICECUBE_BASE, "E_dec_photospline_v006_3D.fits")) do f
        SplineTable( f )
    end
    @test spt.extents ≈ [0.8343855738639832 -0.17364817766693033 0.569375; 10.211658477783203 1.0 4.4193750000000005]
end