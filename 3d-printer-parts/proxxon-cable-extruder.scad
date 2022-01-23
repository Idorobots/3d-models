DELTA = 0.4; // Expands most critical dimensions by this amount, mainly to facilitate 3d printer shortcommings.
WALL_THICKNESS = 1;

BEARING_INNER_DIA = 5 + DELTA;
BEARING_OUTER_DIA = 11.5 + DELTA;
BEARING_WIDTH = 5 + DELTA;
BEARING_MOUNT_DIA = 18;

DD_INNER_DIA = BEARING_INNER_DIA;
DD_OUTER_DIA = 9 + DELTA;
DD_TEETH_DIA = 10 + DELTA;
DD_LENGTH = 14.5;
DD_TEETH_LENGTH = 9;
DD_MESH = 1.5;
DD_SHAFT_LENGTH = DD_LENGTH + 2 * BEARING_WIDTH;
DD_FILAMENT_OFFSET = 3;

COG_INNER_DIA = BEARING_INNER_DIA;
COG_OUTER_DIA = 9.5 + DELTA;
COG_TEETH_DIA = 11.5 + DELTA;
COG_LENGTH = 12.5;
COG_TEETH_LENGTH = 10.5; //5.5;
COG_SHAFT_LENGTH = DD_LENGTH + COG_LENGTH + 2 * BEARING_WIDTH + 2 * WALL_THICKNESS;

CABLE_MOUNT_OUTER_DIA = 18;
CABLE_MOUNT_INNER_DIA = 13 + DELTA;
CABLE_MOUNT_LENGTH = 10;

BOT_BEARING = true;

WORM_INNER_DIA = BEARING_INNER_DIA;
WORM_OUTER_DIA = 11 + DELTA;
WORM_LENGTH = BOT_BEARING ? 20 : 20 + CABLE_MOUNT_LENGTH;
WORM_MESH = 2;
WORM_SHAFT_LENGTH = 50;

WORM_BEARING_INNER_DIA = BOT_BEARING ? 10 : 0;
WORM_BEARING_OUTER_DIA = BOT_BEARING ? (15 + DELTA) : CABLE_MOUNT_INNER_DIA;
WORM_BEARING_WIDTH = BOT_BEARING ? (4 + DELTA) : CABLE_MOUNT_LENGTH;

FILAMENT_DIA = 2;
FILAMENT_GUIDE_LENGTH = 2 * BEARING_WIDTH + BEARING_MOUNT_DIA;
FILAMENT_PORT_DIA = 10;
FILAMENT_PORT_FACE_DIA = 13;
FILAMENT_PORT_LENGTH = 6;

CAP_DIA = CABLE_MOUNT_INNER_DIA - DELTA;
CAP_HEIGHT = CABLE_MOUNT_LENGTH;
CAP_BEARING_INNER_DIA = 10 + DELTA;
CAP_BEARING_OUTER_DIA = 11.5 + DELTA;
CAP_BEARING_HOLE_DIA = 5;
CAP_BEARING_HEIGHT = 3;
CAP_BEARING_AT_HEIGHT = 5;

MOUNTING_HOLE_DIA = 3 + DELTA;
MOUNTING_HOLE_HEAD_DIA = 6.5;
MOUNTING_HOLE_FACE_DIA = MOUNTING_HOLE_HEAD_DIA - 0.1;
MOUNTING_HOLE_HEAD_LENGTH = 3;
MOUNTING_HOLE_LENGTH = BEARING_MOUNT_DIA;

MOUNTING_HOLE_OFFSETS = [
  [-14, (DD_TEETH_DIA - DD_MESH)/2, 0],
  [6, -13, 0]
];

$fn = 50;

module cog(length, outer_dia, inner_dia, teeth_length, teeth_dia) {
  difference() {
    union() {
      cylinder(d = outer_dia, h = length);
      translate([0, 0, length - teeth_length])
      cylinder(d = teeth_dia, h = teeth_length);
    }
    cylinder(d = inner_dia, h = length);
  }
}

module bearing(width, outer_dia, inner_dia) {
  difference() {
    cylinder(d = outer_dia, h = width);
    cylinder(d = inner_dia, h = width);
  }
}

module worm_drive_train() {
  union() {
    cylinder(d = WORM_INNER_DIA, h = WORM_SHAFT_LENGTH);
    bearing(WORM_BEARING_WIDTH, WORM_BEARING_OUTER_DIA, WORM_BEARING_INNER_DIA);

    color("blue")
    cog(WORM_LENGTH, WORM_OUTER_DIA, WORM_INNER_DIA, WORM_LENGTH, WORM_OUTER_DIA);

    translate([0, 0, WORM_LENGTH])
    cylinder(d = CABLE_MOUNT_INNER_DIA, h = CABLE_MOUNT_LENGTH);
  }
}

module extruder_drive_train() {
  union() {
    translate([0, 0, -(COG_SHAFT_LENGTH-(BEARING_WIDTH * 2 + COG_LENGTH + DD_LENGTH))/2])
    cylinder(d = DD_INNER_DIA, h = COG_SHAFT_LENGTH);

    bearing(BEARING_WIDTH, BEARING_OUTER_DIA, BEARING_INNER_DIA);
 
    translate([0, 0, BEARING_WIDTH]) {
      color("blue")
      cog(COG_LENGTH, COG_OUTER_DIA, COG_INNER_DIA, COG_TEETH_LENGTH, COG_TEETH_DIA);

      translate([0, 0, COG_LENGTH]) {
        color("red")
        cog(DD_LENGTH, DD_OUTER_DIA, DD_INNER_DIA, DD_TEETH_LENGTH, DD_TEETH_DIA);

        translate([0, 0, DD_LENGTH])
        bearing(BEARING_WIDTH, BEARING_OUTER_DIA, BEARING_INNER_DIA);
      }
    }
  }
}

