WIDTH = 93;
LENGTH = 172;
CORNER_DIA = 5;

FRONT_THICKNESS = 1.2;
WALL_THICKNESS = 1.5;

LIP_THICKNESS = 2;
LIP_HEIGHT = 5;

POWER_WIDTH = 49;
POWER_LENGTH = 29;
POWER_OFFSET_Y = 50;

POWER_HOLE_SPACING_Y = 40;
POWER_HOLE_DIA = 3;
POWER_CORNER_DIA = 3;

GROMMET_DIA = 15;
GROMMET_OFFSET_Y = 0;

PID_WIDTH = 45;
PID_LENGTH = 45;
PID_OFFSET_Y = -40;
PID_CORNER_DIA = 2;

BUTTON_DIA = 22;
BUTTON_OFFSET_Y = 40;

MOUNT_HEIGHT = 16;
MOUNT_WIDTH = 22;
MOUNT_LENGTH = 10;
MOUNT_HOLE_SPACING_X = 14;
MOUNT_HOLE_SPACING_Y = 13;
MOUNT_HOLE_SPACING_X_2 = MOUNT_HOLE_SPACING_X;
MOUNT_HOLE_SPACING_Y_2 = LENGTH - 2 * LIP_THICKNESS - MOUNT_LENGTH;
MOUNT_HOLE_DIA = 2;
MOUNT_HOLE_SLOT = 2;

$fn = 30;

module rounded_rect(width, length, height, corner_dia) {
  hull() {
    for(i = [-1, 1]) {
        for (j = [-1, 1]) {
            translate([i*(width-corner_dia)/2, j*(length-corner_dia)/2, 0])
            cylinder(d = corner_dia, h = height);
        }
    }
  }
}

module empty_side() {
  difference() {
    wt2 = 2 * WALL_THICKNESS;
    union() {
        rounded_rect(WIDTH, LENGTH, FRONT_THICKNESS, CORNER_DIA);
        translate([0, 0, FRONT_THICKNESS])
        rounded_rect(WIDTH - wt2, LENGTH - wt2, LIP_HEIGHT, CORNER_DIA);
    }

    lt2 = 2 * LIP_THICKNESS;
    translate([0, 0, FRONT_THICKNESS])
    rounded_rect(WIDTH - wt2 - lt2, LENGTH - wt2 - lt2, LIP_HEIGHT, CORNER_DIA);
  }
}

module front_side() {
  difference() {
    empty_side();

    translate([0, BUTTON_OFFSET_Y, 0])
    cylinder(d = BUTTON_DIA, h = FRONT_THICKNESS);

    translate([0, PID_OFFSET_Y, 0])
    rounded_rect(PID_WIDTH, PID_LENGTH, FRONT_THICKNESS, PID_CORNER_DIA);

    mount_holes();
  }
}

module back_side() {
  difference() {
    empty_side();

    translate([0, GROMMET_OFFSET_Y, 0])
    cylinder(d = GROMMET_DIA, h = FRONT_THICKNESS);

    translate([0, POWER_OFFSET_Y, 0])
    rounded_rect(POWER_WIDTH, POWER_LENGTH, FRONT_THICKNESS, POWER_CORNER_DIA);

    for(i = [-1, 1]) {
        translate([0, POWER_OFFSET_Y + i * POWER_HOLE_SPACING_Y/2, 0])
        cylinder(d = POWER_HOLE_DIA, h = FRONT_THICKNESS);
    }

    mount_holes();
  }
}

module mount_holes() {
  #for(i = [-1, 1]) {
      translate([i*MOUNT_HOLE_SPACING_X/2, 0, MOUNT_HOLE_SPACING_Y])
      rotate([90, 0, 0])
      cylinder(d = MOUNT_HOLE_DIA, h = LENGTH, center = true);
  }

  #for(i = [-1, 1]) {
      translate([i*MOUNT_HOLE_SPACING_X_2/2, MOUNT_HOLE_SPACING_Y_2/2, 0])
      cylinder(d = MOUNT_HOLE_DIA, h = MOUNT_HEIGHT, center = true);

      translate([i*MOUNT_HOLE_SPACING_X_2/2, -MOUNT_HOLE_SPACING_Y_2/2, 0])
      cylinder(d = MOUNT_HOLE_DIA, h = MOUNT_HEIGHT, center = true);
  }
}

module mount() {
  intersection() {
    difference() {
      wt2 = 2 * WALL_THICKNESS;
      rounded_rect(MOUNT_WIDTH, LENGTH - wt2, MOUNT_HEIGHT, 1);
      rounded_rect(2 * MOUNT_WIDTH, LENGTH - 2 * MOUNT_LENGTH, MOUNT_HEIGHT, CORNER_DIA);

      mount_holes();
      translate([-MOUNT_HOLE_SLOT/2, 0, 0])
      mount_holes();
      translate([MOUNT_HOLE_SLOT/2, 0, 0])
      mount_holes();
      empty_side();
    }
    translate([-WIDTH/2, 0, 0])
    cube([WIDTH, LENGTH, MOUNT_HEIGHT]);
  }
}


mount();
front_side();
!back_side();
