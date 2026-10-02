RACK_WIDTH = 194;
RACK_DEPTH = 172;
CORNER_DIA = 10;

RACK_BRACE_OFFSET = 10;
RACK_BRACE_LENGTH = 15;
RACK_BRACES = 5;
BRACES_BOTH_SIDES = false;

THICKNESS = 2;

LEVER_HOLE_DIA = 3.2;
LEVER_HOLE_SPACING = [RACK_WIDTH - CORNER_DIA, RACK_DEPTH - CORNER_DIA];

NOTCH_DIA = 2;
NOTCH_OFFSET = 8;

STANDOFF_HEIGHT = 6;
STANDOFF_DIA = 8;

CROSSBAR_DIA = STANDOFF_HEIGHT - THICKNESS;

ITX = true;
ITX_OFFSET_X = 6;
ITX_OFFSET_Y = 1;
ITX_WIDTH = 170;
ITX_LENGTH = 170;
ITX_HOLE_WIDTH = 150;
ITX_HOLE_LENGTH = 150;
ITX_HOLE_DIA = 5;
ITX_HOLE_SPACING_1 = [154.94, 157.48];
ITX_HOLE_SPACING_2 = [154.95 - 2 * 22.86, 157.48];

VESA = true;
VESA_OFFSET_X = 0;
VESA_OFFSET_Y = 0;
VESA_WIDTH = 85;
VESA_LENGTH = 85;
VESA_HOLE_WIDTH = 65;
VESA_HOLE_LENGTH = 65;
VESA_HOLE_DIA = ITX_HOLE_DIA;
VESA_HOLE_SPACING_1 = [100, 100];
VESA_HOLE_SPACING_2 = [75, 75];
VESA_BARS_WIDTH = 10;

FAN = false;
FAN_SIZE = 120;
FAN_HOLE_SPACING = FAN_SIZE - 16;
FAN_MOUNT_HOLE_DIA = 5;
FAN_OFFSET_X = 0;
FAN_OFFSET_Y = 0;

GENERIC = false;
//GENERIC_MOUNT_HOLES = []; // Array of [OFFSET_X, OFFSET_Y, HOLE_DIA, STANDOFF_DIA, STANDOFF_HEIGHT]
GENERIC_BAR_WIDTH = 10;
GENERIC_OFFSET_X = 0;
GENERIC_OFFSET_Y = 0;

// ITX
/*
VESA = false;
STANDOFF_DIA = ITX_HOLE_DIA + 4;
/**/

// Minix Z300
/*
ITX = false;
VESA_OFFSET_X = 0;
VESA_OFFSET_Y = 24;
STANDOFF_DIA = ITX_HOLE_DIA + 4;
/**/

// Winnet G250
/*
CROSSBAR_DIA = 4;
STANDOFF_HEIGHT = 8;
BRACES_BOTH_SIDES = true;
RACK_BRACE_LENGTH = 9;
VESA = false;
ITX_OFFSET_X = 0;
ITX_OFFSET_Y = 0;
/**/

// 120 mm Fan
/*
VESA = false;
ITX = false;
FAN = true;
FAN_SIZE = 120;
BRACES_BOTH_SIDES = true;
/**/

