using Test
using Pat

@testset "Basic Two Body Functionality" begin
    sma = 10_000.0
    ecc = 0.4
    ta = π / 4

    @test Pat.parameter(sma, ecc) == 8_400

    @testset "Apsis Radii" begin
        @test Pat.periapsis_radius(sma, ecc) == 6_000
        @test Pat.apoapsis_radius(sma, ecc) == 14_000
    end

    @test Pat.radius(sma, ecc, ta) ≈ 6.547957842623e3

    @testset "Eccentricity" begin
        @test Pat.isclosed(0.0) == true
        @test Pat.isclosed(0.3) == true
        @test Pat.isclosed(0.9) == true
        @test Pat.isclosed(1.0) == false
        @test Pat.isclosed(1.1) == false

        @test Pat.iscircular(0.0) == true
        @test Pat.iscircular(0.3) == false
        @test Pat.iscircular(0.9) == false
        @test Pat.iscircular(1.0) == false
        @test Pat.iscircular(1.1) == false

        @test Pat.iselliptical(0.0) == true
        @test Pat.iselliptical(0.3) == true
        @test Pat.iselliptical(0.9) == true
        @test Pat.iselliptical(1.0) == false
        @test Pat.iselliptical(1.1) == false

        @test Pat.isparabolic(0.0) == false
        @test Pat.isparabolic(0.3) == false
        @test Pat.isparabolic(0.9) == false
        @test Pat.isparabolic(1.0) == true
        @test Pat.isparabolic(1.1) == false

        @test Pat.ishyperbolic(0.0) == false
        @test Pat.ishyperbolic(0.3) == false
        @test Pat.ishyperbolic(0.9) == false
        @test Pat.ishyperbolic(1.0) == false
        @test Pat.ishyperbolic(1.1) == true
    end

    @test Pat.circular_velocity(12_000, 100) ≈ 1.095445115010e1
    @test Pat.mean_motion(12_000, 100) ≈ 1.095445115010e-1
    @test Pat.period(12_000, 100) ≈ 5.735737209545e1
    @test Pat.angular_momentum(12_000, sma, ecc) ≈ 1.003992031841e4
    @test Pat.flight_path_angle(sma, ecc, ta) ≈ 2.170092525064e-1
end