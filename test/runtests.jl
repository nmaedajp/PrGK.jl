using PrGK
using Test
# using Random

@testset "PrGK.jl" begin
    # Write your tests here.
end

@testset "PrGK deg↔dms roundtrip" begin
    # 代表値テスト（sec_digits は往復誤差に効く）
    vals = [
        0.0,
        135.5,
        -12.0,
        -0.1,
        179.9999999,
        -0.00027778,  # およそ -1 秒
        12.345678
    ]

    for v in vals
        d, m, s = PrGK.deg2dms(v; sec_digits=6)
        v2 = PrGK.dms2deg(d, m, s)
        @test isapprox(v, v2; atol=1e-6)
    end

    # # ランダムテスト（-360°〜360°の広めの範囲）
    # rng = MersenneTwister(20250831)
    # for _ in 1:200
    #     v = (rand(rng) * 720.0) - 360.0
    #     d, m, s = PrGK.deg2dms(v; sec_digits=6)
    #     v2 = PrGK.dms2deg(d, m, s)
    #     @test isapprox(v, v2; atol=1e-6)
    # end
end
