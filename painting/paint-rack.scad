// Vallejo 60 ml bottles
///*
BOTTLE_DIA = 36;
BOTTLE_ANGLE = 45;
BOTTLE_HEIGHT = 28;
BOTTLE_SPACING = 5;
BOTTLE_LIP = 12;

N_COLS = 4;
N_ROWS = 5;
SUPPORT_SPACING = 2;
/**/

// Vallejo 17 ml bottles
/*
BOTTLE_DIA = 27;
BOTTLE_ANGLE = 45;
BOTTLE_HEIGHT = 22;
BOTTLE_SPACING = 5;
BOTTLE_LIP = 12;

N_COLS = 5;
N_ROWS = 7;
SUPPORT_SPACING = 3;
/**/

SUPPORT_WIDTH = 5;
THICKNESS = 4;

$fn = 50;

module shelf() {
  length = N_COLS * BOTTLE_DIA + (N_COLS + 1) * BOTTLE_SPACING;
  width = 1/cos(90 - BOTTLE_ANGLE) * BOTTLE_DIA + BOTTLE_LIP;
  difference() {
    translate([0, -1/cos(90 - BOTTLE_ANGLE) * BOTTLE_DIA/2 - BOTTLE_SPACING, 0])
    cube(size = [length, width, THICKNESS]);
    #for(i = [0:N_COLS-1]) {
      translate([(i + 0.5) * BOTTLE_DIA + (i + 1) * BOTTLE_SPACING, 0, 0])
      rotate(90 - BOTTLE_ANGLE, [1, 0, 0])
      cylinder(d = BOTTLE_DIA, h = 2 * BOTTLE_HEIGHT, center = true);
    }
  }
}

module shelves() {
  width = 1/cos(90 - BOTTLE_ANGLE) * BOTTLE_DIA;
  for(i = [1:N_ROWS]) {
    translate([0, i * tan(BOTTLE_ANGLE) * BOTTLE_HEIGHT, i * BOTTLE_HEIGHT])
    shelf();
  }
}

module crossbar() {
  length = N_COLS * BOTTLE_DIA + (N_COLS + 1) * BOTTLE_SPACING;
  width = 1/cos(90 - BOTTLE_ANGLE) * BOTTLE_DIA + BOTTLE_LIP;
  difference() {
    translate([0, -BOTTLE_SPACING + 1/cos(90 - BOTTLE_ANGLE) * BOTTLE_DIA/2, 0])
    cube(size = [length, BOTTLE_LIP, THICKNESS]);
  }
}

module support() {
  bottle_width = 1/cos(90 - BOTTLE_ANGLE) * BOTTLE_DIA;
  height = (N_ROWS + 1) * BOTTLE_HEIGHT;
  width = (N_ROWS + 1) * tan(BOTTLE_ANGLE) * BOTTLE_HEIGHT;
  length = sqrt(width * width + height * height);
  // FIXME Only works for <= 45 deg angle.
  cross_length = sqrt(width * width - length/2 * length/2);

  translate([0, (bottle_width + BOTTLE_SPACING)/2, 0])
  intersection() {
    cube(size = [THICKNESS, 1.5 * width, (N_ROWS + 0.5) * BOTTLE_HEIGHT]);

    union() {
      translate([0, width, 0])
      rotate(BOTTLE_ANGLE, [1, 0, 0])
      cube(size = [THICKNESS, SUPPORT_WIDTH, cross_length]);

      translate([0, 1/cos(90 - BOTTLE_ANGLE) * SUPPORT_WIDTH/2, 0])
      cube(size = [THICKNESS, width, SUPPORT_WIDTH]);

      rotate(BOTTLE_ANGLE, [-1, 0, 0])
      translate([0, 0, SUPPORT_WIDTH])
      cube(size = [THICKNESS, BOTTLE_LIP, length]);
    }
  }
}

module supports() {
  for(i = [0:ceil(N_COLS/SUPPORT_SPACING) - 1]) {
      translate([SUPPORT_SPACING * (i + 1/SUPPORT_SPACING) * (BOTTLE_DIA + BOTTLE_SPACING) + (BOTTLE_SPACING - THICKNESS)/2, 0, 0])
      support();  
  }
}

intersect = -1/cos(90 - BOTTLE_ANGLE) * BOTTLE_LIP;

// overview
!union() {
translate([0, 0, SUPPORT_WIDTH]) {
  shelves();
  crossbar();
}
translate([0, intersect, 0])
supports();
}

// shelf
difference() {
    translate([0, 0, SUPPORT_WIDTH])
    shelf();
    translate([0, intersect/2, 0])
    supports();
}

// crossbar
difference() {
    translate([0, 0, SUPPORT_WIDTH])
    crossbar();
    translate([0, intersect/2, 0])
    supports();
}

// support
difference() {
    translate([0, intersect, 0])
    support();
    translate([0, intersect/2, SUPPORT_WIDTH]) {
        shelves();
        crossbar();
    }
}