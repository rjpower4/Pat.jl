const _GM = gravitational_parameter

parameter(sma, ecc) = sma * (1 - ecc * ecc)
pariapsis_radius(sma, ecc) = sma * (1 - ecc)
apoapsis_radius(sma, ecc) = sma * (1 + ecc)
radius(sma, ecc, ta) = parameter(sma, ecc) / (1 + ecc * cos(ta))
true_longitude(raan, aop, ta) = raan + aop + ta

isclosed(ecc) = ecc < 1
isopen(ecc) = !isclosed(ecc)
iscircular(ecc) = ecc == 0
iselliptical(ecc) = ecc < 1
isparabolic(ecc) = ecc == 1
ishyperbolic(ecc) = ecc > 1

circular_velocity(gm, r) = sqrt(gm / r)
circular_velocity(cb::CelestialBody, r) = circular_velocity(_GM(cb), r)

mean_motion(gm, sma) = circular_velocity(gm, sma) / sma
mean_motion(cb::CelestialBody, sma) = mean_motion(_GM(cb), sma)

period(gm, sma) = 2π / mean_motion(gm, sma)
period(cb::CelestialBody, sma) = period(_GM(cb), sma)

angular_momentum(gm, sma, ecc) = sqrt(gm * parameter(sma, ecc))
angular_momentum(cb::CelestialBody, sma, ecc) = angular_momentum(_GM(cb), sma, ecc)

function flight_path_angle(sma, ecc, ta)
    r = radius(sma, ecc, ta)
    return acos(sqrt(sma^2 * (1 - ecc^2) / (r * (2sma - r))))
end

include("elements.jl")





