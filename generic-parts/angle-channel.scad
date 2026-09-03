// Angled rectangular cable channel

CHANNEL_ANGLE = 75;

ARM_1_LENGTH = 25;
ARM_1_WIDTH = 40;
ARM_1_HEIGHT = 12;
ARM_1_WALL_THICKNESS = 1;
ARM_1_LIP_LENGTH = 2;
ARM_1_LIP_WALL_THICKNESS = 1;
ARM_1_LIP_CLEARANCE = 0.2;

ARM_2_LENGTH = 30;
ARM_2_WIDTH = 55;
ARM_2_HEIGHT = 29;
ARM_2_WALL_THICKNESS = 1.5;
ARM_2_LIP_LENGTH = 2;
ARM_2_LIP_WALL_THICKNESS = 1;
ARM_2_LIP_CLEARANCE = 0.2;

$fn = 64;

EPSILON = 0.01;
HUB_WIDTH = (ARM_1_WIDTH + ARM_2_WIDTH) / 2;
HUB_HEIGHT = (ARM_1_HEIGHT + ARM_2_HEIGHT) / 2;
HUB_WALL_THICKNESS = (ARM_1_WALL_THICKNESS + ARM_2_WALL_THICKNESS) / 2;

assert(CHANNEL_ANGLE > 0 && CHANNEL_ANGLE < 180,
       "CHANNEL_ANGLE must be between 0 and 180 degrees");

module validate_arm(name, length, width, height, wall_thickness,
                    lip_length, lip_wall_thickness, lip_clearance) {
  lip_outer_width = width - 2 * wall_thickness - 2 * lip_clearance;
  lip_outer_height = height - 2 * wall_thickness - 2 * lip_clearance;

  assert(length > 0, str(name, " length must be positive"));
  assert(wall_thickness > 0, str(name, " wall thickness must be positive"));
  assert(width > 2 * wall_thickness,
         str(name, " width must be greater than twice its wall thickness"));
  assert(height > 2 * wall_thickness,
         str(name, " height must be greater than twice its wall thickness"));
  assert(lip_length >= 0, str(name, " lip length cannot be negative"));
  assert(lip_wall_thickness > 0,
         str(name, " lip wall thickness must be positive"));
  assert(lip_clearance >= 0, str(name, " lip clearance cannot be negative"));
  assert(lip_outer_width > 2 * lip_wall_thickness,
         str(name, " lip is too thick for the available internal width"));
  assert(lip_outer_height > 2 * lip_wall_thickness,
         str(name, " lip is too thick for the available internal height"));
}

module profile(width, height, y) {
  translate([-width / 2, y - EPSILON / 2, -height / 2])
  cube([width, EPSILON, height]);
}

module tapered_prism(length, start_width, start_height,
                     end_width, end_height) {
  hull() {
    profile(start_width, start_height, 0);
    profile(end_width, end_height, length);
  }
}

module outer_arm(length, width, height) {
  tapered_prism(length, HUB_WIDTH, HUB_HEIGHT, width, height);
}

module arm_passage(length, width, height, wall_thickness) {
  tapered_prism(
    length,
    HUB_WIDTH - 2 * HUB_WALL_THICKNESS,
    HUB_HEIGHT - 2 * HUB_WALL_THICKNESS,
    width - 2 * wall_thickness,
    height - 2 * wall_thickness
  );
}

