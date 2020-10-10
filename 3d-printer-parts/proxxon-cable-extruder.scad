DD_INNER_DIA = 5;
DD_OUTER_DIA = 8;
DD_TEETH_DIA = 10;
DD_LENGTH = 15;
DD_TEETH_LENGTH = 3;
DD_MESH = 2;
DD_SHAFT_LENGTH = 26;
DD_FILAMENT_OFFSET = 4;

COG_INNER_DIA = 4;
COG_OUTER_DIA = 10;
COG_TEETH_DIA = 12;
COG_LENGTH = 10;
COG_TEETH_LENGTH = 5;
COG_SHAFT_LENGTH = 40;

WORM_INNER_DIA = 3;
WORM_OUTER_DIA = 10;
WORM_LENGTH = 20;
WORM_MESH = 1.5;
WORM_SHAFT_LENGTH = 50;

BEARING_INNER_DIA = 4;
BEARING_OUTER_DIA = 10;
BEARING_WIDTH = 4;

FILAMENT_DIA = 2;
FILAMENT_GUIDE_LENGTH = 30;

$fn = 30;

module cog(length, outer_dia, inner_dia, teeth_length, teeth_dia) {
  difference() {
    union() {
      cylinder(d = outer_dia, h = length);
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
    translate([0, 0, BEARING_WIDTH])
    color("blue")
    cog(WORM_LENGTH, WORM_OUTER_DIA, WORM_INNER_DIA, WORM_LENGTH, WORM_OUTER_DIA);
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
        translate([0, 0, DD_LENGTH])
        rotate([180, 0, 0])
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

    translate([0, 0, DD_LENGTH])
    rotate([180, 0, 0])
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

    translate([-(DD_FILAMENT_OFFSET + COG_LENGTH - COG_TEETH_LENGTH/2), -((COG_TEETH_DIA + WORM_OUTER_DIA)/2 - WORM_MESH), -WORM_LENGTH/2])
    worm_drive_train();
  }
}

module filament_guide() {
  color("green")
  cylinder(d = FILAMENT_DIA, h = FILAMENT_GUIDE_LENGTH, center = true);
}

filament_guide();
extruder_drive_assembly();
