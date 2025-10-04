WIDTH = 10;
LENGTH = 63;
THICKNESS = 10;
BODY_OFFSET_Y = 1.5;

MOUNT_HOLE_SPACING = 22.5;
MOUNT_HOLE_OFFSET_Y = -16;
MOUNT_HOLE_OFFSET_Z = 6;

MOUNT_HOLES = 3;
MOUNT_HOLE_DIA = 3.5;
MOUNT_HOLE_HEAD_DIA = 8;
MOUNT_HOLE_HEAD_LENGTH = 4;

PORTS = 2;
PORT_WIDTH = 9;
PORT_LENGTH = 15;
PORT_MOUNT_WIDTH = 9;
PORT_MOUNT_LENGTH = 36;
PORT_MOUNT_OFFSET = 8.5;

PORT_SPACING = MOUNT_HOLE_SPACING;
PORT_OFFSET_Y = -4.5;
PORT_OFFSET_Z = 2;
PORT_OFFSETS_X = [-1.5, 0];

AUDIO_WIDTH = 9;
AUDIO_LENGTH = 7;
AUDIO_OFFSET_Y = -24.5;
AUDIO_OFFSET_Z = PORT_OFFSET_Z;

$fn = 50;

module body() {
  translate([-WIDTH/2, -LENGTH/2 + BODY_OFFSET_Y, 0])
  cube(size = [WIDTH, LENGTH, THICKNESS]);
}

module mount_hole() {
  union() {
    cylinder(d = MOUNT_HOLE_DIA, h = WIDTH);
    translate([-MOUNT_HOLE_HEAD_DIA/2, -MOUNT_HOLE_HEAD_DIA/2, 0])
    cube(size = [MOUNT_HOLE_HEAD_DIA, MOUNT_HOLE_HEAD_DIA, MOUNT_HOLE_HEAD_LENGTH]);
  }
}

module port() {
  union() {
    translate([-WIDTH/2, -PORT_LENGTH/2, 0])
    cube(size = [WIDTH * 1.5, PORT_LENGTH, PORT_WIDTH]);

    translate([-WIDTH/2, -PORT_MOUNT_LENGTH/2, 0])
    cube(size = [WIDTH - PORT_MOUNT_OFFSET, PORT_MOUNT_LENGTH, PORT_MOUNT_WIDTH]);
  }
}

module audio() {
  translate([-WIDTH/2, -AUDIO_LENGTH/2, 0])
  cube(size = [WIDTH, AUDIO_LENGTH, AUDIO_WIDTH]);
}

difference() {
  body();

  #for(i = [0:MOUNT_HOLES-1]) {
    translate([WIDTH/2, MOUNT_HOLE_OFFSET_Y + i * MOUNT_HOLE_SPACING, MOUNT_HOLE_OFFSET_Z])
    rotate([0, -90, 0])
    mount_hole();
  }

  #for(i = [0:PORTS-1]) {
    translate([PORT_OFFSETS_X[i], PORT_OFFSET_Y + i * PORT_SPACING, PORT_OFFSET_Z])
    port();
  }

  #translate([0, AUDIO_OFFSET_Y, AUDIO_OFFSET_Z])
  audio();
}
