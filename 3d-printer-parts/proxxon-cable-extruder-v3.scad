SHAFT_DIA = 3;
SHAFT_LENGTH = 20;

COG_TEETH_DIA = 18; // Actually 16.
COG_TEETH_LENGTH = 4;
COG_LENGTH = 11.5;
COG_DIA = 15; // Actually 14.

IDLER_COG_OFFSET = (SHAFT_LENGTH - COG_LENGTH)/2;
IDLER_MESH_DISTANCE = 15.5;

EXTRUDER_COG_OFFSET = IDLER_COG_OFFSET;
EXTRUDER_FILAMENT_OFFSET = 7.5;

WORM_DIA = 12; // Actually 7.
WORM_LENGTH = 13;
WORM_OFFSET = 4;
WORM_ANGLE = 10;
WORM_MESH_DISTANCE = 11;
WORM_MESH_OFFSET = 2.5;
WORM_BEARING_DIA = 10.2;
WORM_BEARING_HEIGHT = 4;
WORM_BEARING_FLANGE_DIA = 12;
WORM_BEARING_FLANGE_HEIGHT = 1;

FILAMENT_DIA = 2.3;
FILAMENT_LENGTH = 30;
FILAMENT_PORT_DIA = 6;
FILAMENT_PORT_LENGTH = 6;

CABLE_MOUNT_DIA = 13.5;
CABLE_MOUNT_LENGTH = 10;

BODY_EXTRA_THICKNESS = 2;
BODY_DRIVE_DIA = 22;
BODY_DRIVE_LENGTH = 20;
BODY_WORM_DIA = 17;
BODY_WORM_LENGTH = WORM_LENGTH + WORM_BEARING_HEIGHT + WORM_BEARING_FLANGE_HEIGHT + CABLE_MOUNT_LENGTH - 0.1;
BODY_FILAMENT_DIA = 10;
BODY_FILAMENT_LENGTH = FILAMENT_LENGTH;
BODY_BOLT_DIA = 6;
BODY_HINGE_DIA = BODY_BOLT_DIA;

BOLT_HEAD_DIA = BODY_BOLT_DIA + 0.1;
BOLT_HEAD_LENGTH = 3;
BOLT_DIA = 3.2;
BOLT_LENGTH = BODY_DRIVE_DIA;
BOLT_PLACEMENT = [
  [-IDLER_MESH_DISTANCE/2 - 4, -8.5, 0],
  [-IDLER_MESH_DISTANCE/2 - 4, 11, 0]
];

HINGE_HEAD_DIA = BOLT_HEAD_DIA;
HINGE_HEAD_LENGTH = BOLT_HEAD_LENGTH;
HINGE_DIA = BOLT_DIA;
HINGE_LENGTH = BODY_DRIVE_LENGTH + BODY_EXTRA_THICKNESS;
HINGE_PLACEMENT = [0, 0, -BODY_DRIVE_DIA/2-1];

HINGE_BOLT_PLACEMENT = [
  [IDLER_MESH_DISTANCE/2, -8.5, BODY_DRIVE_DIA/2+1],
  [IDLER_MESH_DISTANCE/2, 11, BODY_DRIVE_DIA/2+1]
];
HINGE_BOLT_LENGTH = 15;

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

module extruder_drive() {
    shaft();
    translate([0, 0, EXTRUDER_COG_OFFSET])
    cog();
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
    translate([-IDLER_MESH_DISTANCE/2, EXTRUDER_COG_OFFSET + EXTRUDER_FILAMENT_OFFSET]) {
        rotate([90, 0, 0]) {
            children();
        }
    }
}

module translate_idler() {
    translate([-IDLER_MESH_DISTANCE/2, EXTRUDER_COG_OFFSET + EXTRUDER_FILAMENT_OFFSET]) {
        rotate([90, 0, 0])
        translate([IDLER_MESH_DISTANCE, 0, 0]) {
            children();
        }
    }
}

