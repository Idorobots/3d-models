WEBBING_X = 25;
WEBBING_Y = 20;
WEBBING_THICKNESS = 2;
WEBBING_DIA = 3;
WEBBING_OFFSET = 8;

THICKNESS = 3.5;
CORNER_DIA = 5;
LENGTH = 40;
WIDTH = 34;

MAGNET_DIA = 18;
MAGNET_THICKNESS = 3;
MAGNET_OFFSET = 2;

TUBE_SLOT_WIDTH = 8;
TUBE_SLOT_LENGTH = 4;
TUBE_MAGNET_DIA = 12;
TUBE_MAGNET_THICKNESS = 3.2;
TUBE_MAGNET_OFFSET = 1;
TUBE_THICKNESS = 3;
TUBE_WIDTH = TUBE_MAGNET_DIA;
TUBE_LENGTH = TUBE_MAGNET_DIA + 2 * TUBE_SLOT_LENGTH + 2 * TUBE_THICKNESS;

$fn = 30;

module rounded_rect(width, length, thickness, corner_dia) {
  hull() {
    for(i = [-1, 1]) {
      for(j = [-1, 1]) {
        translate([i * (width - corner_dia)/2, j * (length - corner_dia)/2, 0])
        cylinder(d = corner_dia, h = thickness);
      }
    }
  }
}

module webbing_slot(width, length, thickness, corner_dia) {
  union() {
    rounded_rect(width, corner_dia, thickness, corner_dia);
    translate([0, length/2 - corner_dia/2, thickness])
    rounded_rect(width, length, thickness, corner_dia);

    translate([width/3, length/sqrt(2)/2, 0])
    rotate([0, 0, 45])
    rounded_rect(length, thickness, thickness, thickness);
  }
}

module mount() {
  difference() {
    rounded_rect(WIDTH, LENGTH, THICKNESS, CORNER_DIA);

    #for(i = [-1, 1]) {
      rotate([0, 0, i * 90 + 90])
      translate([0, (LENGTH/2 - WEBBING_OFFSET + WEBBING_DIA), 0])
      webbing_slot(WEBBING_X, WEBBING_OFFSET * 2, WEBBING_THICKNESS, WEBBING_DIA);

      rotate([0, 0, i * 90])
      translate([0, (WIDTH/2 - WEBBING_OFFSET + WEBBING_DIA), 0])
      webbing_slot(WEBBING_Y, WEBBING_OFFSET * 2, WEBBING_THICKNESS, WEBBING_DIA);
    }

    #translate([0, 0, MAGNET_OFFSET])
    cylinder(d = MAGNET_DIA, h = MAGNET_THICKNESS);
  }
}

module tube_clamp() {
  difference() {
    hull() {
      rounded_rect(TUBE_SLOT_WIDTH + TUBE_THICKNESS * 2, TUBE_LENGTH, TUBE_THICKNESS, CORNER_DIA);
      cylinder(d = TUBE_MAGNET_DIA, h = TUBE_THICKNESS);
    }

    #for(i = [-1, 1]) {
      translate([0, i * (TUBE_LENGTH/2 - TUBE_THICKNESS/2 - TUBE_SLOT_LENGTH/2), TUBE_THICKNESS/2]) {
        rounded_rect(TUBE_SLOT_WIDTH, TUBE_SLOT_LENGTH, TUBE_THICKNESS/2, 1);

        for(j = [-1, 1]) {
          translate([j * (TUBE_SLOT_WIDTH/2 - TUBE_THICKNESS/2), 0, -TUBE_THICKNESS/2])
          rotate([0, 0, 90])
          rounded_rect(TUBE_SLOT_LENGTH, TUBE_THICKNESS, TUBE_THICKNESS/2, 1);
        }
      }

    }

    #translate([0, 0, TUBE_MAGNET_OFFSET])
    cylinder(d = TUBE_MAGNET_DIA, h = TUBE_MAGNET_THICKNESS);
  }
}

mount();

translate([0, 0, THICKNESS + MAGNET_THICKNESS + MAGNET_OFFSET])
rotate([180, 0, 0])
tube_clamp();
