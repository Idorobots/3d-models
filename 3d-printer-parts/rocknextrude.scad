// 0 - All parts.
// 1 - Hob bearing mount.
// 2 - Tuner mount.
// 3 - Flex mount.

PART = 0;

WALL_THICKNESS = 1.5;

TUNER_BASE_THICKNESS = 2.5;
TUNER_GEAR_THICKNESS = 8;
TUNER_WIDTH = 18;
TUNER_LENGTH = 28;
TUNER_MOUNTING_HOLES_OFFSET = 9;
TUNER_MOUNTING_HOLES_SPACING = 22;
TUNER_MOUNTING_HOLES_DIA = 3;

WORM_AXLE_OFFSET_Z = 5;
WORM_AXLE_OFFSET_Y = 8;
WORM_AXLE_LENGTH = 35;
WORM_AXLE_DIA = 8;

HOB_GEAR_DIA = 15;
HOB_GEAR_LENGTH = 15;
HOB_AXLE_OFFSET = TUNER_LENGTH/2 - 10;
HOB_AXLE_BEARING_DIA = 11.5;
HOB_AXLE_BEARING_THICKNESS = 5;
HOB_AXLE_LENGTH = HOB_AXLE_BEARING_THICKNESS + HOB_GEAR_LENGTH + TUNER_GEAR_THICKNESS;
HOB_OFFSET_Y = 5;
HOB_OFFSET_X = 11.5;

TUBE_MOUNT_DIA = 10;
TUBE_MOUNT_THREAD_PITCH = 1;
TUBE_MOUNT_LENGTH = 6;
TUBE_DIA = 5;
TUBE_LENGTH = TUNER_WIDTH;

FLEX_MOUNT_DIA = 14;
FLEX_MOUNT_THREAD_PITCH = 1.5;
FLEX_MOUNT_LENGTH = 9;
FLEX_DIA = 6;
FLEX_LENGTH = WORM_AXLE_LENGTH;

IDLER_BEARING_DIA = 16;
IDLER_BEARING_THICKNESS = 6;
IDLER_MOUNT_DIA = 6.5;
IDLER_MOUNT_THICKNESS = 2 * IDLER_BEARING_THICKNESS;

BODY_WIDTH = HOB_AXLE_LENGTH + WALL_THICKNESS;
BODY_LENGTH = TUNER_LENGTH;
BODY_HEIGHT = TUNER_WIDTH;
BODY_MOUNTING_HOLES_DIA = 6;

$fn = 50;

module tuner_neg() {
    translate([0, 0, -TUNER_GEAR_THICKNESS])
    union() {
        translate([0, HOB_AXLE_OFFSET/2, (TUNER_GEAR_THICKNESS-TUNER_BASE_THICKNESS) + TUNER_BASE_THICKNESS/2])
        cube(size = [TUNER_WIDTH, TUNER_LENGTH, TUNER_BASE_THICKNESS], center = true);

        cylinder(d = HOB_AXLE_BEARING_DIA, h = HOB_AXLE_LENGTH);

        cylinder(d = HOB_GEAR_DIA, h = TUNER_GEAR_THICKNESS + HOB_GEAR_LENGTH);

        translate([0, -TUNER_MOUNTING_HOLES_OFFSET, -HOB_AXLE_LENGTH/2])
        cylinder(d = TUNER_MOUNTING_HOLES_DIA, h = HOB_AXLE_LENGTH*2);

        translate([0, -TUNER_MOUNTING_HOLES_OFFSET + TUNER_MOUNTING_HOLES_SPACING, -HOB_AXLE_LENGTH/2])
        cylinder(d = TUNER_MOUNTING_HOLES_DIA, h = HOB_AXLE_LENGTH*2);

        translate([TUNER_WIDTH/2, WORM_AXLE_OFFSET_Y, TUNER_GEAR_THICKNESS-WORM_AXLE_OFFSET_Z])
        rotate([0, -90, 0])
        cylinder(d = WORM_AXLE_DIA, h = WORM_AXLE_LENGTH);
    }
}

module idler_neg() {
    union() {
        hull() {
            translate([0, -IDLER_BEARING_DIA/2, 0])
            cylinder(d = IDLER_BEARING_DIA, h = IDLER_BEARING_THICKNESS, center = true);
            translate([0, IDLER_BEARING_DIA/2, 0])
            cylinder(d = IDLER_BEARING_DIA, h = IDLER_BEARING_THICKNESS, center = true);

        }
        hull() {
            translate([0, -IDLER_BEARING_DIA/2, 0])
            cylinder(d = IDLER_MOUNT_DIA, h = IDLER_MOUNT_THICKNESS, center = true);
            translate([0, IDLER_BEARING_DIA/2, 0])
            cylinder(d = IDLER_MOUNT_DIA, h = IDLER_MOUNT_THICKNESS, center = true);
        }
    }
}