// Double RPi mount
/*
VESA = false;
ITX = false;
FAN = false;
GENERIC = true;
GENERIC_BAR_WIDTH = 6;
RPI_HOLE_DIA = 3;
RPI_DISTANCE = 100;

STANDOFF_DIA = 6;
BRACES_BOTH_SIDES = true;
ITX_OFFSET_X = 0;
ITX_OFFSET_Y = 0;

GENERIC_MOUNT_HOLES = [
  // [OFFSET_X, OFFSET_Y, HOLE_DIA, STANDOFF_DIA, STANDOFF_HEIGHT]
  [-29, -24.5 - RPI_DISTANCE/2, RPI_HOLE_DIA, STANDOFF_DIA, STANDOFF_HEIGHT],
  [29, -24.5 - RPI_DISTANCE/2, RPI_HOLE_DIA, STANDOFF_DIA, STANDOFF_HEIGHT],
  [-29, 24.5 - RPI_DISTANCE/2, RPI_HOLE_DIA, STANDOFF_DIA, STANDOFF_HEIGHT],
  [29, 24.5 - RPI_DISTANCE/2, RPI_HOLE_DIA, STANDOFF_DIA, STANDOFF_HEIGHT],
  [-29, -24.5 + RPI_DISTANCE/2, RPI_HOLE_DIA, STANDOFF_DIA, STANDOFF_HEIGHT],
  [29, -24.5 + RPI_DISTANCE/2, RPI_HOLE_DIA, STANDOFF_DIA, STANDOFF_HEIGHT],
  [-29, 24.5 + RPI_DISTANCE/2, RPI_HOLE_DIA, STANDOFF_DIA, STANDOFF_HEIGHT],
  [29, 24.5 + RPI_DISTANCE/2, RPI_HOLE_DIA, STANDOFF_DIA, STANDOFF_HEIGHT]
];


/**/
$fn = 100;

module mount_holes(width, length, height, dia) {
  for(i = [-1, 1]) {
    for(j = [-1, 1]) {
      translate([i * width/2, j * length/2, 0])
      cylinder(d = dia, h = height);
    }
  }
}

module rounded_rect(width, length, height, dia) {
  hull()
  mount_holes(width-dia, length-dia, height, dia);
}

module cross_bar(length, dia) {
  hull() {
    translate([0, length/2, 0])
    sphere(d = dia);

    translate([0, -length/2, 0])
    sphere(d = dia);
  }
}

module cross_bars(width, length, dia) {
  for(i = [-1, 1]) {
    hull()
    translate([i * width/2, 0, 0])
    cross_bar(length, dia);

    hull()
    translate([0, i * length/2, 0])
    rotate([0, 0, 90])
    cross_bar(width, dia);
  }
}

module rack_tabs() {
  difference() {
    union() {
      rounded_rect(RACK_WIDTH, RACK_DEPTH, THICKNESS, CORNER_DIA);
      for(s = BRACES_BOTH_SIDES ? [-1, 1]: [-1]) {
        translate([s * RACK_WIDTH/2, -RACK_DEPTH/2, THICKNESS])
        for(i = [1:RACK_BRACES]) {
          translate([-s * (RACK_BRACE_OFFSET + RACK_BRACE_LENGTH/2), i * RACK_DEPTH/(RACK_BRACES+1), 0]) {
            hull() {
              translate([-RACK_BRACE_LENGTH/2, 0, 0])
              sphere(d = CROSSBAR_DIA);
              translate([RACK_BRACE_LENGTH/2, 0, 0])
              sphere(d = CROSSBAR_DIA);
            }
          }
        }
      }
    }
    translate([ITX_OFFSET_X, ITX_OFFSET_Y, 0])
    rounded_rect(ITX_HOLE_WIDTH, ITX_HOLE_LENGTH, THICKNESS, CORNER_DIA);
  }
}

module rack_mount_holes() {
  #mount_holes(LEVER_HOLE_SPACING[0], LEVER_HOLE_SPACING[1], STANDOFF_HEIGHT, LEVER_HOLE_DIA);
  #mount_holes(RACK_WIDTH, RACK_DEPTH - 2 * NOTCH_OFFSET, THICKNESS, NOTCH_DIA);
}

module itx_mount() {
  difference() {
    union() {
      rounded_rect(ITX_WIDTH, ITX_LENGTH, THICKNESS, CORNER_DIA);

      mount_holes(ITX_HOLE_SPACING_1[0], ITX_HOLE_SPACING_1[1], STANDOFF_HEIGHT, STANDOFF_DIA);
      mount_holes(ITX_HOLE_SPACING_2[0], ITX_HOLE_SPACING_2[1], STANDOFF_HEIGHT, STANDOFF_DIA);
      translate([0, 0, THICKNESS])
      cross_bars(ITX_HOLE_SPACING_1[0], ITX_HOLE_SPACING_1[1], CROSSBAR_DIA);
    }
    rounded_rect(ITX_HOLE_WIDTH, ITX_HOLE_LENGTH, THICKNESS, CORNER_DIA);
  }
}

