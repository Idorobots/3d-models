// Articulated rectangular cable channel

OUTPUT = "arm_2"; // "assembly", "arm_1", "arm_2", or "print"

CHANNEL_ANGLE = 75;

// Angles are measured from each arm's centerline in the positive bend direction.
ARM_1_HUB_OPENING_START_ANGLE =50;
ARM_1_HUB_OPENING_END_ANGLE = 180;
ARM_2_HUB_OPENING_START_ANGLE = 45;
ARM_2_HUB_OPENING_END_ANGLE = 220;

ARM_1_LENGTH = 25;
ARM_1_WIDTH = 40;
ARM_1_HEIGHT = 14;
ARM_1_WALL_THICKNESS = 1;
ARM_1_LIP_LENGTH = 0;
ARM_1_LIP_WALL_THICKNESS = 1;
ARM_1_LIP_CLEARANCE = 0.2;

ARM_2_LENGTH = 30;
ARM_2_WIDTH = 56;
ARM_2_HEIGHT = 29;
ARM_2_WALL_THICKNESS = 1.5;
ARM_2_LIP_LENGTH = 2;
ARM_2_LIP_WALL_THICKNESS = 1;
ARM_2_LIP_CLEARANCE = 0.2;

BOLT_HOLE_DIAMETER = 4.5;
BOLT_HOLE_CUT_MARGIN = 10;
HUB_OPENING_CUT_MARGIN = 20;
HUB_FIT_DELTA = 0.3;
JOINT_RADIAL_CLEARANCE = 0.3;

$fn = 64;

EPSILON = 0.01;
HUB_WIDTH = (ARM_1_WIDTH + ARM_2_WIDTH) / 2;
HUB_WALL_THICKNESS =
  (ARM_1_WALL_THICKNESS + ARM_2_WALL_THICKNESS) / 2;
HUB_DIAMETER = (ARM_1_HEIGHT + ARM_2_HEIGHT) / 2;
INNER_HUB_WIDTH = HUB_WIDTH - HUB_WALL_THICKNESS - HUB_FIT_DELTA;
OUTER_HUB_WIDTH = HUB_WIDTH + HUB_WALL_THICKNESS + HUB_FIT_DELTA;
FORK_WIDTH = OUTER_HUB_WIDTH;
FORK_GAP = INNER_HUB_WIDTH + 2 * HUB_FIT_DELTA;
FORK_CHEEK_THICKNESS = (FORK_WIDTH - FORK_GAP) / 2;
HUB_SIDE_THICKNESS = HUB_WALL_THICKNESS;

INNER_HUB_OUTER_DIAMETER = HUB_DIAMETER - 2 * JOINT_RADIAL_CLEARANCE;
INNER_HUB_INNER_DIAMETER =
  INNER_HUB_OUTER_DIAMETER - 2 * HUB_WALL_THICKNESS;
OUTER_HUB_INNER_DIAMETER =
  INNER_HUB_OUTER_DIAMETER + 2 * JOINT_RADIAL_CLEARANCE;
OUTER_HUB_OUTER_DIAMETER =
  OUTER_HUB_INNER_DIAMETER + 2 * HUB_WALL_THICKNESS;

FORK_RADIUS = OUTER_HUB_OUTER_DIAMETER / 2;
INNER_HUB_OUTER_RADIUS = INNER_HUB_OUTER_DIAMETER / 2;

assert(OUTPUT == "assembly" || OUTPUT == "arm_1" ||
       OUTPUT == "arm_2" || OUTPUT == "print",
       "OUTPUT must be assembly, arm_1, arm_2, or print");
assert(CHANNEL_ANGLE > 0 && CHANNEL_ANGLE < 180,
       "CHANNEL_ANGLE must be between 0 and 180 degrees");
assert(ARM_1_HUB_OPENING_START_ANGLE >= 0 &&
       ARM_1_HUB_OPENING_END_ANGLE <= 360 &&
       ARM_1_HUB_OPENING_START_ANGLE < ARM_1_HUB_OPENING_END_ANGLE,
       "ARM_1 hub opening must define an increasing range within 0..360");
assert(ARM_2_HUB_OPENING_START_ANGLE >= 0 &&
       ARM_2_HUB_OPENING_END_ANGLE <= 360 &&
       ARM_2_HUB_OPENING_START_ANGLE < ARM_2_HUB_OPENING_END_ANGLE,
       "ARM_2 hub opening must define an increasing range within 0..360");
assert(BOLT_HOLE_DIAMETER > 0,
       "BOLT_HOLE_DIAMETER must be positive");
assert(HUB_FIT_DELTA >= 0,
       "HUB_FIT_DELTA cannot be negative");
assert(FORK_CHEEK_THICKNESS > 0,
       "The outer hub is too narrow to contain the inner hub");
assert(HUB_SIDE_THICKNESS > 0 &&
       2 * HUB_SIDE_THICKNESS < INNER_HUB_WIDTH,
       "HUB_SIDE_THICKNESS leaves no hollow space in the inner hub");
assert(INNER_HUB_INNER_DIAMETER > BOLT_HOLE_DIAMETER,
       "The inner hub is too small for the requested bolt hole");
assert(ARM_1_LENGTH > INNER_HUB_OUTER_RADIUS &&
       ARM_2_LENGTH > FORK_RADIUS,
       "Arm lengths must exceed their hub radii");

