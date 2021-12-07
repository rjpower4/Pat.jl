"""
    parameter(sma, ecc)

Get the parameter (semi-latus rectum) of the orbit.
"""
parameter(sma, ecc) = sma * (1 - ecc * ecc)

"""
    periapsis_radius(sma, ecc)

Get the smallest radius along the orbit.
"""
periapsis_radius(sma, ecc) = sma * (1 - ecc)

"""
    apoapsis_radius(sma, ecc)

Get the largest radius along the orbit.
"""
apoapsis_radius(sma, ecc) = sma * (1 + ecc)

"""
    radius(sma, ecc, ta)

Compute the radius of the orbit at the specified true anomaly
"""
radius(sma, ecc, ta) = parameter(sma, ecc) / (1 + ecc * cos(ta))

"""
    true_longitude(raan, aop, ta)

Compute the true longitude
"""
true_longitude(raan, aop, ta) = raan + aop + ta

"""
    isclosed(ecc)

Return true if the two-body orbit is closed, false otherwise.
"""
isclosed(ecc) = ecc < 1

"""
    isopen(ecc)

Return true if the two-body orbit is open, false otherwise.
"""
isopen(ecc) = !isclosed(ecc)

"""
    iscircular(ecc)

Return true if the two-body orbit is circular (``e = 0``), false otherwise.
"""
iscircular(ecc) = ecc == 0

"""
    iselliptical(ecc)

Return true if the two-body orbit is elliptical (``e < 1``), false otherwise.
"""
iselliptical(ecc) = ecc < 1

"""
    isparabolic(ecc)

Return true if the two-body orbit is parabolic (``e = 1``), false otherwise.
"""
isparabolic(ecc) = ecc == 1

"""
    ishyperbolic(ecc)

Return true if the two-body orbit is hyperbolic (``e > 1``), false otherwise.
"""
ishyperbolic(ecc) = ecc > 1

# Defining this allows us to write f(x) rather than f(x) _and_ f(cb::CelestialBody)
_GM(x) = gravitational_parameter(x)
_GM(x::Real) = x

"""
    circular_velocity(gm, r)
    circular_velocity(cb::CelestialBody, r)

Compute the circular velocity of a two-body orbit with circular radius `r`.
"""
circular_velocity(gm, r) = sqrt(_GM(gm) / r)

"""
    mean_motion(gm, sma)
    mean_motion(cb::CelestialBody, sma)

Compute the mean motion of an orbit with semi-major axis, `sma`.
"""
mean_motion(gm, sma) = circular_velocity(_GM(gm), sma) / sma

"""
    period(gm, sma)
    period(cb::CelestialBody, sma)

Compute the period of an orbit with semi-major axis, `sma`.
"""
period(gm, sma) = 2π / mean_motion(_GM(gm), sma)

"""
    angular_momentum(gm, sma, ecc)
    angular_momentum(cb::CelestialBody, sma, ecc)

Compute the angular momentum of the two-body orbit.
"""
angular_momentum(gm, sma, ecc) = sqrt(_GM(gm) * parameter(sma, ecc))

"""
    flight_path_angle(sma, ecc, ta)

Compute the angle between the velocity vector and the local horizon.
"""
function flight_path_angle(sma, ecc, ta)
    r = radius(sma, ecc, ta)
    return acos(sqrt(sma^2 * (1 - ecc^2) / (r * (2sma - r))))
end

include("elements.jl")





