struct Sphere
    radius::Float64
end
Sphere() = Sphere(1)
radius(s::Sphere) = s.radius
volume(s::Sphere) = radius(s)^3 * (4//3) * π
area(s::Sphere) = 4π * radius(s)^2

struct CelestialBody
    gm::Float64
    naif_id::Int64
    shape::Sphere
end
CelestialBody(gm) = CelestialBody(gm, -1, Sphere())
CelestialBody(gm, naif_id, radius::Float64) = CelestialBody(gm, naif_id, Sphere(radius))
gravitational_parameter(cb::CelestialBody) = cb.gm
mass(cb::CelestialBody) = cb.gm / GRAVITATIONAL_CONSTANT
naif_id(cb::CelestialBody) = cb.naif_id
shape(cb::CelestialBody) = cb.shape
radius(cb::CelestialBody) = cb |> shape |> radius
volume(cb::CelestialBody) = cb |> shape |> volume
density(cb::CelestialBody) = mass(cb) / radius(cb)