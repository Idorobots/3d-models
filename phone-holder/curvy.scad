WALL_THICKNESS = 2;
OUTER_CORNER_DIAMETER = 10;
INNER_CORNER_DIAMETER = 15;

MOUNTING_HOLE_DIAMETER = 4;
MOUNTING_HOLE_OFFSET = 10;
MOUNTING_HOLES = false;

WIDTH = 58 + 2 * WALL_THICKNESS;
HEIGHT = 60 + WALL_THICKNESS;
THICKNESS = 15 + 2 * WALL_THICKNESS;

BAR_WIDTH = OUTER_CORNER_DIAMETER;
SLOT_WIDTH = WIDTH - 2 * BAR_WIDTH;
SLOT_HEIGHT = HEIGHT - BAR_WIDTH;

STAND_ANGLE = 63;
STAND_INSERT_DIAMETER = 68;
STAND_INSERT_HEIGHT = 7;
STAND_BASE_HEIGHT = STAND_INSERT_HEIGHT + WALL_THICKNESS;
STAND_BASE_DIAMETER = STAND_INSERT_DIAMETER + 2 * WALL_THICKNESS;
STAND_COLUMN_DIAMETER = 30;
STAND_HEIGHT = 50;
STAND = true;

$fn = 50;

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
    translate([0, -cos(STAND_ANGLE)*STAND_HEIGHT, STAND_HEIGHT])
    rotate([STAND_ANGLE, 0, 0])
    rotate([0, 180, 0])
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

module stand() {
    translate([0, 0, STAND_BASE_HEIGHT])
    difference() {
        union() {
            cylinder(d = STAND_COLUMN_DIAMETER, h = STAND_HEIGHT-STAND_COLUMN_DIAMETER/2);
            translate([0, 0, STAND_HEIGHT-STAND_COLUMN_DIAMETER/2])
            sphere(d = STAND_COLUMN_DIAMETER);
        }
        translate([0, -cos(STAND_ANGLE)*STAND_HEIGHT, STAND_HEIGHT-STAND_BASE_HEIGHT])
        rotate([STAND_ANGLE, 0, 0])
        translate([-WIDTH/2, -HEIGHT/2, -THICKNESS])
        cube(size = [WIDTH, HEIGHT, 10000]);
        cylinder(d = MOUNTING_HOLE_DIAMETER, h = STAND_HEIGHT/2);
    }
}

module bottom() {
    translate([0, -cos(STAND_ANGLE)*STAND_HEIGHT, STAND_HEIGHT])
    rotate([STAND_ANGLE, 0, 0])
    translate([0, 0, -THICKNESS])
    difference() {
        rounded_rect(OUTER_CORNER_DIAMETER, WIDTH-WALL_THICKNESS, HEIGHT, WALL_THICKNESS);
        if(MOUNTING_HOLES) {
            translate([0, MOUNTING_HOLE_OFFSET, 0])
            cylinder(d = MOUNTING_HOLE_DIAMETER, h = WALL_THICKNESS);

            translate([0, -MOUNTING_HOLE_OFFSET, 0])
            cylinder(d = MOUNTING_HOLE_DIAMETER, h = WALL_THICKNESS);
        }
    }
}

module base() {
    difference() {
        cylinder(d = STAND_BASE_DIAMETER, h = STAND_BASE_HEIGHT);
        cylinder(d = STAND_INSERT_DIAMETER, h = STAND_INSERT_HEIGHT);
        cylinder(d = MOUNTING_HOLE_DIAMETER, h = STAND_BASE_HEIGHT);
    }
}

union() {
    top();
    bottom();
    if(STAND) {
        stand();
        base();
    }
}