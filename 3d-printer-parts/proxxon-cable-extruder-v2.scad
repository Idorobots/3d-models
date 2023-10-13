SHAFT_DIA = 5;
SHAFT_LENGTH = 24;
SHAFT_BEARING_DIA = 11;
SHAFT_BEARING_HEIGHT = 5;

COG_TEETH_DIA = 11; // Actually 8.
COG_TEETH_LENGTH = 9;
COG_LENGTH = 14;
COG_DIA = 10; // Actually 8.

IDLER_COG_OFFSET = 3;
IDLER_MESH_DISTANCE = 9;

EXTRUDER_COG_OFFSET = 5;
EXTRUDER_FILAMENT_OFFSET = 16;

WORM_DIA = 12; // Actually 7.
WORM_LENGTH = 12;
WORM_OFFSET = 4;
WORM_ANGLE = 10;
WORM_MESH_DISTANCE = 7.25;
WORM_BEARING_DIA = 10;
WORM_BEARING_HEIGHT = 4;
WORM_BEARING_FLANGE_DIA = 12;
WORM_BEARING_FLANGE_HEIGHT = 1;

FILAMENT_DIA = 2;
FILAMENT_LENGTH = 25;
FILAMENT_PORT_DIA = 7;
FILAMENT_PORT_LENGTH = 5;

CABLE_MOUNT_DIA = 13.7;
CABLE_MOUNT_LENGTH = 10;

BODY_EXTRA_THICKNESS = 1;
BODY_DRIVE_DIA = 15;
BODY_DRIVE_LENGTH = SHAFT_LENGTH;
BODY_WORM_DIA = 17;
BODY_WORM_LENGTH = WORM_LENGTH + WORM_BEARING_HEIGHT + WORM_BEARING_FLANGE_HEIGHT + CABLE_MOUNT_LENGTH - 0.1;
BODY_FILAMENT_DIA = 11;
BODY_FILAMENT_LENGTH = FILAMENT_LENGTH;
BODY_BOLT_DIA = 6;
BODY_NOTCH_DIA = 2;
BODY_NOTCH_OFFSET = 7;

BOLT_HEAD_DIA = BODY_BOLT_DIA + 0.1;
BOLT_HEAD_LENGTH = 3;
BOLT_DIA = 3;
BOLT_LENGTH = BODY_DRIVE_DIA;
BOLT_PLACEMENT = [
  [IDLER_MESH_DISTANCE/2, 18, 0], // NOTE Needs to be the "hinge" bolt.
  [-12, -7, 0],
  [-10, 19, 0]
];


$fn = 50;

module shaft() {
    cylinder(d = SHAFT_DIA, h = SHAFT_LENGTH);
}

module cog() {
    cylinder(d = COG_DIA, h = COG_LENGTH);
    cylinder(d = COG_TEETH_DIA, h = COG_TEETH_LENGTH);
}

module idler() {
    shaft();
    translate([0, 0, IDLER_COG_OFFSET])
    cog();
}

module shaft_bearing() {
    cylinder(d = SHAFT_BEARING_DIA, h = SHAFT_BEARING_HEIGHT);
}

module extruder_drive() {
    shaft();
    shaft_bearing();
    translate([0, 0, EXTRUDER_COG_OFFSET])
    cog();
    translate([0, 0, COG_LENGTH + EXTRUDER_COG_OFFSET])
    shaft_bearing();
}

module worm_bearing() {
    cylinder(d = WORM_BEARING_FLANGE_DIA, h = WORM_BEARING_FLANGE_HEIGHT);
    cylinder(d = WORM_BEARING_DIA, h = WORM_BEARING_HEIGHT);
}

module worm() {
    cylinder(d = WORM_DIA, h = WORM_LENGTH);
}

module worm_drive() {
    translate([0, 0, WORM_BEARING_HEIGHT])
    rotate([0, 180, 0])
    worm_bearing();
    translate([0, 0, WORM_OFFSET])
    worm();
    translate([0, 0, WORM_LENGTH + WORM_OFFSET])
    worm_bearing();
}

module translate_drive() {
    translate([-IDLER_MESH_DISTANCE/2, EXTRUDER_FILAMENT_OFFSET]) {
        rotate([90, 0, 0]) {
            children();
        }
    }
}

module translate_idler() {
    translate([-IDLER_MESH_DISTANCE/2, EXTRUDER_FILAMENT_OFFSET]) {
        rotate([90, 0, 0])
        translate([IDLER_MESH_DISTANCE, 0, 0]) {
            children();
        }
    }
}

