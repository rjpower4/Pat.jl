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
"""
gravitational_parameter(cb::CelestialBody) = cb.gm
mass(cb::CelestialBody) = cb.gm / GRAVITATIONAL_CONSTANT
naif_id(cb::CelestialBody) = cb.naif_id
