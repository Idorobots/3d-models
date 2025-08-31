FLAT = true;

CHAMFER = 3;
WIDTH = 19;
LENGTH = 120;
THICKNESS = 1.5;

INSERT_WIDTH = 10;
INSERT_LENGTH = 8;

BACK_WIDTH = WIDTH;
BACK_LENGTH = 7;
BACK_OFFSET = 3;

TAB_WIDTH = BACK_WIDTH;
TAB_HEIGHT = 12;

MOUNT_HOLE_DIA = 4;
MOUNT_HOLE_HEIGHT = 5.5;
MOUNT_HOLE_OFFSET = 6 + BACK_OFFSET;

ETHERNET_WIDTH = 13;
ETHERNET_LENGTH = 16;
ETHERNET_HOLE_SPACING = 27;
ETHERNET_HOLE_OFFSET = 1.5;
ETHERNET_HOLE_DIA = 3.2;
ETHERNET_OFFSET = 0;

WIFI_HOLE_DIA = 6;
WIFI_OFFSETS = [-30, 30];


$fn = 50;

module tab() {
  difference() {
    translate([0, BACK_OFFSET, TAB_HEIGHT/2])
    cube([THICKNESS, TAB_WIDTH, TAB_HEIGHT], center = true);

    #translate([0, MOUNT_HOLE_OFFSET, MOUNT_HOLE_HEIGHT])
    rotate([0,90,0])
    cylinder(d = MOUNT_HOLE_DIA, h = THICKNESS, center = true);
  }
}

module pci_bracket() {
  union() {
    linear_extrude(THICKNESS)
    polygon(points = [
      [-LENGTH/2, INSERT_WIDTH/2 - CHAMFER/2],
      [-LENGTH/2 + CHAMFER/2, INSERT_WIDTH/2],
      [-LENGTH/2 + INSERT_LENGTH, INSERT_WIDTH/2],
      [-LENGTH/2 + INSERT_LENGTH + CHAMFER * 1.5, WIDTH/2],
      [LENGTH/2 - BACK_LENGTH, WIDTH/2],
      [LENGTH/2 - BACK_LENGTH + CHAMFER, BACK_WIDTH/2 + BACK_OFFSET],
      [LENGTH/2, BACK_WIDTH/2 + BACK_OFFSET],
      [LENGTH/2, - BACK_WIDTH/2 + BACK_OFFSET],
      [LENGTH/2 - BACK_LENGTH + CHAMFER, -BACK_WIDTH/2 + BACK_OFFSET],
      [LENGTH/2 - BACK_LENGTH, -WIDTH/2],
      [-LENGTH/2 + INSERT_LENGTH + CHAMFER * 1.5, -WIDTH/2],
      [-LENGTH/2 + INSERT_LENGTH, -INSERT_WIDTH/2],
      [-LENGTH/2 + CHAMFER/2, -INSERT_WIDTH/2],
      [-LENGTH/2, -INSERT_WIDTH/2 + CHAMFER/2]
    ]);

    if(FLAT) {
      translate([LENGTH/2, 0, THICKNESS/2])
      rotate([0, 90, 0])
      tab();
    } else {
      translate([LENGTH/2-THICKNESS/2, 0, 0])
      tab();
    }
  }
}

module ethernet_port() {
  translate([-ETHERNET_HOLE_SPACING/2, ETHERNET_HOLE_OFFSET, 0])
  cylinder(d = ETHERNET_HOLE_DIA, h = THICKNESS);
  translate([ETHERNET_HOLE_SPACING/2, ETHERNET_HOLE_OFFSET, 0])
  cylinder(d = ETHERNET_HOLE_DIA, h = THICKNESS);
  translate([-ETHERNET_LENGTH/2, -ETHERNET_WIDTH/2, 0])
  cube(size = [ETHERNET_LENGTH, ETHERNET_WIDTH, THICKNESS]);
}

module wifi_port() {
  cylinder(d = WIFI_HOLE_DIA, h = THICKNESS);
}

difference() {
  pci_bracket();
  #translate([ETHERNET_OFFSET, 0, 0])
  ethernet_port();

  #for(w = WIFI_OFFSETS) {
    translate([w, 0, 0])
    wifi_port();
  }
}