module itx_mount_holes() {
  #mount_holes(ITX_HOLE_SPACING_1[0], ITX_HOLE_SPACING_1[1], STANDOFF_HEIGHT, ITX_HOLE_DIA);
  #mount_holes(ITX_HOLE_SPACING_2[0], ITX_HOLE_SPACING_2[1], STANDOFF_HEIGHT, ITX_HOLE_DIA);
}

module vesa_mount() {
  difference() {
    union() {
      rounded_rect(VESA_WIDTH, VESA_LENGTH, THICKNESS, CORNER_DIA);
      mount_holes(VESA_HOLE_SPACING_1[0], VESA_HOLE_SPACING_1[1], STANDOFF_HEIGHT, STANDOFF_DIA);
      mount_holes(VESA_HOLE_SPACING_2[0], VESA_HOLE_SPACING_2[1], STANDOFF_HEIGHT, STANDOFF_DIA);

      dx = (VESA_OFFSET_X - ITX_OFFSET_X);
      dy = (VESA_OFFSET_Y - ITX_OFFSET_Y);

      translate([0, 0, THICKNESS]) {
        cross_bars(VESA_HOLE_SPACING_2[0], VESA_HOLE_SPACING_2[1], CROSSBAR_DIA);
        translate([-dx, -dy, 0])
        cross_bars(ITX_HOLE_SPACING_1[0], ITX_HOLE_SPACING_1[1], CROSSBAR_DIA);
      }
      for(i = [-1, 1]) {
        for(j = [-1, 1]) {
          hull() {
            translate([i * VESA_HOLE_SPACING_2[0]/2, j * VESA_HOLE_SPACING_2[1]/2])
            cylinder(d = VESA_BARS_WIDTH, h = THICKNESS);
            translate([i * ITX_HOLE_SPACING_1[0]/2 - dx, j * ITX_HOLE_SPACING_1[1]/2 - dy])
            cylinder(d = VESA_BARS_WIDTH, h = THICKNESS);
          }
          translate([0, 0, THICKNESS])
          hull() {
            translate([i * VESA_HOLE_SPACING_2[0]/2, j * VESA_HOLE_SPACING_2[1]/2])
            sphere(d = CROSSBAR_DIA);
            translate([i * ITX_HOLE_SPACING_1[0]/2 - dx, j * ITX_HOLE_SPACING_1[1]/2 - dy])
            sphere(d = CROSSBAR_DIA);
          }
        }
      }
    }
    rounded_rect(VESA_HOLE_WIDTH, VESA_HOLE_LENGTH, THICKNESS, CORNER_DIA);
  }
}

module vesa_mount_holes() {
  #mount_holes(VESA_HOLE_SPACING_1[0], VESA_HOLE_SPACING_1[1], STANDOFF_HEIGHT, VESA_HOLE_DIA);
  #mount_holes(VESA_HOLE_SPACING_2[0], VESA_HOLE_SPACING_2[1], STANDOFF_HEIGHT, VESA_HOLE_DIA);
}
module fan_mount() {
  difference() {
    translate([ITX_OFFSET_X, ITX_OFFSET_Y, 0])
    rounded_rect(ITX_HOLE_WIDTH, ITX_HOLE_LENGTH, THICKNESS, CORNER_DIA);
    cylinder(d = FAN_SIZE, h = THICKNESS);
  }
}

module fan_mount_holes() {
  #mount_holes(FAN_HOLE_SPACING, FAN_HOLE_SPACING, STANDOFF_HEIGHT, FAN_MOUNT_HOLE_DIA);
}