module translate_worm() {
    translate([-IDLER_MESH_DISTANCE/2, EXTRUDER_COG_OFFSET + EXTRUDER_FILAMENT_OFFSET]) {
        translate([-WORM_MESH_DISTANCE, -EXTRUDER_COG_OFFSET - WORM_MESH_OFFSET, 0])
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

module translate_hinge() {
  translate(HINGE_PLACEMENT)
  translate_idler()
  translate([0, 0, HINGE_LENGTH/2 - BODY_EXTRA_THICKNESS/2])
  children();
}

module hinge() {
  translate_hinge()
  bolt_channel(HINGE_DIA, HINGE_LENGTH, HINGE_HEAD_DIA, HINGE_HEAD_LENGTH);
}

module translate_hinge_bolts() {
    for (t = HINGE_BOLT_PLACEMENT) {
        translate(t)
        children();
    }
}

module hinge_bolts() {
    translate_hinge_bolts()
    rotate([0, 90, 0])
    bolt_channel(BOLT_DIA, HINGE_BOLT_LENGTH, BOLT_HEAD_DIA, BOLT_HEAD_LENGTH);
}

module cable_path() {
    translate_worm()
    translate([0, 0, WORM_LENGTH + WORM_BEARING_HEIGHT + WORM_BEARING_FLANGE_HEIGHT])
    cylinder(d = CABLE_MOUNT_DIA, h = CABLE_MOUNT_LENGTH);
}

module body() {
    hull() {
        translate_drive()
        translate([0, 0, -BODY_EXTRA_THICKNESS/2])
        cylinder(d = BODY_DRIVE_DIA, h = BODY_DRIVE_LENGTH + BODY_EXTRA_THICKNESS);

        translate_idler()
        translate([0, 0, -BODY_EXTRA_THICKNESS/2])
        cylinder(d = BODY_DRIVE_DIA, h = BODY_DRIVE_LENGTH + BODY_EXTRA_THICKNESS);
    }

    translate_worm()
    cylinder(d = BODY_WORM_DIA, h = BODY_WORM_LENGTH);

    cylinder(d = BODY_FILAMENT_DIA, h = BODY_FILAMENT_LENGTH, center = true);

    translate_bolts()
    cylinder(d = BODY_BOLT_DIA, h = BOLT_LENGTH, center = true);

    translate_hinge()
    cylinder(d = BODY_HINGE_DIA, h = HINGE_LENGTH, center = true);

    translate_hinge_bolts()
    rotate([0, 90, 0])
    cylinder(d = BODY_BOLT_DIA, h = HINGE_BOLT_LENGTH, center = true);
}

module negative() {
    color("red")
    drive_assembly();
    color("green")
    filament_path();
    color("blue")
    cable_path();
    color("gray")
    bolts();
    color("gray")
    hinge();
    color("gray")
    hinge_bolts();
}

module assembly() {
    difference() {
        body();
        negative();
    }
}

module flap_mask() {
    translate(HINGE_PLACEMENT)
    translate_idler()
    translate([0, 0, HINGE_LENGTH/2 - BODY_EXTRA_THICKNESS/2])
    cylinder(d = BODY_HINGE_DIA, h = (HINGE_LENGTH - 2 * HINGE_HEAD_LENGTH) / 2, center = true);

    difference() {
        intersection() {
            translate_idler()
            translate([0, 0, -BODY_EXTRA_THICKNESS/2])
            cylinder(d = BODY_DRIVE_DIA, h = BODY_DRIVE_LENGTH + BODY_EXTRA_THICKNESS);

            translate([IDLER_MESH_DISTANCE/2, -50, -50])
            cube(size = [100, 100, 100]);
        }

        translate(HINGE_PLACEMENT)
        translate_idler()
        translate([0, 0, HINGE_LENGTH/2 - BODY_EXTRA_THICKNESS/2])
        cylinder(d = BODY_HINGE_DIA, h = HINGE_LENGTH, center = true);
    }

    translate_hinge_bolts()
    rotate([0, 90, 0])
    cylinder(d = BODY_BOLT_DIA, h = BOLT_LENGTH/2);
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

module extruder_top() {
  intersection() {
      assembly();
      top_mask();
  }
}

module extruder_bottom() {
  intersection() {
      assembly();
      bottom_mask();
  }
}

module extruder_flap() {
  intersection() {
      assembly();
      flap_mask();
      translate([0, -50, -50])
      cube(size = [BODY_DRIVE_DIA-8, 100, 100]);
  }
}

// overview
!union() {
    #body();
    negative();
}
extruder_top();
extruder_bottom();
extruder_flap();
