"""
    AbstractElements

Abstract base type for two-body element sets.

## Two Body Element Interface

- [`semi_major_axis`](@ref)
- [`eccentricity`](@ref)
- [`right_ascension`](@ref)
- [`argument_of_periapsis`](@ref)
- [`true_anomaly`](@ref)
"""
abstract type AbstractElements end

# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ #
# Interface definition
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ #

"""
    semi_major_axis(::AbstractElements)

Retrieve the semi major axis orbital element.
"""
function semi_major_axis(::AbstractElements) end

"""
    eccentricity(::AbstractElements)


Retrieve the eccentricity orbital element.
"""
function eccentricity(::AbstractElements) end

"""
    right_ascension(::AbstractElements)

Retrieve the right ascension orbital element.
"""
function right_ascension(::AbstractElements) end

"""
    argument_of_periapsis(::AbstractElements)

Retrieve the argument of periapsis orbital element.
"""
function argument_of_periapsis(::AbstractElements) end

"""
    true_anomaly(::AbstractElements)

Retrieve the true anomaly orbital element.
"""
function true_anomaly(::AbstractElements) end

# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ #
# Default derived values
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ #
# Note, when implementing a new orbital element set, it's a good idea to see if there are
# faster ways to calculate any of these. For example, in the modified equinoctial
# elements, the parameter (semi-latus rectum) is an orbital element. If a new `parameter`
# method is not defined, it will be calculated as 
#
#        |-- semi_major_axis(m) -> a -|
#   m ---|                            |-- parameter(a, e)
#        |-- eccentricity(m) -> e ----|
#
# which is relatively expensive to a single field retrieval.

# Un-exported helper functions so that we don't have to write them everywhere
const _sma = semi_major_axis
const _ecc = eccentricity
const _raan = right_ascension
const _aop = argument_of_periapsis
const _ta = true_anomaly

# Semi-Latus Rectum
parameter(k::AbstractElements) = parameter(_sma(k), _ecc(k))

# Radii
periapsis_radius(k::AbstractElements) = _sma(k) * (1 - _ecc(k))
apoapsis_radius(k::AbstractElements) = _sma(k) * (1 + _ecc(k))
radius(k::AbstractElements) = radius(_sma(k), _ecc(k), _ta(k))

# True Longitude: See https://en.wikipedia.org/wiki/True_longitude
true_longitude(k::AbstractElements) = true_longitude(_raan(k), _aop(k), _ta(k))

# Flight Path Angle: angle between the local horizon and the velocity vector
flight_path_angle(k::AbstractElements) = flight_path_angle(_sma(k), _ecc(k), _ta(k))

# Closure Properties of Orbit
# Note: We don't need to define `isopen` as that is defined in terms of `isclosed`
isclosed(k::AbstractElements) = _ecc(k) |> isclosed

# Orbit Type Querying
iscircular(k::AbstractElements) = _ecc(k) |> iscircular
iselliptical(k::AbstractElements) = _ecc(k) |> iselliptical
isparabolic(k::AbstractElements) = _ecc(k) |> isparabolic
ishyperbolic(k::AbstractElements) = _ecc(k) |> ishyperbolic

# Mean Motion and Period
mean_motion(cb::CelestialBody, e::AbstractElements) = mean_motion(cb, semi_major_axis(e))
period(cb::CelestialBody, e::AbstractElements) = period(cb, _sma(e))

# Angular Momentum
angular_momentum(gm, e::AbstractElements) = angular_momentum(gm, _sma(e), _ecc(e))
angular_momentum(cb::CelestialBody, e::AbstractElements) = angular_momentum(_GM(cb), e)

# Dynamic Quantitie
circular_velocity(gm, e::AbstractElements) = circular_velocity(gm, _sma(e))
mean_motion(gm, e::AbstractElements) = mean_motion(gm, _sma(e))