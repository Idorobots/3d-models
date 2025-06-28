TOWER_DIA = 75;
TOWER_PLACEMENT_DIA = 370;
MOUNT_THICKNESS = 3;
HEIGHT = 20;

CORNER_OUTSET = 70;
CORNER_DIA = 60;
CORNER_PLACEMENT = TOWER_PLACEMENT_DIA/4 + TOWER_DIA/2 - CORNER_DIA/2 + CORNER_OUTSET;
CORNER_OFFSET = (TOWER_PLACEMENT_DIA/2 + TOWER_DIA/2 + MOUNT_THICKNESS - CORNER_PLACEMENT/2 - CORNER_DIA/2)/sin(60);

SLOT_WIDTH = 1.2;
SLOT_INSET = 1.2;
SLOT_HEIGHT = 7;

MOUNT_HOLE_LENGTH = 66;
MOUNT_HOLE_DIA = 5;
MOUNT_HOLE_SPACING = 20;
MOUNT_HOLE_HEAD_DIA = 18.5; // 40;
MOUNT_HOLE_HEAD_WIDTH = 42;
MOUNT_HOLE_HEAD_LENGTH = MOUNT_HOLE_LENGTH - 4;
MOUNT_HOLE_HEAD_OFFSET = -2;
MOUNT_HOLE_OFFSET1 = CORNER_OFFSET - 8;
MOUNT_HOLE_OFFSET2 = CORNER_OFFSET/5;
MOUNT_HOLE_OFFSET3 = 3*CORNER_OFFSET/5;

MODULE = true;
MODULE_WIDTH = 2*CORNER_OFFSET/5;
MODULE_SIZE = 1;

CORNER = !MODULE;

$fn = 100;

module base(d, w, h, s = [1.0, 1.0, 1.0]) {
  hull() {
    for(i = [0, 1, 2]) {
      rotate([0, 0, i*120])
      translate([0, d/2, 0])
      scale(s)
      cylinder(d = w, h = h);
    }
  }
}

module enclosure() {
  hull() {
    for(i = [0, 1, 2]) {
      rotate([0, 0, i*120])
      for(j = [-1, 1]) {
        translate([j * CORNER_OFFSET, -CORNER_PLACEMENT, 0])
        cylinder(d = CORNER_DIA, h = HEIGHT);
      }
    }
  }
}

module slot() {
  w = 1.5*(TOWER_PLACEMENT_DIA/2 + TOWER_DIA/2) + CORNER_OUTSET;
  s1 = (w - 2 * SLOT_INSET)/w;
  s2 = (w - 2 * SLOT_INSET - 2 * SLOT_WIDTH)/w;
  difference() {
    scale([s1, s1, SLOT_HEIGHT/HEIGHT])
    enclosure();
    scale([s2, s2, SLOT_HEIGHT/HEIGHT])
    enclosure();
  }
}

