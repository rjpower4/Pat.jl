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