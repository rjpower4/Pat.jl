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
    ecc >= 0 || throw(DomainError(ecc, "Negative eccentricity"))
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