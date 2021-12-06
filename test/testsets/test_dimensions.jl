# Copyright (c) 2021, Rolfe Power

using Test
using Pat: DimensionSet, mass, velocity, acceleration, area, volume, force, density

@testset "Basic Construction" begin
    ds = DimensionSet(3.0, 4.0, 5.0)
    @test mass(ds) == 3.0
    @test length(ds) == 4.0
    @test time(ds) == 5.0
end

@testset "Default Construction" begin
    ds = DimensionSet()
    @test mass(ds) == 1
    @test length(ds) == 1
    @test time(ds) == 1
end

@testset "Single Value Construction" begin
    k = rand(Float64) + 1.0
    ds = DimensionSet(k)
    @test mass(ds) == k
    @test length(ds) == k
    @test time(ds) == k
    @test_throws DomainError DimensionSet(0)
    @test_throws DomainError DimensionSet(-1.0)
end

@testset "Keyword Construction" begin
    ds = DimensionSet(mass=3.0, length=4.0, time=5.0)
    @test ds == DimensionSet(3, 4, 5)
    @test mass(ds) == 3.0
    @test length(ds) == 4.0
    @test time(ds) == 5.0
    @test_throws DomainError DimensionSet(mass=-1, length=1, time=1)
    @test_throws DomainError DimensionSet(mass=1, length=-1, time=1)
    @test_throws DomainError DimensionSet(mass=1, length=1, time=-1)
end

@testset "Derived Quantities" begin
    m = 3.0
    l = 4.0
    t = 5.0
    v = 0.8
    a = 0.16
    ar = 16.0
    vol = 64.0
    f = 0.48
    d = 3//64

    ds = DimensionSet(m, l, t)
    @test velocity(ds) == v
    @test acceleration(ds) == a
    @test area(ds) == ar
    @test volume(ds) == vol
    @test force(ds) == f
    @test density(ds) == d
end