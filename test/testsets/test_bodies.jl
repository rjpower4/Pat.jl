using Test
using Pat

@testset "Basic Construction" begin
    cb = Pat.CelestialBody(1.3, 1)
    @test Pat.gravitational_parameter(cb) == 1.3
    @test Pat.naif_id(cb) == 1

    @test Pat.gravitational_parameter(Pat.CelestialBody(12.3)) == 12.3
end