module validate_arm(name, width, height, wall_thickness,
                    lip_length, lip_wall_thickness, lip_clearance) {
  lip_outer_width = width - 2 * wall_thickness - 2 * lip_clearance;
  lip_outer_height = height - 2 * wall_thickness - 2 * lip_clearance;

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

module tapered_prism(start_y, end_y, start_width, start_height,
                     end_width, end_height) {
  hull() {
    profile(start_width, start_height, start_y);
    profile(end_width, end_height, end_y);
  }
}

module x_cylinder(diameter, length) {
  rotate([0, 90, 0])
  cylinder(d = diameter, h = length, center = true);
}

module ring_sector_x(inner_radius, outer_radius, width,
                     start_angle, end_angle) {
  rotate([0, 90, 0])
  rotate([0, 0, start_angle + 90])
  rotate_extrude(angle = end_angle - start_angle, convexity = 10)
  translate([inner_radius, -width / 2])
  square([outer_radius - inner_radius, width]);
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

module inner_hub() {
  cavity_width = INNER_HUB_WIDTH - 2 * HUB_SIDE_THICKNESS;

  difference() {
    union() {
      x_cylinder(INNER_HUB_OUTER_DIAMETER, INNER_HUB_WIDTH);
      tapered_prism(
        0,
        ARM_1_LENGTH,
        INNER_HUB_WIDTH,
        INNER_HUB_OUTER_DIAMETER,
        ARM_1_WIDTH,
        ARM_1_HEIGHT
      );
    }

    x_cylinder(INNER_HUB_INNER_DIAMETER, cavity_width);

    ring_sector_x(
      0,
      INNER_HUB_OUTER_RADIUS + HUB_OPENING_CUT_MARGIN,
      cavity_width + 2 * EPSILON,
      ARM_1_HUB_OPENING_START_ANGLE,
      ARM_1_HUB_OPENING_END_ANGLE
    );

    tapered_prism(
      -EPSILON,
      ARM_1_LENGTH + EPSILON,
      cavity_width,
      INNER_HUB_INNER_DIAMETER,
      ARM_1_WIDTH - 2 * ARM_1_WALL_THICKNESS,
      ARM_1_HEIGHT - 2 * ARM_1_WALL_THICKNESS
    );

  }
}

module fork_hub() {
  difference() {
    union() {
      x_cylinder(OUTER_HUB_OUTER_DIAMETER, FORK_WIDTH);
      tapered_prism(
        0,
        ARM_2_LENGTH,
        FORK_WIDTH,
        OUTER_HUB_OUTER_DIAMETER,
        ARM_2_WIDTH,
        ARM_2_HEIGHT
      );
    }

    // The bore receives ARM_1's rotating central hub.
    x_cylinder(OUTER_HUB_INNER_DIAMETER, FORK_GAP);

    ring_sector_x(
      0,
      FORK_RADIUS + HUB_OPENING_CUT_MARGIN,
      FORK_GAP + 2 * EPSILON,
      ARM_2_HUB_OPENING_START_ANGLE,
      ARM_2_HUB_OPENING_END_ANGLE
    );

    tapered_prism(
      -EPSILON,
      ARM_2_LENGTH + EPSILON,
      FORK_GAP,
      OUTER_HUB_OUTER_DIAMETER - 2 * HUB_WALL_THICKNESS,
      ARM_2_WIDTH - 2 * ARM_2_WALL_THICKNESS,
      ARM_2_HEIGHT - 2 * ARM_2_WALL_THICKNESS
    );

  }
}

module arm_1_part() {
  difference() {
    union() {
      inner_hub();
      connector_lip(
        ARM_1_LENGTH,
        ARM_1_WIDTH,
        ARM_1_HEIGHT,
        ARM_1_WALL_THICKNESS,
        ARM_1_LIP_LENGTH,
        ARM_1_LIP_WALL_THICKNESS,
        ARM_1_LIP_CLEARANCE
      );
    }

    x_cylinder(
      BOLT_HOLE_DIAMETER,
      INNER_HUB_WIDTH + 2 * BOLT_HOLE_CUT_MARGIN
    );
  }
}

module arm_2_part() {
  difference() {
    union() {
      fork_hub();
      connector_lip(
        ARM_2_LENGTH,
        ARM_2_WIDTH,
        ARM_2_HEIGHT,
        ARM_2_WALL_THICKNESS,
        ARM_2_LIP_LENGTH,
        ARM_2_LIP_WALL_THICKNESS,
        ARM_2_LIP_CLEARANCE
      );
    }

    x_cylinder(
      BOLT_HOLE_DIAMETER,
      FORK_WIDTH + 2 * BOLT_HOLE_CUT_MARGIN
    );
  }
}

validate_arm(
  "ARM_1", ARM_1_WIDTH, ARM_1_HEIGHT, ARM_1_WALL_THICKNESS,
  ARM_1_LIP_LENGTH, ARM_1_LIP_WALL_THICKNESS, ARM_1_LIP_CLEARANCE
);
validate_arm(
  "ARM_2", ARM_2_WIDTH, ARM_2_HEIGHT, ARM_2_WALL_THICKNESS,
  ARM_2_LIP_LENGTH, ARM_2_LIP_WALL_THICKNESS, ARM_2_LIP_CLEARANCE
);

if (OUTPUT == "assembly") {
  rotate([-CHANNEL_ANGLE, 180, 0])
  arm_1_part();
  arm_2_part();
} else if (OUTPUT == "arm_1") {
  arm_1_part();
} else if (OUTPUT == "arm_2") {
  arm_2_part();
} else if (OUTPUT == "print") {
  translate([0, 0, INNER_HUB_OUTER_RADIUS])
  arm_1_part();

  translate([
    0,
    ARM_1_LENGTH + ARM_2_LENGTH + HUB_DIAMETER,
    max(FORK_RADIUS, ARM_2_HEIGHT / 2)
  ])
  arm_2_part();
}
