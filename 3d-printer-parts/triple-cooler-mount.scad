PLATFORM_THICKNESS = 6.2;
PLATFORM_DIA = 58;
WALL_THICKNESS = 1.5;

MOUNT_DIA = 60;
MOUNT_ROD_LENGTH = 10;
MOUNT_ROD_DIA = 6;
MOUNT_ROD_HOLE_DIA = 3;
MOUNT_BASE_DIA = 2 * MOUNT_ROD_DIA;
MOUNT_BASE_THICKNESS = PLATFORM_THICKNESS + 2 * WALL_THICKNESS;

$fn = 30;

module platform() {
  cylinder(d = PLATFORM_DIA*2/sqrt(3), h = PLATFORM_THICKNESS, $fn = 6);
}

module mount() {
  difference() {
    union() { 
      translate([0, 0, MOUNT_BASE_THICKNESS - WALL_THICKNESS])
      cylinder(d = MOUNT_ROD_DIA, h = MOUNT_ROD_LENGTH);

      translate([-(max(0, PLATFORM_DIA - MOUNT_DIA))/2, 0, 0])
      translate([(MOUNT_BASE_DIA - MOUNT_ROD_DIA)/2, 0, 0])
      cylinder(d = MOUNT_BASE_DIA, h = MOUNT_BASE_THICKNESS);
    }

    translate([0, 0, MOUNT_BASE_THICKNESS])
    cylinder(d = MOUNT_ROD_HOLE_DIA, h = MOUNT_ROD_LENGTH - WALL_THICKNESS);
    
    #translate([MOUNT_DIA/2, 0, WALL_THICKNESS])
    rotate([0, 0, 30])
    platform();
  }
}

mount();