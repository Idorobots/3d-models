WALL_THICKNESS = 2;
OUTER_CORNER_DIAMETER = 10;
INNER_CORNER_DIAMETER = 15;

MOUNTING_HOLE_DIAMETER = 4;
MOUNTING_HOLE_OFFSET = 15;
MOUNTING_HOLES = false;

WIDTH = 58 + 2 * WALL_THICKNESS;
HEIGHT = 60 + WALL_THICKNESS;
THICKNESS = 15 + 2 * WALL_THICKNESS;

BAR_WIDTH = OUTER_CORNER_DIAMETER;
SLOT_WIDTH = WIDTH - 2 * BAR_WIDTH;
SLOT_HEIGHT = HEIGHT - BAR_WIDTH;

STAND_ANGLE = 30;
STAND_WIDTH = WIDTH * 0.66;
STAND_LENGTH = 30;
STAND_HOLE_DIAMETER = 20;
STAND = true;

$fn = 30;

module square_cylinder(diameter, height) {
    union() {
        intersection() {
            cylinder(d = diameter, h = height);
            translate([-diameter/2, 0, 0])
            cube(size = [diameter, diameter/2, height]);
        }
        translate([-diameter/2, -diameter/2, 0])
        cube(size = [diameter, diameter/2, height]);    
    }
}

module square_bar(diameter, length, height) {
    hull() {
        translate([-(length-diameter)/2, 0, 0])
        square_cylinder(diameter, height);
        translate([(length-diameter)/2, 0, 0])
        square_cylinder(diameter, height);
    }
}

module rounded_rect(diameter, width, height, thickness) {
    union() {
        translate([-width/2, -height/2+diameter, 0])
        cube(size = [width, height-diameter, thickness]);

        translate([0, -(height-diameter)/2, 0])
        rotate([0, 0, 180])
        square_bar(diameter, width, thickness);
    }
}

module top() {
    d = OUTER_CORNER_DIAMETER;
    id = INNER_CORNER_DIAMETER;
    t = THICKNESS;
    difference() {
        union() {
            translate([-(WIDTH-d)/2, d, 0])
            rotate([0, 0, -90])
            square_bar(d, HEIGHT-2*d, t);
           
            translate([(WIDTH-d)/2, d, 0])
            rotate([0, 0, 90])
            square_bar(d, HEIGHT-2*d, t);
 
            translate([0, -HEIGHT/4, 0])
            rounded_rect(d, WIDTH, HEIGHT/2, t);
        }

        translate([0, (HEIGHT-SLOT_HEIGHT)/2, 0])
        rounded_rect(id, SLOT_WIDTH, SLOT_HEIGHT, t);
        
        translate([0, WALL_THICKNESS, WALL_THICKNESS])
        rounded_rect(d, WIDTH-2*WALL_THICKNESS, HEIGHT, t);
        
        translate([0, WALL_THICKNESS/2, t-WALL_THICKNESS])
        rounded_rect(d, WIDTH-WALL_THICKNESS, HEIGHT, WALL_THICKNESS);
    }
}

module bottom() {
    d = OUTER_CORNER_DIAMETER;
    id = INNER_CORNER_DIAMETER;
    t = WALL_THICKNESS;
    w = WIDTH-WALL_THICKNESS;
    difference() {
        hull() {
            rounded_rect(d, w, HEIGHT, t);
            if(STAND) {
                translate([0, -HEIGHT/2, 0])
                rotate([STAND_ANGLE, 0, 0])
                translate([0, t, -STAND_LENGTH/2-t])
                rotate([90, 0, 0])
                rounded_rect(d, STAND_WIDTH, STAND_LENGTH, t);
            }
        }
        if(MOUNTING_HOLES) {
            translate([0, MOUNTING_HOLE_OFFSET, 0])
            cylinder(d = MOUNTING_HOLE_DIAMETER, h = WALL_THICKNESS);

            translate([0, -MOUNTING_HOLE_OFFSET, 0])
            cylinder(d = MOUNTING_HOLE_DIAMETER, h = WALL_THICKNESS);
        }
        if(STAND) {
            difference() {
                translate([0, -HEIGHT/2, 0])
                rotate([STAND_ANGLE, 0, 0])
                translate([0, 0, -STAND_LENGTH/2])
                rotate([-90, 0, 0])
                cylinder(d = STAND_HOLE_DIAMETER, h = 10000, center = true);
                translate([-w/2, -HEIGHT/2, 0])
                cube(size = [w, HEIGHT, 10000]);
            }
        }
    }
}

union() {
    translate([0, 0, THICKNESS])
    rotate([0, 180, 0])
    top();
    bottom();
}