module connector_lip(length, width, height, wall_thickness,
                     lip_length, lip_wall_thickness, lip_clearance) {
  lip_outer_width = width - 2 * wall_thickness - 2 * lip_clearance;
  lip_outer_height = height - 2 * wall_thickness - 2 * lip_clearance;
  lip_inner_width = lip_outer_width - 2 * lip_wall_thickness;
  lip_inner_height = lip_outer_height - 2 * lip_wall_thickness;
  if (lip_length > 0) {
    difference() {
      union() {
        // The shoulder joins the smaller lip to the arm's end walls.
        translate([-width / 2, length - lip_wall_thickness, -height / 2])
        cube([width, lip_wall_thickness, height]);

        translate([
          -lip_outer_width / 2,
          length - EPSILON,
          -lip_outer_height / 2
        ])
        cube([lip_outer_width, lip_length + EPSILON, lip_outer_height]);
      }

      translate([
        -lip_inner_width / 2,
        length - lip_wall_thickness - EPSILON,
        -lip_inner_height / 2
      ])
      cube([
        lip_inner_width,
        lip_length + lip_wall_thickness + 2 * EPSILON,
        lip_inner_height
      ]);
    }
  }
}

module oriented_outer_arm(angle, length, width, height) {
  rotate([angle, 0, 0])
  outer_arm(length, width, height);
}

module oriented_arm_passage(angle, length, width, height, wall_thickness) {
  rotate([angle, 0, 0])
  arm_passage(length, width, height, wall_thickness);
}

module oriented_connector_lip(angle, length, width, height, wall_thickness,
                              lip_length, lip_wall_thickness, lip_clearance) {
  rotate([angle, 0, 0])
  connector_lip(length, width, height, wall_thickness,
                lip_length, lip_wall_thickness, lip_clearance);
}

validate_arm(
  "ARM_1", ARM_1_LENGTH, ARM_1_WIDTH, ARM_1_HEIGHT,
  ARM_1_WALL_THICKNESS, ARM_1_LIP_LENGTH,
  ARM_1_LIP_WALL_THICKNESS, ARM_1_LIP_CLEARANCE
);
validate_arm(
  "ARM_2", ARM_2_LENGTH, ARM_2_WIDTH, ARM_2_HEIGHT,
  ARM_2_WALL_THICKNESS, ARM_2_LIP_LENGTH,
  ARM_2_LIP_WALL_THICKNESS, ARM_2_LIP_CLEARANCE
);

// The centerlines bend in the YZ plane around the larger WIDTH dimension.
union() {
  difference() {
    union() {
      rotate([0, 90, 0])
      cylinder(d = HUB_HEIGHT, h = HUB_WIDTH, center = true);

      oriented_outer_arm(
        -CHANNEL_ANGLE / 2,
        ARM_1_LENGTH, ARM_1_WIDTH, ARM_1_HEIGHT
      );
      oriented_outer_arm(
        CHANNEL_ANGLE / 2,
        ARM_2_LENGTH, ARM_2_WIDTH, ARM_2_HEIGHT
      );
    }

    union() {
      rotate([0, 90, 0])
      cylinder(
        d = HUB_HEIGHT - 2 * HUB_WALL_THICKNESS,
        h = HUB_WIDTH - 2 * HUB_WALL_THICKNESS,
        center = true
      );

      oriented_arm_passage(
        -CHANNEL_ANGLE / 2,
        ARM_1_LENGTH, ARM_1_WIDTH, ARM_1_HEIGHT, ARM_1_WALL_THICKNESS
      );
      oriented_arm_passage(
        CHANNEL_ANGLE / 2,
        ARM_2_LENGTH, ARM_2_WIDTH, ARM_2_HEIGHT, ARM_2_WALL_THICKNESS
      );
    }
  }

  oriented_connector_lip(
    -CHANNEL_ANGLE / 2,
    ARM_1_LENGTH, ARM_1_WIDTH, ARM_1_HEIGHT, ARM_1_WALL_THICKNESS,
    ARM_1_LIP_LENGTH, ARM_1_LIP_WALL_THICKNESS, ARM_1_LIP_CLEARANCE
  );
  oriented_connector_lip(
    CHANNEL_ANGLE / 2,
    ARM_2_LENGTH, ARM_2_WIDTH, ARM_2_HEIGHT, ARM_2_WALL_THICKNESS,
    ARM_2_LIP_LENGTH, ARM_2_LIP_WALL_THICKNESS, ARM_2_LIP_CLEARANCE
  );
}
