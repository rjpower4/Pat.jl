using SafeTestsets

@safetestset "Placeholder Test Set" begin
    using Test
    using Pat
    @testset "Placeholder test" begin
        @test sqrt(4) == 2 
    end 
end