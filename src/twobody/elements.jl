abstract type AbstractElements end

# Helpers
_sma(x) = semi_major_axis(x)
_ecc(x) = eccentricity(x)
_raan(x) = right_ascension(x)
_aop(x) = argument_of_periapsis(x)
_ta(x) = true_anomaly(x)


parameter(k::AbstractElements) = parameter(_sma(k), _ecc(k))
pariapsis_radius(k::AbstractElements) = _sma(k) * (1 - _ecc(k))
apoapsis_radius(k::AbstractElements) = _sma(k) * (1 + _ecc(k))

true_longitude(k::AbstractElements) = true_longitude(_raan(k), _aop(k), _ta(k))

flight_path_angle(k::AbstractElements) = flight_path_angle(_sma(k), _ecc(k), _ta(k))

isclosed(k::AbstractElements) = _ecc(k) |> isclosed
iscircular(k::AbstractElements) = _ecc(k) |> iscircular
iselliptical(k::AbstractElements) = _ecc(k) |> iselliptical
isparabolic(k::AbstractElements) = _ecc(k) |> isparabolic
ishyperbolic(k::AbstractElements) = _ecc(k) |> ishyperbolic

mean_motion(cb::CelestialBody, e::AbstractElements) = mean_motion(cb, semi_major_axis(e))
angular_momentum(cb::CelestialBody, e::AbstractElements) = sqrt(_GM(cb) * parameter(e))

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