module translate_worm() {
    translate([-IDLER_MESH_DISTANCE/2, EXTRUDER_FILAMENT_OFFSET]) {
        translate([-WORM_MESH_DISTANCE, -EXTRUDER_COG_OFFSET - COG_TEETH_LENGTH/2, 0])
        rotate([-WORM_ANGLE, 0, 0])
        translate([0, 0, -WORM_OFFSET -WORM_LENGTH/2]) {
            children();
        }
    }
}

module drive_assembly() {
    translate_drive()
    extruder_drive();

    translate_idler()
    translate([0, 0, EXTRUDER_COG_OFFSET - IDLER_COG_OFFSET])
    idler();

    translate_worm()
    worm_drive();
}

module bolt_channel(dia, height, head_dia, head_height) {
    cylinder(d = dia, h = height, center = true);
    translate([0, 0, -(height-head_height)/2])
    cylinder(d = head_dia, h = head_height, center = true);

    translate([0, 0, (height-head_height)/2])
    cylinder(d = head_dia, h = head_height, center = true);
}

module filament_path() {
    bolt_channel(FILAMENT_DIA, FILAMENT_LENGTH, FILAMENT_PORT_DIA, FILAMENT_PORT_LENGTH);
}

module bolt() {
    bolt_channel(BOLT_DIA, BOLT_LENGTH, BOLT_HEAD_DIA, BOLT_HEAD_LENGTH);
}

module translate_bolts() {
    for (t = BOLT_PLACEMENT) {
        translate(t)
        children();
    }
}

module bolts() {
    translate_bolts()
    bolt();
}

module cable_path() {
    translate_worm()
    translate([0, 0, WORM_LENGTH + WORM_BEARING_HEIGHT + WORM_BEARING_FLANGE_HEIGHT])
    cylinder(d = CABLE_MOUNT_DIA, h = CABLE_MOUNT_LENGTH);
}

module shaft_holes() {
    translate_drive()
    cylinder(d = SHAFT_DIA, h = SHAFT_LENGTH + BODY_EXTRA_THICKNESS);
}

module body() {
    hull() {
        wt2 = 2 * BODY_EXTRA_THICKNESS;
        translate_drive()
        translate([0, 0, -BODY_EXTRA_THICKNESS])
        cylinder(d = BODY_DRIVE_DIA, h = BODY_DRIVE_LENGTH + wt2);

        translate_idler()
        translate([0, 0, -BODY_EXTRA_THICKNESS])
        cylinder(d = BODY_DRIVE_DIA, h = BODY_DRIVE_LENGTH + wt2);
    }

    translate_worm()
    cylinder(d = BODY_WORM_DIA, h = BODY_WORM_LENGTH);

    cylinder(d = BODY_FILAMENT_DIA, h = BODY_FILAMENT_LENGTH, center = true);

    translate_bolts()
    cylinder(d = BODY_BOLT_DIA, h = BOLT_LENGTH, center = true);
}

module notch() {
    translate([IDLER_MESH_DISTANCE/2 + BODY_DRIVE_DIA/2, -BODY_NOTCH_OFFSET, 0])
    cylinder(d = BODY_NOTCH_DIA, h = BODY_DRIVE_DIA, center = true);
}

module negative() {
    color("red")
    drive_assembly();
    color("yellow")
    shaft_holes();
    color("green")
    filament_path();
    color("blue")
    cable_path();
    color("gray")
    bolts();
    color("gray")
    notch();
}

module assembly() {
    difference() {
        body();
        negative();
    }
}

module flap_mask() {
    translate(BOLT_PLACEMENT[0])
    cylinder(d = BODY_BOLT_DIA, h = (BOLT_LENGTH - 2 * BOLT_HEAD_LENGTH) / 3, center = true);

    difference() {
        intersection() {
            translate_idler()
            translate([0, 0, -BODY_EXTRA_THICKNESS])
            cylinder(d = BODY_DRIVE_DIA, h = BODY_DRIVE_LENGTH + 2 * BODY_EXTRA_THICKNESS);

            translate([IDLER_MESH_DISTANCE/2, -50, -50])
            cube(size = [100, 100, 100]);
        }

        translate(BOLT_PLACEMENT[0])
        cylinder(d = BODY_BOLT_DIA, h = BOLT_LENGTH, center = true);
    }
}

module top_mask() {
    difference() {
        translate([-50, -50, 0])
        cube(size = [100, 100, 100]);

        flap_mask();
    }
}

module bottom_mask() {
    difference() {
        translate([-50, -50, -100])
        cube(size = [100, 100, 100]);

        flap_mask();
    }
}

// overview
!union() {
    #body();
    negative();
}

// top
intersection() {
    assembly();
    top_mask();
}

// bottom
intersection() {
    assembly();
    bottom_mask();
}

// flap
intersection() {
    assembly();
    flap_mask();
}
