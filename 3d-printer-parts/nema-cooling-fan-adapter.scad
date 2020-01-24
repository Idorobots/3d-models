NEMA_WIDTH = 42.5;
WALL_THICKNESS = 3;
THICKNESS = 10;

NEMA_SLOT_WIDTH = 17;
NEMA_SLOT_LENGTH = 10;
NEMA_SLOT_HOLE_DIA = 4;

MOUNTING_HOLE_DIA = 3;
MOUNTING_HOLE_THICKNESS = 3;
MOUNTING_HOLE_SPACING_X = 51.5;
MOUNTING_HOLE_SPACING_Y = 23;

$fn = 50;

module mounting_holes(dia) {
    for(i = [-1, 1]) {
        for(j = [-1, 1]) {
            translate([i * MOUNTING_HOLE_SPACING_X/2, j * MOUNTING_HOLE_SPACING_Y/2, THICKNESS/2 - MOUNTING_HOLE_THICKNESS])
            cylinder(d = dia, h = MOUNTING_HOLE_THICKNESS);
        }
    }
}

difference() {
    w = NEMA_WIDTH + 2 * WALL_THICKNESS;
    
    union() {
        cube(size = [w, w, THICKNESS], center = true);

        mounting_holes(MOUNTING_HOLE_DIA + 2 * WALL_THICKNESS);
        
        translate([0, NEMA_SLOT_LENGTH, 0])
        cube(size = [NEMA_SLOT_WIDTH + 2 * WALL_THICKNESS, NEMA_WIDTH + NEMA_SLOT_LENGTH, THICKNESS], center = true);
    }

    cube(size = [NEMA_WIDTH, NEMA_WIDTH, THICKNESS], center = true);
    
    translate([0, NEMA_WIDTH, 0])
    cube(size = [NEMA_SLOT_WIDTH, NEMA_WIDTH * 2, THICKNESS], center = true);

    mounting_holes(MOUNTING_HOLE_DIA);
    
    translate([0, NEMA_SLOT_LENGTH + NEMA_WIDTH/2, 0])
    rotate([0, 90, 0])
    cylinder(d = NEMA_SLOT_HOLE_DIA, h = NEMA_SLOT_WIDTH * 2, center = true);
}
