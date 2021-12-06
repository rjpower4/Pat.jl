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

velocity(ds) = length(ds) / time(ds)
acceleration(ds) = velocity(ds) / time(ds)
area(ds) = length(ds)^2
volume(ds) = area(ds) * length(ds)
force(ds) = acceleration(ds) * mass(ds)
density(ds) = mass(ds) / volume(ds)

# Preferred Constructor
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