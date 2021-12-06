# Copyright (c) 2021, Rolfe Power

"""
    DimensionSet

Struct representing fundamental quantities in an absolute dimension system.
"""
struct DimensionSet
    mass::Float64
    length::Float64
    time::Float64
end

"""
    mass(::DimensionSet)

Get fundamental mass quantity
"""
mass(ds::DimensionSet) = ds.mass

"""
    length(::DimensionSet)

Get fundamental length quantity
"""
Base.length(ds::DimensionSet) = ds.length

"""
    time(::DimensionSet)

Get fundamental time quantity
"""
Base.time(ds::DimensionSet) = ds.time

"""
    velocity(ds)

Return the velocity found as the ratio of length and time.
"""
velocity(ds) = length(ds) / time(ds)

"""
    acceleration(ds)

Return the acceleration found as the ratio of velocity and time.
"""
acceleration(ds) = velocity(ds) / time(ds)

"""
    area(ds)

Return the velocity found as the square of length.
"""
area(ds) = length(ds)^2

"""
    volume(ds)

Return the velocity found as the cube of length.
"""
volume(ds) = area(ds) * length(ds)

"""
    force(ds)

Return the force found as the product of acceleration and mass
"""
force(ds) = acceleration(ds) * mass(ds)

"""
    density(ds)

Return the acceleration found as the ratio of mass and volume.
"""
density(ds) = mass(ds) / volume(ds)

"""
    DimensionSet(value; mass=value, length=value, time=value)

Construct a [`DimensionSet`](@ref) specifying (optionally) `mass`, `length`, and `time`.

!!! note

    In addition to constructing the [`DimensionSet`](@ref), this function also validates
    the input arguments. Input dimensional quantities must be positive values!

## Examples
```jldoctest
julia> DimensionSet(2)
Pat.DimensionSet(2.0, 2.0, 2.0)

julia> DimensionSet(mass=2.0, length=3.0, time=4.0)
Pat.DimensionSet(2.0, 3.0, 4.0)

julia> DimensionSet(12.0, time=0.5)
Pat.DimensionSet(12.0, 12.0, 0.5)

julia> DimensionSet(-1.0)
ERROR: DomainError with -1.0:
Non-positive mass
[...]
```
"""
function DimensionSet(value=1.0; mass=value, length=value, time=value)
    mass   > 0 || throw(DomainError(mass, "Non-positive mass"))
    length > 0 || throw(DomainError(length, "Non-positive length"))
    time   > 0 || throw(DomainError(time, "Non-positive time"))
    DimensionSet(
        mass, 
        length,
        time
    )
end