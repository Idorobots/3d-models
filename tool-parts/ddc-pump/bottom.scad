HEIGHT = 2;
WIDTH = 62;
LIMIT_WIDTH = 82;

LIP_INNER_DIA = 52;
LIP_OUTER_DIA = 61.5;
LIP_LIMIT_WIDTH = 60;
LIP_HEIGHT = 2;

MOUNTING_HOLE_SPACING = 50;
MOUNTING_HOLE_DIA = 4.5;

$fn = 100;

module lip() {
    intersection() {
        difference() {
            cylinder(d = LIP_OUTER_DIA, h = LIP_HEIGHT);
            cylinder(d = LIP_INNER_DIA, h = LIP_HEIGHT);
        }
        cube(size = [LIP_LIMIT_WIDTH, LIP_LIMIT_WIDTH, LIP_HEIGHT*2], center = true);
    }
}

module base() {
    intersection() {
        translate([0, 0, HEIGHT/2])
        cube(size = [WIDTH, WIDTH, HEIGHT], center = true);
        rotate([0, 0, 45])
        cube(size = [LIMIT_WIDTH, LIMIT_WIDTH, HEIGHT*2], center = true);
    }
}

module mounting_holes(width, length, height, dia) {
    for(i = [-1, 1]) {
        for(j = [-1, 1]) {
            translate([i * width/2, j * length/2, 0])
            cylinder(d = dia, h = height);
        }
    }
}

difference() {
    union() {
        translate([0, 0, HEIGHT])
        lip();
        
        base();   
    }

    mounting_holes(MOUNTING_HOLE_SPACING, MOUNTING_HOLE_SPACING, HEIGHT, MOUNTING_HOLE_DIA);
}