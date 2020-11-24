RAIL_TOP_WIDTH = 2;
RAIL_BOT_WIDTH = 4;
RAIL_SPACING = RAIL_BOT_WIDTH + 2;
RAIL_DEPTH = 2;
RAIL_CORNER_DIA = 8;

HEIGHT = 24 * RAIL_SPACING;
WIDTH = 162;
THICKNESS = 4;

MOUNT_HOLES = true;
MOUNT_HOLE_DIA = 5;
MOUNT_HOLE_OFFSET = 5;

FAN = WIDTH > 120 && HEIGHT > 120;
FAN_MOUNT_SPACING = 105;
FAN_MOUNT_DIA = 5;
FAN_DIA = 130;

LIMIT = true;
LIMIT_DIA = 1.5;
LIMIT_SPACING = 140;

///

N_RAILS = floor(HEIGHT / RAIL_SPACING);


$fn = 30;

module rails() {
  off = RAIL_SPACING/2 + ((HEIGHT / RAIL_SPACING) - N_RAILS) * RAIL_SPACING/2;
  for(i = [0:HEIGHT/RAIL_SPACING-1]) {
    translate([RAIL_BOT_WIDTH/2, i * RAIL_SPACING + off, THICKNESS])
    hull() {
      cylinder(d1 = RAIL_BOT_WIDTH, d2 = RAIL_TOP_WIDTH, h = RAIL_DEPTH);
      translate([WIDTH - RAIL_BOT_WIDTH, 0, 0])
      cylinder(d1 = RAIL_BOT_WIDTH, d2 = RAIL_TOP_WIDTH, h = RAIL_DEPTH);
    }
  }
}

module base() {
  cube(size = [WIDTH, HEIGHT, THICKNESS]);
}

module fan() {
  union() {
    cylinder(d = FAN_DIA, h = THICKNESS + RAIL_DEPTH);
    for(i = [-1, 1]) {
      for(j = [-1, 1]) {
        translate([i * FAN_MOUNT_SPACING/2, j * FAN_MOUNT_SPACING/2, 0])
        cylinder(d = FAN_MOUNT_DIA, h = THICKNESS);
      }
    }
  }
}

module mount_holes() {
  translate([WIDTH/2, HEIGHT/2, 0])
  for(i = [-1, 1]) {
    for(j = [-1, 1]) {
      translate([i * (WIDTH - MOUNT_HOLE_OFFSET - MOUNT_HOLE_DIA)/2, j * (HEIGHT - MOUNT_HOLE_OFFSET - MOUNT_HOLE_DIA)/2, 0])
      cylinder(d = MOUNT_HOLE_DIA, h = THICKNESS);
    }
  }
}

module limit() {
  if(WIDTH > LIMIT_SPACING) {
    translate([WIDTH/2, 0, THICKNESS])
    for(i = [-1, 1]) {
      translate([i * LIMIT_SPACING/2, 0, 0])
      rotate(-90, [1, 0, 0])
      cylinder(d = LIMIT_DIA, h = HEIGHT);
    }
  } else {
    translate([WIDTH/2, 0, THICKNESS])
    rotate(-90, [1, 0, 0])
    cylinder(d = LIMIT_DIA, h = HEIGHT);
  }
}


difference() {
  union() {
    rails();
    base();
    if(LIMIT) {
      limit();
    }
  }

  if(MOUNT_HOLES) {
    mount_holes();
  }
  if(FAN) {
    translate([WIDTH/2, HEIGHT/2, 0])
    fan();
  }
}