HEAD_DIA = 60;
HEAD_THICKNESS = 12;

ARM_DIA = 21;
ARM_LENGTH = 150;

TOOL_CAVITY_WIDTH = ARM_LENGTH - HEAD_DIA - 5;
TOOL_CAVITY_LENGTH = HEAD_DIA - ARM_DIA - 5;

CORNER_DIA = 5;
WALL_THICKNESS = 1.5;

$fn = 50;

OFFSET = 10;

module micrometer() {
  #union() {
    hull() {
      cylinder(d = HEAD_DIA, h = HEAD_THICKNESS);
      translate([-HEAD_DIA/2, (HEAD_DIA - ARM_DIA)/2, HEAD_THICKNESS/2])
      rotate([0, 90, 0])
      cylinder(d = HEAD_THICKNESS, h = HEAD_DIA);

      translate([0, 0, OFFSET]) {
        cylinder(d = HEAD_DIA, h = HEAD_THICKNESS);
        translate([-HEAD_DIA/2, (HEAD_DIA - ARM_DIA)/2, HEAD_THICKNESS/2])
        rotate([0, 90, 0])
        cylinder(d = HEAD_THICKNESS, h = HEAD_DIA);
      }
    }

    hull() {
      translate([-HEAD_DIA/2, (HEAD_DIA - ARM_DIA)/2, HEAD_THICKNESS/2])
      rotate([0, 90, 0])
      cylinder(d = ARM_DIA, h = ARM_LENGTH);

      translate([-HEAD_DIA/2, (HEAD_DIA - ARM_DIA)/2, HEAD_THICKNESS/2 + OFFSET])
      rotate([0, 90, 0])
      cylinder(d = ARM_DIA, h = ARM_LENGTH);
    }
  }
}

module rounded_rect(width, length, height, corner_dia) {
  hull() {
    for(i = [-1, 1]) {
      for(j = [-1, 1]) {
        translate([i * (width - corner_dia)/2, j * (length - corner_dia)/2, 0])
        cylinder(d = corner_dia, h = height);
      }
    }
  }
}

module tool_cavity() {
  #rounded_rect(TOOL_CAVITY_WIDTH, TOOL_CAVITY_LENGTH, HEAD_THICKNESS + OFFSET, CORNER_DIA);
}

module insert() {
  difference() {
    translate([(ARM_LENGTH - HEAD_DIA)/2, 0, -(ARM_DIA - HEAD_THICKNESS)/2 - WALL_THICKNESS])
    rounded_rect(ARM_LENGTH + 2 * WALL_THICKNESS, HEAD_DIA + 2 * WALL_THICKNESS, ARM_DIA + WALL_THICKNESS, CORNER_DIA);

    union() {
      micrometer();
      translate([ARM_LENGTH - TOOL_CAVITY_WIDTH/2 - HEAD_DIA/2, -(HEAD_DIA-TOOL_CAVITY_LENGTH)/2, 0])
      tool_cavity();
    }
  }
}

module case() {
  difference() {
    delta = 1.0;
    wt = 2 * WALL_THICKNESS;

    scale_x = (ARM_LENGTH + 2 * wt + delta) / (ARM_LENGTH + wt + delta);
    scale_y = (HEAD_DIA + 2 * wt + delta) / (HEAD_DIA + wt + delta);
    scale_z = (ARM_DIA + 1.5 * wt + delta) / (ARM_DIA + 0.5 * wt + delta);

    scale([scale_x, scale_y, scale_z])
    hull()
    insert();

    delta_x = (ARM_LENGTH + wt + delta) / (ARM_LENGTH + wt);    delta_y = (HEAD_DIA + wt + delta) / (HEAD_DIA + wt);
    delta_z = (ARM_DIA + 0.5 * wt + delta) / (ARM_DIA + 0.5 * wt);

    #translate([scale_x/2 * WALL_THICKNESS/2, 0, scale_z/2 * WALL_THICKNESS/2])
    scale([delta_x, delta_y, delta_z])
    hull() {
      insert();
      translate([10, 0, 0])
      insert();
    }

    #translate([ARM_LENGTH - HEAD_DIA/2 + WALL_THICKNESS, 0, (ARM_DIA-HEAD_THICKNESS)/2 + WALL_THICKNESS])
    rotate([90, 0, 0])
    cylinder(d = ARM_DIA + WALL_THICKNESS, h = 2 * HEAD_DIA, center = true);
  }
}

//insert();
case();
