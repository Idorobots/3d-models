DELTA = 0.2;
WALL_THICKNESS = 1;

BEARING_INNER_DIA = 5 + DELTA;
BEARING_OUTER_DIA = 11 + DELTA;
BEARING_WIDTH = 5;
BEARING_MOUNT_DIA = 18;

WORM_BEARING_INNER_DIA = 10;
WORM_BEARING_OUTER_DIA = 15 + DELTA;
WORM_BEARING_WIDTH = 4;

DD_INNER_DIA = BEARING_INNER_DIA;
DD_OUTER_DIA = 8.5 + DELTA;
DD_TEETH_DIA = 9.5 + DELTA;
DD_LENGTH = 14.5;
DD_TEETH_LENGTH = 9;
DD_MESH = 1;
DD_SHAFT_LENGTH = DD_LENGTH + 2 * BEARING_WIDTH;
DD_FILAMENT_OFFSET = 3;

COG_INNER_DIA = BEARING_INNER_DIA;
COG_OUTER_DIA = 9 + DELTA;
COG_TEETH_DIA = 11 + DELTA;
COG_LENGTH = 12.5;
COG_TEETH_LENGTH = 10.5; //5.5;
COG_SHAFT_LENGTH = DD_LENGTH + COG_LENGTH + 2 * BEARING_WIDTH + 2 * WALL_THICKNESS;

WORM_INNER_DIA = BEARING_INNER_DIA;
WORM_OUTER_DIA = 10 + DELTA;
WORM_LENGTH = 20;
WORM_MESH = 1.5;
WORM_SHAFT_LENGTH = 50;

CABLE_MOUNT_OUTER_DIA = 18;
CABLE_MOUNT_INNER_DIA = 13.4 + DELTA;
CABLE_MOUNT_LENGTH = 10;

FILAMENT_DIA = 2;
FILAMENT_GUIDE_LENGTH = WORM_BEARING_WIDTH + BEARING_WIDTH + WORM_LENGTH;
FILAMENT_PORT_DIA = 6;
FILAMENT_PORT_FACE_DIA = 13;
FILAMENT_PORT_LENGTH = 5;

MOUNTING_HOLE_DIA = 3 + DELTA;
MOUNTING_HOLE_HEAD_DIA = 6;
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

// Main A
intersection() {
  difference() {
    body();
    mask();
  }
  translate([-25, -25, 0])
  cube(size = [50, 50, 50]);
}

// Main B
intersection() {
  difference() {
    body();
    mask();
  }
  translate([-25, -25, -50])
  cube(size = [50, 50, 50]);
}