"""
    KeplerianElements

Struct representing the standard classical orbital elements.
"""
struct KeplerianElements <: AbstractElements
    "Semi-Major Axis"
    a::Float64
    "Eccentricity"
    e::Float64
    "Inclination"
    i::Float64
    "Argument of Periapsis"
    ω::Float64
    "Right Ascension of the Ascending Node"
    Ω::Float64
    "True Anomaly"
    ν::Float64
end

# Helper validation functions for keplerian elements
_valid_sma(sma) = sma != 0
_valid_ecc(ecc) = ecc >= 0
_valid_inc(inc) = 0 ≤ inc ≤ π
_valid_aop(aop) = true
_valid_raan(raan) = true
_valid_ta(ta) = true

function _validate(ke::KeplerianElements)
    a = semi_major_axis(ke)
    e = eccentricity(ke)
    i = inclination(ke)
    ω = argument_of_periapsis(ke)
    Ω = right_ascension(ke)
    ν = true_anomaly(ke)
    _valid_sma(a) || throw(DomainError(a, "Invalid semi-major axis"))
    _valid_ecc(e) || throw(DomainError(e, "Invalid eccentricity"))
    _valid_inc(i) || throw(DomainError(i, "Invalid inclination"))
    _valid_aop(ω) || throw(DomainError(ω, "Invalid argument of periapsis"))
    _valid_raan(Ω) || throw(DomainError(raan, "Invalid right ascension")) 
    _valid_ta(ν) || throw(DomainError(ta, "Invalid true anomaly"))

    asign = a > 0
    ic = isclosed(ke)

    if (ishyperbolic(ke) && asign) || isparabolic(ke) && !isinf(a) || (ic && !asign)
        throw(DomainError((a=a, e=e), "Invalid eccentricity and semi-major axis pair"))
    end

    return ke
end

"""
    KeplerianElements(sma; ecc=0, inc=0, aop=0, raan=0, ta=0)

Contruct a new [`KeplerianElements`](@ref) struct specifying optional orbit elements.

See Also: 
[`semi_major_axis`](@ref), 
[`eccentricity`](@ref)
[`inclination`](@ref),
[`argument_of_periapsis`](@ref),
[`right_ascension`](@ref),
[`true_anomaly`](@ref)
"""
function KeplerianElements(sma; ecc=0.0, inc=0.0, aop=0.0, raan=0.0, ta=0.0)
    return KeplerianElements(
        sma,
        ecc,
        inc,
        aop,
        raan,
        ta
    ) |> _validate
end

semi_major_axis(k::KeplerianElements) = k.a
eccentricity(k::KeplerianElements) = k.e
inclination(k::KeplerianElements) = k.i
argument_of_periapsis(k::KeplerianElements) = k.ω
right_ascension(k::KeplerianElements) = k.Ω
true_anomaly(k::KeplerianElements) = k.ν