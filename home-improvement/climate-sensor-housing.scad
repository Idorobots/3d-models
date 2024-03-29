SENSOR_WIDTH = 22;
SENSOR_LENGTH = 42; //62;
SENSOR_HEIGHT = 13;
CABLE_DIA = 4;
CABLE_HEIGHT = 2;

WALL_THICKNESS = 1.2;
WIDTH = SENSOR_WIDTH + 2 * WALL_THICKNESS;
LENGTH = SENSOR_LENGTH + 2 * WALL_THICKNESS;
HEIGHT = SENSOR_HEIGHT + 2 * WALL_THICKNESS;
CORNER_DIA = 5;

MOUNT_HOLES = false;
MOUNT_HOLE_DIA = 2.5;
MOUNT_HOLE_HEAD_DIA = 2.5;
MOUNT_HOLE_SPACING = 10;

VENT_HOLE_DIA = 3;
VENT_HOLE_SPACING = 7;
VENT_HOLES = round(SENSOR_LENGTH/2/VENT_HOLE_SPACING);
$fn = 50;

module sensor() {
    translate([-SENSOR_WIDTH/2, -SENSOR_LENGTH/2, 0])
    cube(size = [SENSOR_WIDTH, SENSOR_LENGTH, SENSOR_HEIGHT]);

    translate([0, 0, CABLE_HEIGHT + CABLE_DIA/2])
    rotate([-90, 0, 0])
    cylinder(d = CABLE_DIA, h = SENSOR_LENGTH);
}

module base() {
    translate([0, 0, CORNER_DIA/2])
    minkowski() {
        sphere(d = CORNER_DIA);
        union() {
            w = WIDTH - CORNER_DIA;
            l = LENGTH - CORNER_DIA;
            h = HEIGHT - CORNER_DIA;
            translate([0, -l/2, 0])
            cylinder(d = w, h = h);
            translate([-w/2, -l/2, 0])
            cube(size = [w, l, h]);
            translate([0, l/2, 0])
            cylinder(d = w, h = h);
        }
    }
}

module mount_holes() {
    for(i = [-1, 1]) {
        for(j = [-1, 1]) {
            translate([i * MOUNT_HOLE_SPACING/2, j * LENGTH/2, 0]) {
                cylinder(d = MOUNT_HOLE_DIA, h = HEIGHT - WALL_THICKNESS);
                cylinder(d = MOUNT_HOLE_HEAD_DIA, h = WALL_THICKNESS/2);
            }
        }
    }
}

module vent_holes() {
    for(i = [0 : VENT_HOLES-1]) {
        translate([0, -i * VENT_HOLE_SPACING, 0])
        cylinder(d = VENT_HOLE_DIA, h = HEIGHT);
    }
}

module case() {
    difference() {
        base();
        #translate([0, 0, WALL_THICKNESS])
        sensor();

        if(MOUNT_HOLES) {
            #mount_holes();
        }

        #translate([0, 0, WALL_THICKNESS])
        vent_holes();
    }
}

module bot_mask() {
    delta = 1.5;
    union() {
        translate([0, -SENSOR_LENGTH/2 + delta, 0])
        cylinder(d = SENSOR_WIDTH, h = WALL_THICKNESS);
        translate([-SENSOR_WIDTH/2, -SENSOR_LENGTH/2, 0])
        cube(size = [SENSOR_WIDTH, SENSOR_LENGTH, WALL_THICKNESS]);
        translate([0, SENSOR_LENGTH/2 - delta, 0])
        cylinder(d = SENSOR_WIDTH, h = WALL_THICKNESS);

        l = LENGTH + WIDTH;
        translate([-CABLE_DIA/2, -l/2 + MOUNT_HOLE_SPACING, 0])
        cube(size = [CABLE_DIA, l, CABLE_HEIGHT + CABLE_DIA/2]);
    }
}

// Bottom
!intersection() {
    case();
    bot_mask();
}

// Top
difference() {
    case();
    bot_mask();
}
