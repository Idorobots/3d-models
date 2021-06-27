RAIL_TOP_WIDTH = 1.5;
RAIL_BOT_WIDTH = 2.5;
RAIL_SLOT_WIDTH = 2.1;
RAIL_SPACING = 15;
RAIL_DEPTH = 3;
RAIL_CORNER_DIA = 8;

HEIGHT = 160;
WIDTH = 160;
THICKNESS = 4;

MOUNT_HOLES = true;
MOUNT_HOLE_DIA = 5;
MOUNT_HOLE_OFFSET = 5;

FAN_MOUNT_SPACING = 105;
FAN_MOUNT_SECONDARY_SPACING = 124.5;
FAN_MOUNT_DIA = 5;
FAN_DIA = 140;
FAN_BRACE_WIDTH = RAIL_BOT_WIDTH;
FAN = WIDTH > FAN_DIA && HEIGHT > FAN_DIA;

LIMIT = true;
LIMIT_ON_THE_RIGHT = true;
LIMIT_DIA = 1;
LIMIT_SPACING = 145;

///

N_RAILS = floor(HEIGHT / RAIL_SPACING);


$fn = 50;

module rails() {
  off = RAIL_SPACING/2 + ((HEIGHT / RAIL_SPACING) - N_RAILS) * RAIL_SPACING/2;
  delta = RAIL_SLOT_WIDTH/2 + RAIL_BOT_WIDTH/2;
  
  for(i = [0:HEIGHT/RAIL_SPACING-1]) {
    translate([RAIL_BOT_WIDTH/2, i * RAIL_SPACING + off + delta, 0])
    rail();
    translate([RAIL_BOT_WIDTH/2, i * RAIL_SPACING + off - delta, 0])
    rail();
  }
}

module rail() {
  hull() {
    translate([0, 0, THICKNESS])
    cylinder(d1 = RAIL_BOT_WIDTH, d2 = RAIL_TOP_WIDTH, h = RAIL_DEPTH);
    cylinder(d = RAIL_BOT_WIDTH, h = THICKNESS);

    translate([WIDTH - RAIL_BOT_WIDTH, 0, THICKNESS])
    cylinder(d1 = RAIL_BOT_WIDTH, d2 = RAIL_TOP_WIDTH, h = RAIL_DEPTH);
    translate([WIDTH - RAIL_BOT_WIDTH, 0, 0])
    cylinder(d = RAIL_BOT_WIDTH, h = THICKNESS);
  }  
}

module base() {
  cube(size = [WIDTH, HEIGHT, THICKNESS]);
}

module fan() {
  difference() {
    cylinder(d = FAN_DIA, h = THICKNESS + RAIL_DEPTH);
    cube(size = [FAN_BRACE_WIDTH, FAN_DIA, (THICKNESS + RAIL_DEPTH)*2], center = true);
  }
}

module fan_mount_holes() {
  union() {
    for(i = [-1, 1]) {
      for(j = [-1, 1]) {
        translate([i * FAN_MOUNT_SPACING/2, j * FAN_MOUNT_SPACING/2, 0])
        cylinder(d = FAN_MOUNT_DIA, h = THICKNESS);

        translate([i * FAN_MOUNT_SECONDARY_SPACING/2, j * FAN_MOUNT_SECONDARY_SPACING/2, 0])
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
    i = LIMIT_ON_THE_RIGHT ? 1 : -1;
    translate([i * LIMIT_SPACING/2 + WIDTH/2, 0, THICKNESS])
    rotate(-90, [1, 0, 0])
    cylinder(d = LIMIT_DIA, h = HEIGHT);
  } else {
    translate([WIDTH/2, 0, THICKNESS])
    rotate(-90, [1, 0, 0])
    cylinder(d = LIMIT_DIA, h = HEIGHT);
  }
}


difference() {
  union() {
    difference() {
      union() {
        base();
        if(LIMIT) {
          limit();
        }
      }

      if(FAN) {
        translate([WIDTH/2, HEIGHT/2, 0])
        fan();
      }
    }
    rails();
  }
 
  if(MOUNT_HOLES) {
    mount_holes();
  }

  if(FAN) {
    translate([WIDTH/2, HEIGHT/2, 0])
    fan_mount_holes();
  }
}