using SafeTestsets

@safetestset "Constants Test" begin include("testsets/test_constants.jl") end
@safetestset "Dimensions Test" begin include("testsets/test_dimensions.jl") end
@safetestset "Body Test" begin include("testsets/test_bodies.jl") end
@safetestset "Two Body" begin include("testsets/test_twobody.jl") end