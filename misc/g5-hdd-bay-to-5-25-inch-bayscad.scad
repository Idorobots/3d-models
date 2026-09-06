BASE_OFFSET_Z = 4;
BASE_THICKNESS = 2;
BASE_WIDTH = 145;
BASE_LENGTH = 141 - 19;
BASE_HEIGHT = 65;
BASE_OFFSET_X = 19 + 20;
BASE_CORNER_DIA = 20;

CD_MOUNT_HOLE_DIA = 2.5;
CD_MOUNT_HOLE_SPACING_Z = 35;
CD_MOUNT_HOLE_OFFSET_Z = 45 - BASE_OFFSET_Z;
CD_MOUNT_HOLE_SPACING_X = 79;
CD_MOUNT_HOLE_OFFSET_X = 58;

CADDY_MOUNT_HOLE_DIA = 4;
CADDY_MOUNT_HOLE_SPACING_X = 110;
CADDY_MOUNT_HOLE_OFFSET_X = 22 + 20;
CADDY_MOUNT_HOLE_SPACING_Y = 73;
CADDY_MOUNT_HOLE_OFFSET_Y = 6;

$fn = 100;

module mount_holes(width, length, height, dia) {
  for(i = [-1, 1]) {
    for(j = [-1, 1]) {
      translate([i * width/2, j * length/2, 0])
      cylinder(d = dia, h = height);
    }
  }
}

module cd_mount_holes() {
  #translate([-(BASE_LENGTH-CD_MOUNT_HOLE_SPACING_X)/2 + CD_MOUNT_HOLE_OFFSET_X, BASE_WIDTH/2, CD_MOUNT_HOLE_OFFSET_Z])
  rotate([90, 0, 0])
  mount_holes(CD_MOUNT_HOLE_SPACING_X, CD_MOUNT_HOLE_SPACING_Z, BASE_WIDTH, CD_MOUNT_HOLE_DIA);
}

module caddy_mount_holes() {
  #translate([-(BASE_LENGTH-CADDY_MOUNT_HOLE_SPACING_X)/2 + CADDY_MOUNT_HOLE_OFFSET_X, CADDY_MOUNT_HOLE_OFFSET_Y, 0]) {
    mount_holes(CADDY_MOUNT_HOLE_SPACING_X, CADDY_MOUNT_HOLE_SPACING_Y, BASE_WIDTH, CADDY_MOUNT_HOLE_DIA);

    mount_holes(CADDY_MOUNT_HOLE_SPACING_X, 0, BASE_WIDTH, CADDY_MOUNT_HOLE_DIA);
  }
}

module base() {
  translate([-BASE_LENGTH/2 + BASE_OFFSET_X, -BASE_WIDTH/2, 0])
  difference() {
    wt = BASE_THICKNESS;
    cube(size = [BASE_LENGTH, BASE_WIDTH, BASE_HEIGHT]);
    translate([-wt, wt, wt])
    cube(size = [BASE_LENGTH + 2*wt, BASE_WIDTH - 2*wt, BASE_HEIGHT]);
  }
}

module base_holes() {
  #hull()
  translate([BASE_OFFSET_X/2 + 20, 0, 0])
  mount_holes(1.1*BASE_LENGTH/2, 1.25*BASE_WIDTH/2, BASE_THICKNESS, BASE_CORNER_DIA);
}

module base_mask() {
  hull() {
    translate([BASE_OFFSET_X, BASE_WIDTH/2, -BASE_CORNER_DIA/2])
    rotate([90, 0, 0])
    mount_holes(BASE_LENGTH - BASE_CORNER_DIA, 2*BASE_HEIGHT, BASE_WIDTH, BASE_CORNER_DIA);
  }
}

intersection() {
  difference() {
    base();
    base_holes();
    cd_mount_holes();
    caddy_mount_holes();
  }
  base_mask();
}
