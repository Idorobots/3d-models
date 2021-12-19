RAIL_LIP = 3;
RAIL_SPACING = 2;
RAIL_DISTANCE = 16;
BAR_WIDTH = 10;
BAR_THICKNESS = 2;
MOUNT_HOLE_DIA = 4;
SEGMENTS = 6;

$fn = 50;

module segment() {
  height = BAR_THICKNESS + RAIL_LIP;
  difference() {
    union() {
      cylinder(d = RAIL_DISTANCE-RAIL_SPACING, h = height);
      translate([-BAR_WIDTH/2, -RAIL_DISTANCE/2, 0])
      cube(size = [BAR_WIDTH, RAIL_DISTANCE, BAR_THICKNESS]);
    }
    translate([0, 0, BAR_THICKNESS])
    cylinder(d = BAR_WIDTH, h = RAIL_LIP);
    cylinder(d = MOUNT_HOLE_DIA, h = BAR_THICKNESS);
  }
}

module adapter() {
  intersection() {
    union() {
      for(i = [0 : SEGMENTS]) {
        translate([0, (i + 0.5) * RAIL_DISTANCE, 0])
        segment();
      }
    }
    translate([-RAIL_DISTANCE/2, 0, 0])
    cube(size = [RAIL_DISTANCE, SEGMENTS * RAIL_DISTANCE, BAR_THICKNESS + RAIL_LIP]);
  }
}

adapter();