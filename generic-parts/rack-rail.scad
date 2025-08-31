SNAP_IN = false;
SNAP_DIA = 1.5;

RAIL_LIP = 3;
RAIL_SPACING = 2;
RAIL_DISTANCE = 49/3;
RAIL_WALL_THICKNESS = 1.5;

BAR_WIDTH = 10;
BAR_THICKNESS = 1;
MOUNT_HOLE_DIA = 6;
SEGMENTS = 11;

$fn = 50;

module segment() {
  height = BAR_THICKNESS + RAIL_LIP;
  d = RAIL_DISTANCE - RAIL_SPACING;
  difference() {
    union() {
      cylinder(d = d, h = height);
      translate([-min(d, BAR_WIDTH)/2, -RAIL_DISTANCE/2, 0])
      cube(size = [BAR_WIDTH, RAIL_DISTANCE, BAR_THICKNESS]);

      if(SNAP_IN) {
        translate([0, 0, BAR_THICKNESS])
        rotate([90, 0, 0])
        cylinder(d = SNAP_DIA, h = RAIL_DISTANCE, center = true);
      }
    }
    translate([0, 0, BAR_THICKNESS])
    cylinder(d = d - 2 * RAIL_WALL_THICKNESS, h = RAIL_LIP);
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
    translate([-RAIL_DISTANCE, 0, 0])
    cube(size = [2 * RAIL_DISTANCE, SEGMENTS * RAIL_DISTANCE, BAR_THICKNESS + RAIL_LIP]);
  }
}

adapter();
