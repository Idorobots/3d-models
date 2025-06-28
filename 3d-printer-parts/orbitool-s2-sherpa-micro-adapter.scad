THICKNESS = 2;

STANDOFF_HEIGHT = 5;
STANDOFF_DIA = 8;

MOUNT_HOLE_SPACING = 44;
MOUNT_HOLE_DIA = 3.5;
MOUNT_HOLE_HEAD_DIA = 6;
MOUNT_HOLE_HEAD_HEIGHT = 4;
MOUNT_DIA = STANDOFF_DIA;

SHERPA_ANGLE = 50;
ORBITOOL_ANGLE = 30;
ORBITOOL_BULGE_DIA = 40;
ORBITOOL_BULGE_OFFSET = -2;
ORBITOOL_SENSOR_ACCESS_DIA = 20;
ORBITOOL_SENSOR_ACCESS_OFFSET_X = -36;
ORBITOOL_SENSOR_ACCESS_OFFSET_Y = 8;

$fn = 100;

module holes(dia, height) {
  for(i = [0, 1]) {
    rotate([0, 0, SHERPA_ANGLE])
    translate([0, i * MOUNT_HOLE_SPACING, 0])
    cylinder(d = dia, h = height);

    rotate([0, 0, ORBITOOL_ANGLE])
    translate([0, i * MOUNT_HOLE_SPACING,  0])
    cylinder(d = dia, h = height);

  }
}

module standoffs() {
  for(i = [0, 1]) {
    rotate([0, 0, SHERPA_ANGLE])
    translate([0, i * MOUNT_HOLE_SPACING, 0])
    cylinder(d = STANDOFF_DIA, h = THICKNESS + STANDOFF_HEIGHT);
  }
}

difference() {
  union() {
    hull() {
      holes(dia = MOUNT_DIA, height = THICKNESS);
      rotate([0, 0, ORBITOOL_ANGLE])
      translate([ORBITOOL_BULGE_OFFSET, MOUNT_HOLE_SPACING/2, 0])
      cylinder(d = ORBITOOL_BULGE_DIA, h = THICKNESS);
    }
    standoffs();
  }
  #holes(dia = MOUNT_HOLE_DIA, height = THICKNESS + STANDOFF_HEIGHT);

  #rotate([0, 0, SHERPA_ANGLE])
  translate([0, MOUNT_HOLE_SPACING, 0])
  cylinder(d = MOUNT_HOLE_HEAD_DIA, h = MOUNT_HOLE_HEAD_HEIGHT);

  #translate([ORBITOOL_SENSOR_ACCESS_OFFSET_X, ORBITOOL_SENSOR_ACCESS_OFFSET_Y, 0])
  cylinder(d = ORBITOOL_SENSOR_ACCESS_DIA, h = MOUNT_HOLE_HEAD_HEIGHT);
}
