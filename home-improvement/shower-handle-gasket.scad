HEIGHT = 5.2;
GASKET_HEIGHT = HEIGHT-3.5;

DIAMETER = 19;
GASKET_OUTER_DIAMETER = 15;
GASKET_INNER_DIAMETER = 7;

$fn = 50;

intersection() {
    difference() {
        cylinder(h = HEIGHT, r1 = DIAMETER/2, r2 = DIAMETER/2);

        union() {
            translate([0, 0, GASKET_HEIGHT])
                cylinder(h = HEIGHT,
                         r1 = GASKET_OUTER_DIAMETER/2,
                         r2 = GASKET_OUTER_DIAMETER/2
            );

            cylinder(h = HEIGHT*2,
                     r1 = GASKET_INNER_DIAMETER/2,
                     r2 = GASKET_INNER_DIAMETER/2,
                     center = true
            );
        }
    }
    scale([1, 1, sqrt(2)*2*HEIGHT/DIAMETER])
        sphere(r = DIAMETER/2);
}