module generic_mount() {
  for (i = [0 : len(GENERIC_MOUNT_HOLES)-1]) {
    translate([GENERIC_MOUNT_HOLES[i][0], GENERIC_MOUNT_HOLES[i][1], 0])
    cylinder(d = GENERIC_MOUNT_HOLES[i][3], h = GENERIC_MOUNT_HOLES[i][4]);

    translate([GENERIC_MOUNT_HOLES[i][0], 0, 0]) {
      rounded_rect(GENERIC_BAR_WIDTH, ITX_HOLE_LENGTH, THICKNESS, GENERIC_BAR_WIDTH);
      translate([0, 0, THICKNESS])
      cross_bar(ITX_HOLE_LENGTH, CROSSBAR_DIA);
    }
    translate([0, GENERIC_MOUNT_HOLES[i][1], 0])
    rotate([0, 0, 90]) {
      rounded_rect(GENERIC_BAR_WIDTH, ITX_HOLE_WIDTH, THICKNESS, GENERIC_BAR_WIDTH);
      translate([0, 0, THICKNESS])
      cross_bar(ITX_HOLE_WIDTH - CORNER_DIA, CROSSBAR_DIA);
    }
  }

  translate([ITX_HOLE_WIDTH/2 - CORNER_DIA/2, 0, 0]) {
    rounded_rect(GENERIC_BAR_WIDTH, ITX_HOLE_LENGTH, THICKNESS, GENERIC_BAR_WIDTH);
    translate([CORNER_DIA/2, 0, 0])
    rounded_rect(GENERIC_BAR_WIDTH, ITX_HOLE_LENGTH, THICKNESS, GENERIC_BAR_WIDTH);
    translate([0, 0, THICKNESS])
    cross_bar(ITX_HOLE_WIDTH, CROSSBAR_DIA);
  }

  translate([-ITX_HOLE_WIDTH/2 + CORNER_DIA/2, 0, 0]) {
    rounded_rect(GENERIC_BAR_WIDTH, ITX_HOLE_LENGTH, THICKNESS, GENERIC_BAR_WIDTH);
    translate([-CORNER_DIA/2, 0, 0])
    rounded_rect(GENERIC_BAR_WIDTH, ITX_HOLE_LENGTH, THICKNESS, GENERIC_BAR_WIDTH);
    translate([0, 0, THICKNESS])
    cross_bar(ITX_HOLE_WIDTH, CROSSBAR_DIA);
  }
}

module generic_mount_holes() {
  #for (i = [0 : len(GENERIC_MOUNT_HOLES)-1]) {
    translate([GENERIC_MOUNT_HOLES[i][0], GENERIC_MOUNT_HOLES[i][1], 0]) {
      cylinder(d = GENERIC_MOUNT_HOLES[i][2], h = GENERIC_MOUNT_HOLES[i][4]);
    }
  }
}


intersection() {
  difference() {
    union() {
      rack_tabs();

      if (ITX) {
        translate([ITX_OFFSET_X, ITX_OFFSET_Y, 0])
        itx_mount();
      }

      if (VESA) {
        translate([VESA_OFFSET_X, VESA_OFFSET_Y, 0])
        vesa_mount();
      }

      if (FAN) {
        translate([FAN_OFFSET_X, FAN_OFFSET_Y, 0])
        fan_mount();
      }

      if (GENERIC) {
        translate([GENERIC_OFFSET_X, GENERIC_OFFSET_Y, 0])
        generic_mount();
      }
    }
    rack_mount_holes();

    if (ITX) {
      translate([ITX_OFFSET_X, ITX_OFFSET_Y, 0])
      itx_mount_holes();
    }

    if (VESA) {
      translate([VESA_OFFSET_X, VESA_OFFSET_Y, 0])
      vesa_mount_holes();
    }

    if (FAN) {
      translate([FAN_OFFSET_X, FAN_OFFSET_Y, 0])
      fan_mount_holes();
    }

    if (GENERIC) {
      translate([GENERIC_OFFSET_X, GENERIC_OFFSET_Y, 0])
      generic_mount_holes();
    }
  }

  hull()
  scale([1.0, 1.0, 10])
  rack_tabs();
}
