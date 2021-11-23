using Test
using Pat

#  These exist mainly to warn if there's been an unintentional change
@test Pat.GRAVITATIONAL_CONSTANT == 6.6743e-20
@test Pat.SPEED_OF_LIGHT == 299792458e-3
@test Pat.EARTH_STANDARD_GRAVITY == 9.80665e-03
@test Pat.BOLTZMANN_CONSTANT == 1.380649e-23
@test Pat.ASTRONOMICAL_UNIT == 149597870700e-3
@test Pat.ELECTRON_MASS == 9.109_383_7015e-31
@test Pat.NEUTRON_MASS == 1.674_927_498_04e-27
@test Pat.PROTON_MASS == 1.672_621_923_69e-27