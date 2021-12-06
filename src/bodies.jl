"""
    CelestialBody

Struct representing a gravitating body with a NAIF ID code.
"""
struct CelestialBody
    gm::Float64
    naif_id::Int64
end

"""
    CelestialBody(gm)

Construct a new [`CelestialBody`](@ref) from its gravitational parameter.
"""
CelestialBody(gm) = CelestialBody(gm, -1)

"""
    CelestialBody(gm, naif_id, radius::Float64) 

Get the gravitational parameter of the body, often denoted μ.
"""
gravitational_parameter(cb::CelestialBody) = cb.gm

"""
    mass(::CelestialBody)

Return the mass of the body calculated as μ/G.

!!! note

    The mass calculation is performed by dividing the gravitational parameter
    by the universal gravitational constant, G. The uncertainty in the
    gravitational constant is much greater than that in the body's gravitational
    parameter. Therefore, try to use the parameter when possible.
"""
mass(cb::CelestialBody) = cb.gm / GRAVITATIONAL_CONSTANT

"""
    naif_id(::CelestialBody)

Return the NAIF ID of the body
"""
naif_id(cb::CelestialBody) = cb.naif_id
