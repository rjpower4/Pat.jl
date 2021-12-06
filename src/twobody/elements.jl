abstract type AbstractElements end

parameter(k::AbstractElements) = semi_major_axis(k) * (1 - eccentricity(k)^2)
pariapsis_radius(k::AbstractElements) = semi_major_axis(k) * (1 - eccentricity(k))
apoapsis_radius(k::AbstractElements) = semi_major_axis(k) * (1 + eccentricity(k))

function true_longitude(k::AbstractElements)
    return right_ascension(k) + argument_of_periapsis(k) + true_anomaly(k)
end

isclosed(k::AbstractElements) = eccentricity(k) < 1
isopen(k::AbstractElements) = !isclosed(k)
iscircular(k::AbstractElements) = eccentricity(k) == 0
iselliptical(k::AbstractElements) = eccentricity(k) < 1
isparabolic(k::AbstractElements) = eccentricity(k) == 1
ishyperbolic(k::AbstractElements) = eccentricity(k) > 1

# -------------------------------------------------------------------------------------- #
# -------------------------------------------------------------------------------------- #
# Keplerian 
# -------------------------------------------------------------------------------------- #
# -------------------------------------------------------------------------------------- #
struct KeplerianElements <: AbstractElements
    a::Float64 # Semi-major axis
    e::Float64 # Eccentricity
    i::Float64 # Inclination
    ω::Float64 # Argument of Periapsis
    Ω::Float64 # Right-Ascension
    ν::Float64 # True Anomaly
end

function KeplerianElements(sma; ecc=0.0, inc=0.0, aop=0.0, raan=0.0, ta=0.0)
    sma != 0 || throw(DomainError(sma, "Zero semi major axis"))
    ecc > 0 || throw(DomainError(ecc, "Negative eccentricity"))
    return KeplerianElements(
        sma,
        ecc,
        inc,
        aop,
        raan,
        ta
    )
end

semi_major_axis(k::KeplerianElements) = k.a
eccentricity(k::KeplerianElements) = k.e
inclination(k::KeplerianElements) = k.i
argument_of_periapsis(k::KeplerianElements) = k.ω
right_ascension(k::KeplerianElements) = k.Ω
true_anomaly(k::KeplerianElements) = k.ν

# -------------------------------------------------------------------------------------- #
# -------------------------------------------------------------------------------------- #
# Modified Equinoctial 
# -------------------------------------------------------------------------------------- #
# -------------------------------------------------------------------------------------- #
struct ModifiedEquinoctialElements <: AbstractElements
    p::Float64 # Parameter
    f::Float64 # These
    g::Float64 # Don't
    h::Float64 # Have
    k::Float64 # Names
    l::Float64 # True Longitude
end

# Faster than defaults
parameter(m::ModifiedEquinoctialElements) = m.p
true_longitude(m::ModifiedEquinoctialElements) = m.l

# Conversion from Keplerian Elements
function ModifiedEquinoctialElements(ke::KeplerianElements)
    ecc = eccentricity(ke)
    inc = inclination(ke)
    aop = argument_of_periapsis(ke)
    raan = right_ascension(ke)
    sr, cr = sincos(raan)
    sar, car = sincos(aop + raan)
    ti = tan(inc / 2)
    ModifiedEquinoctialElements(
        parameter(ke),
        ecc * car,
        ecc * sar,
        ti * cr,
        ti * sr,
        true_longitude(ke)
    )
end

# Interface
semi_major_axis(m::ModifiedEquinoctialElements) = parameter(m) / (1 - m.f^2 - m.g^2)
eccentricity(m::ModifiedEquinoctialElements) = sqrt(m.f^2  + m.g^2)
inclination(m::ModifiedEquinoctialElements) = atan(2*sqrt(m.h^2 + m.k^2), 1-m.h^2-m.k^2)
right_ascension(m::ModifiedEquinoctialElements) = atan(m.k, m.h)
true_anomaly(m::ModifiedEquinoctialElements) = m.l - atan(m.g / m.f)

function argument_of_periapsis(m::ModifiedEquinoctialElements)
    num = m.g * m.h - m.f * m.k
    den = m.f * m.h + m.g * m.k
    return atan(num, den)
end