module module_mount_holes() {
  for(i = [0, 1, 2]) {
    rotate([0, 0, i*120])
    for(j = [-1, 1]) {
      for(o = [MOUNT_HOLE_OFFSET2, MOUNT_HOLE_OFFSET3]) {
        translate([j * o, -CORNER_PLACEMENT-CORNER_DIA/2 + (CORNER_OUTSET-MOUNT_HOLE_LENGTH), 0])
        rotate([-90, 0, 0]) {
          translate([-MOUNT_HOLE_SPACING/2, 0, 0])
          cylinder(d = MOUNT_HOLE_DIA, h = MOUNT_HOLE_LENGTH);
          translate([MOUNT_HOLE_SPACING/2, 0, 0])
          cylinder(d = MOUNT_HOLE_DIA, h = MOUNT_HOLE_LENGTH);
          translate([MOUNT_HOLE_HEAD_OFFSET, 0, 0])
          hull() {
            translate([-(MOUNT_HOLE_HEAD_WIDTH-MOUNT_HOLE_HEAD_DIA)/2, 0, 0]) {
              cylinder(d = MOUNT_HOLE_HEAD_DIA, h = MOUNT_HOLE_HEAD_LENGTH);
              translate([0, -HEIGHT/2, 0])
              cylinder(d = MOUNT_HOLE_HEAD_DIA, h = MOUNT_HOLE_HEAD_LENGTH);
            }
            translate([(MOUNT_HOLE_HEAD_WIDTH-MOUNT_HOLE_HEAD_DIA)/2, 0, 0]) {
              cylinder(d = MOUNT_HOLE_HEAD_DIA, h = MOUNT_HOLE_HEAD_LENGTH);
              translate([0, -HEIGHT/2, 0])
              cylinder(d = MOUNT_HOLE_HEAD_DIA, h = MOUNT_HOLE_HEAD_LENGTH);
            }
          }
        }
      }
    }
  }
}
module corner_mount_holes() {
  for(i = [0, 1, 2]) {
    rotate([0, 0, i*120])
    for(j = [-1, 1]) {
      translate([j * MOUNT_HOLE_OFFSET1, -CORNER_PLACEMENT-CORNER_DIA/2 + (CORNER_OUTSET-MOUNT_HOLE_LENGTH), 0])
      rotate([-90, 0, 0]) {
        cylinder(d = MOUNT_HOLE_DIA, h = MOUNT_HOLE_LENGTH);
        translate([j*MOUNT_HOLE_SPACING, 0, MOUNT_HOLE_HEAD_LENGTH * 0.2])
        cylinder(d = MOUNT_HOLE_DIA, h = MOUNT_HOLE_LENGTH * 0.8);

        hull() {
          cylinder(d = MOUNT_HOLE_HEAD_DIA, h = MOUNT_HOLE_HEAD_LENGTH);
          translate([0, -HEIGHT/2, 0])
          cylinder(d = MOUNT_HOLE_HEAD_DIA, h = MOUNT_HOLE_HEAD_LENGTH);

          translate([j*MOUNT_HOLE_SPACING, 0, MOUNT_HOLE_HEAD_LENGTH * 0.20]) {
            cylinder(d = MOUNT_HOLE_HEAD_DIA, h = MOUNT_HOLE_HEAD_LENGTH * 0.8);
            translate([0, -HEIGHT/2, 0])
            cylinder(d = MOUNT_HOLE_HEAD_DIA, h = MOUNT_HOLE_HEAD_LENGTH * 0.8);
          }
        }
      }
    }
  }
}
module module_bevel() {
  difference() {
    scale([0.5, 1.0, 1.0])
    rotate([0, 45, 0])
    cube([HEIGHT/sqrt(2), CORNER_OUTSET, HEIGHT/sqrt(2)], center = true);

    translate([-HEIGHT/4, -CORNER_OUTSET/2 - sin(60)*HEIGHT/2, 0])
    rotate([0, 0, 60])
    cube([HEIGHT, HEIGHT, HEIGHT], center = true);
  }
}

module module_mask(n = 1) {
  difference() {
    union() {
      translate([0, CORNER_OUTSET/2 + SLOT_WIDTH + SLOT_INSET, HEIGHT/2])
      module_bevel();
      cube([MODULE_WIDTH * n, CORNER_OUTSET, HEIGHT]);
    }
    translate([MODULE_WIDTH * n, CORNER_OUTSET/2 + SLOT_WIDTH + SLOT_INSET, HEIGHT/2])
    module_bevel();
  }
}

module corner_mask() {
  #difference() {
    rotate([0, 0, 120])
    union() {
      translate([-TOWER_PLACEMENT_DIA/4-TOWER_DIA/2, 330, 0])
      rotate([0, 0, 90])
      base(TOWER_PLACEMENT_DIA, TOWER_DIA, HEIGHT);
      translate([TOWER_PLACEMENT_DIA/4+TOWER_DIA/2, 330, 0])
      rotate([0, 0, -90])
      base(TOWER_PLACEMENT_DIA, TOWER_DIA, HEIGHT);
    }

    translate([-2*MODULE_WIDTH, -CORNER_PLACEMENT-CORNER_DIA/2, 0])
    module_mask();

    rotate([0, 0, -120])
    translate([MODULE_WIDTH, -CORNER_PLACEMENT-CORNER_DIA/2, 0])
    module_mask();
  }
}

intersection() {
  difference() {
    enclosure();
    #base(TOWER_PLACEMENT_DIA, TOWER_DIA, HEIGHT);
    slot();
    translate([0, 0, HEIGHT - SLOT_HEIGHT])
    slot();
    #translate([0, 0, HEIGHT/2])
    module_mount_holes();
    #translate([0, 0, HEIGHT/2])
    corner_mount_holes();
  }

  if(CORNER) {
    corner_mask();
  }

  if(MODULE) {
    #translate([-MODULE_WIDTH, -CORNER_PLACEMENT-CORNER_DIA/2, 0])
    module_mask(MODULE_SIZE);
  }
}