module idler_drive_train() {
  translate([0, 0, BEARING_WIDTH + COG_LENGTH])
  union() {
    translate([0, 0, -(DD_SHAFT_LENGTH - DD_LENGTH)/2])
    cylinder(d = DD_INNER_DIA, h = DD_SHAFT_LENGTH);

    color("red")
    cog(DD_LENGTH, DD_OUTER_DIA, DD_INNER_DIA, DD_TEETH_LENGTH, DD_TEETH_DIA);
  }
}

module extruder_drive_assembly() {
  translate([0, -DD_OUTER_DIA/2, 0])
  union() {
    rotate([0, 90, 0])
    translate([0, 0, -(BEARING_WIDTH + COG_LENGTH + DD_FILAMENT_OFFSET)])
    union() {
      extruder_drive_train();

      translate([0, DD_TEETH_DIA - DD_MESH, 0])
      idler_drive_train();
    }

    translate([-(DD_FILAMENT_OFFSET + COG_TEETH_LENGTH/4), -((COG_TEETH_DIA + WORM_OUTER_DIA)/2 - WORM_MESH), -WORM_LENGTH/2 - WORM_BEARING_WIDTH/2])
    worm_drive_train();
  }
}

module mounting_hole(dia, length, head_dia, head_length) {
    color("gray")
    translate([0, 0, -length/2])
    union() {
        cylinder(d = head_dia, h = head_length);
        cylinder(d = dia, h = length);
        translate([0, 0, length - head_length])
        cylinder(d = head_dia, h = head_length);
    }
}

module filament_guide() {
  color("green")
  mounting_hole(FILAMENT_DIA, FILAMENT_GUIDE_LENGTH, FILAMENT_PORT_DIA, FILAMENT_PORT_LENGTH);
}

module mounting_holes() {
    for(t = MOUNTING_HOLE_OFFSETS) {
      translate(t)
      mounting_hole(MOUNTING_HOLE_DIA, MOUNTING_HOLE_LENGTH, MOUNTING_HOLE_HEAD_DIA, MOUNTING_HOLE_HEAD_LENGTH);
    }
}

module negative() {
  filament_guide();
  extruder_drive_assembly();
  mounting_holes();
}

module cap() {
  difference() {
    cylinder(d = CAP_DIA, h = CAP_HEIGHT);
    cylinder(d = CAP_BEARING_HOLE_DIA, h = CAP_HEIGHT);
    translate([0, 0, CAP_BEARING_AT_HEIGHT - CAP_BEARING_HEIGHT])
    cylinder(d = CAP_BEARING_INNER_DIA, h = CAP_HEIGHT);
    translate([0, 0, CAP_BEARING_AT_HEIGHT])
    cylinder(d = CAP_BEARING_OUTER_DIA, h = CAP_HEIGHT);
  }
}

module positive() {
  union() {
    translate([-(DD_FILAMENT_OFFSET + COG_TEETH_LENGTH/4), -((COG_TEETH_DIA + WORM_OUTER_DIA)/2 - WORM_MESH) - DD_OUTER_DIA/2, -WORM_LENGTH/2 - WORM_BEARING_WIDTH/2])
    cylinder(d = CABLE_MOUNT_OUTER_DIA, h = WORM_LENGTH + CABLE_MOUNT_LENGTH);

    translate([0, 0, -FILAMENT_GUIDE_LENGTH/2])
    cylinder(d = FILAMENT_PORT_FACE_DIA, h = FILAMENT_GUIDE_LENGTH);

    rotate([0, 90, 0])
    translate([0, -DD_OUTER_DIA/2, -(BEARING_WIDTH + COG_LENGTH + DD_FILAMENT_OFFSET) - WALL_THICKNESS])
    hull() {
      cylinder(d = BEARING_MOUNT_DIA, h = COG_SHAFT_LENGTH);

      translate([0, DD_TEETH_DIA - DD_MESH, 0])
      cylinder(d = BEARING_MOUNT_DIA, h = COG_SHAFT_LENGTH);
    }
    
    for(t = MOUNTING_HOLE_OFFSETS) {
      translate(t)
      cylinder(d = MOUNTING_HOLE_FACE_DIA, h = MOUNTING_HOLE_LENGTH, center = true);
    }
  }
}

module body() {
  difference() {
    positive();
    negative();
  }
}

module mask() {
  difference() {
    union() {
      translate([-25, (DD_TEETH_DIA - DD_MESH)/2, -BEARING_MOUNT_DIA/2])
      cube(size = [50, 50, BEARING_MOUNT_DIA]);
    }
    for(t = MOUNTING_HOLE_OFFSETS) {
      translate(t)
      cylinder(d = MOUNTING_HOLE_FACE_DIA, h = MOUNTING_HOLE_LENGTH, center = true);
    }
  }
}

// Overview
!union() {
  #positive();
  negative();
}

// Idler
intersection() {
  body();
  mask();
}

// Main Top
intersection() {
  difference() {
    body();
    mask();
  }
  translate([-25, -25, 0])
  cube(size = [50, 50, 50]);
}

// Main Bottom
intersection() {
  difference() {
    body();
    mask();
  }
  translate([-25, -25, -50])
  cube(size = [50, 50, 50]);
}

// Bottom cap
cap();