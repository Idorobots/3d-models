HEIGHT = 2.5;
WIDTH = 60;
LENGTH = 75;

BAR_CORNER_RADIUS = 3;
BAR_WIDTH = 20;

HINGE_RADIUS = 3;
HINGE_HOLE_RADIUS = 1.5;
HINGE_HEIGHT = 7;
HINGE_SPACING = 10;
HINGE_WIDTH = 3;

$fn = 100;

module corner(width, height) {
    cube(size = [width, width, height], center = true);
}

module bar(from, to, width, height) {
    hull() {
        translate(from) corner(width, height);
        translate(to) corner(width, height);
    }
}

module outline() {
    d = BAR_CORNER_RADIUS * 2;
    h = HEIGHT;
    w = BAR_WIDTH - d;
    w2 = w/2;
    delta = w2 + BAR_CORNER_RADIUS;
    
    minkowski() {
        union() {
            bar(
                [LENGTH/2-delta, 0, 0], 
                [-LENGTH/2+delta, 0, 0], 
                w, 
                h
            );
            bar(
                [-LENGTH/2+delta, WIDTH/2-delta, 0], 
                [-LENGTH/2+delta, -WIDTH/2+delta, 0], 
                w, 
                h
            );
            bar(
                [LENGTH/2-delta, WIDTH/4-delta, 0], 
                [LENGTH/2-delta, -WIDTH/4+delta, 0], 
                w, 
                h
            );
        }
        cylinder(d = d, h = 0.1, center=true);
    }
}

module hinge() {
    difference() {
        hull() {
            translate([0, 0, HINGE_HEIGHT])
                rotate([90, 0, 0])
                    cylinder(r = HINGE_RADIUS, h = HINGE_WIDTH, center = true);
            translate([-HINGE_RADIUS, -HINGE_WIDTH/2, 0]) cube(size = [2 * HINGE_RADIUS, HINGE_WIDTH, 1]);
        }
        translate([0, 0, HINGE_HEIGHT])
            rotate([90, 0, 0])
                cylinder(r = HINGE_HOLE_RADIUS, h = HINGE_WIDTH+2, center = true);
    }
}

union() {
    outline();
    translate([-0.16*LENGTH, -HINGE_SPACING/2, HEIGHT/2])
        hinge();
    translate([-0.16*LENGTH, HINGE_SPACING/2, HEIGHT/2])
        hinge();
}