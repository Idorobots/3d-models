use <beam.scad>;

AXLE_SIDEWAYS = true;

module sideways() {
    lego_translate(0, 0, 1.5)
    rotate([90, 0, 0])
    lego_translate(0, 0, -0.5)
    beam(1, 1, [AXLE_SIDEWAYS]);
}

sideways();

difference() {
    beam(1, 1.5, [1], beam_dia = 6.8);
    hull()
    sideways();
}
