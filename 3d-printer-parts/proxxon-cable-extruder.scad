BEARING_INNER_DIA = 4;
BEARING_OUTER_DIA = 8;
BEARING_WIDTH = 4;
BEARING_MOUNT_DIA = 20;

DD_INNER_DIA = 5;
DD_OUTER_DIA = 10;
DD_TEETH_DIA = 12;
DD_LENGTH = 15;
DD_TEETH_LENGTH = 3;
DD_MESH = 3;
DD_SHAFT_LENGTH = DD_LENGTH + 2 * BEARING_WIDTH;
DD_FILAMENT_OFFSET = 4;

COG_INNER_DIA = 4;
COG_OUTER_DIA = 10;
COG_TEETH_DIA = 12;
COG_LENGTH = 10;
COG_TEETH_LENGTH = 5;
COG_SHAFT_LENGTH = DD_LENGTH + COG_LENGTH + 2 * BEARING_WIDTH;

WORM_INNER_DIA = 4;
WORM_OUTER_DIA = 10;
WORM_LENGTH = 20;
WORM_MESH = 2;
WORM_SHAFT_LENGTH = 50;

CABLE_MOUNT_OUTER_DIA = 18;
CABLE_MOUNT_INNER_DIA = 12;
CABLE_MOUNT_LENGTH = 10;

FILAMENT_DIA = 2;
FILAMENT_GUIDE_LENGTH = 2 * BEARING_WIDTH + WORM_LENGTH;
FILAMENT_PORT_DIA = 6;
FILAMENT_PORT_FACE_DIA = 20;
FILAMENT_PORT_LENGTH = 5;

MOUNTING_HOLE_DIA = 3;
MOUNTING_HOLE_HEAD_DIA = 6;
MOUNTING_HOLE_FACE_DIA = 6;
MOUNTING_HOLE_HEAD_LENGTH = 3;
MOUNTING_HOLE_LENGTH = BEARING_MOUNT_DIA;

MOUNTING_HOLE_OFFSETS = [
  [-13, 5, 0],
  [7, -15, 0]
];

$fn = 30;

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
    bearing(BEARING_WIDTH, BEARING_OUTER_DIA, BEARING_INNER_DIA);

    translate([0, 0, BEARING_WIDTH]) {
      color("blue")
      cog(WORM_LENGTH, WORM_OUTER_DIA, WORM_INNER_DIA, WORM_LENGTH, WORM_OUTER_DIA);

      translate([0, 0, WORM_LENGTH])
      cylinder(d = CABLE_MOUNT_INNER_DIA, h = CABLE_MOUNT_LENGTH);
    }
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

    translate([-(DD_FILAMENT_OFFSET + COG_TEETH_LENGTH/2), -((COG_TEETH_DIA + WORM_OUTER_DIA)/2 - WORM_MESH), -WORM_LENGTH/2 - BEARING_WIDTH])
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
    translate([-(DD_FILAMENT_OFFSET + COG_TEETH_LENGTH/2), -((COG_TEETH_DIA + WORM_OUTER_DIA)/2 - WORM_MESH) - DD_OUTER_DIA/2, -WORM_LENGTH/2 - BEARING_WIDTH])
    cylinder(d = CABLE_MOUNT_OUTER_DIA, h = BEARING_WIDTH + WORM_LENGTH + CABLE_MOUNT_LENGTH);

    translate([0, 0, -FILAMENT_GUIDE_LENGTH/2])
    cylinder(d = FILAMENT_PORT_FACE_DIA, h = FILAMENT_GUIDE_LENGTH);

    rotate([0, 90, 0])
    translate([0, -DD_OUTER_DIA/2, -(BEARING_WIDTH + COG_LENGTH + DD_FILAMENT_OFFSET)])
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
      rotate([0, 90, 0])
      translate([0, DD_TEETH_DIA - DD_MESH - DD_OUTER_DIA/2, - DD_FILAMENT_OFFSET - BEARING_WIDTH])
      cylinder(d = DD_INNER_DIA, h = DD_SHAFT_LENGTH);
    }
    for(t = MOUNTING_HOLE_OFFSETS) {
      translate(t)
      cylinder(d = MOUNTING_HOLE_FACE_DIA, h = MOUNTING_HOLE_LENGTH, center = true);
    }
  }
  
  //translate([-25, 0, -25])
  //cube(size = [50, 50, 50]);
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