module tube_neg() {
    union() {
        cylinder(d = TUBE_DIA, h = TUBE_LENGTH);
        translate([0, 0, TUBE_LENGTH])
        cylinder(d = TUBE_MOUNT_DIA, h = TUBE_MOUNT_LENGTH);
        translate([0, 0, -TUBE_MOUNT_LENGTH])
        cylinder(d = TUBE_MOUNT_DIA, h = TUBE_MOUNT_LENGTH);
    }
}

module flex_neg() {
    union() {
        cylinder(d = FLEX_MOUNT_DIA, h = FLEX_MOUNT_LENGTH);

        translate([0, 0, -FLEX_LENGTH])
        cylinder(d = FLEX_DIA, h = FLEX_LENGTH);
    }
}

module body_pos() {
    union() {
        intersection() {
            hull() {
                translate([0, BODY_LENGTH/3, 0])
                rotate([0, 90, 0])
                cylinder(d = BODY_HEIGHT, h = BODY_WIDTH, center = true);
                translate([0, -HOB_OFFSET_Y, 0])
                rotate([0, 90, 0])
                cylinder(d = HOB_GEAR_DIA + WALL_THICKNESS * 2, h = BODY_WIDTH, center = true);

                translate([0, -(BODY_LENGTH - BODY_MOUNTING_HOLES_DIA)/2, 0])
                rotate([0, 90, 0])
                cylinder(d = BODY_MOUNTING_HOLES_DIA, h = BODY_WIDTH, center = true);

            }
            cube(size = [BODY_WIDTH, BODY_LENGTH, BODY_HEIGHT], center = true);
        }
    }
}

module tube_pos() {
    union() {
        translate([0, 0, -TUNER_WIDTH/2 - TUBE_MOUNT_LENGTH])
        cylinder(d = TUBE_MOUNT_DIA + 2 * WALL_THICKNESS, h = TUBE_LENGTH + TUBE_MOUNT_LENGTH * 2);
    }
}

module flex_pos() {
    l = FLEX_LENGTH - TUNER_WIDTH;

    translate([0, 0, -l])
    union() {
        translate([0, 0, l])
        cylinder(d = FLEX_MOUNT_DIA + 2 * WALL_THICKNESS, h = FLEX_MOUNT_LENGTH);

        cylinder(d2 = FLEX_MOUNT_DIA + 2 * WALL_THICKNESS, d1 = FLEX_DIA + 2 * WALL_THICKNESS, h = l);
    }
}

module part_three_mask() {
    translate([-25-HOB_OFFSET_X-TUNER_BASE_THICKNESS/2, 0, 0])
    cube(size = [50, 50, BODY_HEIGHT], center = true);
    translate([-HOB_OFFSET_X - WORM_AXLE_OFFSET_Z, WORM_AXLE_OFFSET_Y - HOB_OFFSET_Y, WORM_AXLE_LENGTH-TUNER_WIDTH/2])
    flex_pos();
}

intersection() {
    difference() {
        union() {
            translate([-TUNER_GEAR_THICKNESS+WALL_THICKNESS, -2*WALL_THICKNESS, 0])
            body_pos();
            tube_pos();
            translate([-HOB_OFFSET_X - WORM_AXLE_OFFSET_Z, WORM_AXLE_OFFSET_Y - HOB_OFFSET_Y, WORM_AXLE_LENGTH-TUNER_WIDTH/2])
            flex_pos();
        }

        #union() {
            translate([-HOB_OFFSET_X, -HOB_OFFSET_Y, 0])
            rotate([0, 90, 0])
            tuner_neg();
            translate([0, 0, -TUNER_WIDTH/2])
            tube_neg();
            translate([0, IDLER_BEARING_DIA, 0])
            rotate([90, 90, 90])
            idler_neg();
            translate([-HOB_OFFSET_X - WORM_AXLE_OFFSET_Z, WORM_AXLE_OFFSET_Y - HOB_OFFSET_Y, WORM_AXLE_LENGTH - TUNER_WIDTH/2])
            flex_neg();
        }
    }

    if(PART == 1) {
        translate([25, 0, 0])
        cube(size = [50, 50, 50], center = true);
    }

    if(PART == 2) {
        difference() {
            translate([-25, 0, 0])
            cube(size = [50, 50, 50], center = true);
            part_three_mask();
        }
    }

    if(PART == 3) {
       part_three_mask();
    }
}
