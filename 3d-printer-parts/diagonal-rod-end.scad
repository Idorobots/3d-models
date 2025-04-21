ROD_DIA = 6.35;
ROD_SIDE_LENGTH = 25;
ROD_SIDE_OFFSET = 10;
ROD_DEPTH = 20;

BALL_DIA = 10.2;
BALL_SIDE_LENGTH = 15;
BALL_SIDE_OFFSET = BALL_DIA + 1.2;

SPRING_HOLE_DIA = 2;
SPRING_HOLE_THICKNESS = 2.5;
SPRING_HOLE_OFFSET = 5.5;

WALL_THICKNESS = 1.5;

$fn = 50;

difference() {
  union() {
    cylinder(d = ROD_DIA + 2 * WALL_THICKNESS, h = ROD_SIDE_LENGTH);

    translate([SPRING_HOLE_OFFSET, 0, 0])
    cylinder(d = SPRING_HOLE_DIA + 2 * WALL_THICKNESS, h = SPRING_HOLE_THICKNESS);

    hull() {
      translate([0, 0, ROD_SIDE_OFFSET])
      cylinder(d = ROD_DIA + 2 * WALL_THICKNESS, h = ROD_SIDE_LENGTH - ROD_SIDE_OFFSET);

      translate([0, 0, ROD_SIDE_LENGTH + BALL_SIDE_LENGTH - BALL_DIA/2])
      sphere(d = BALL_DIA + 2 * WALL_THICKNESS);
    }
  }

  #cylinder(d = ROD_DIA, h = ROD_DEPTH);

  #translate([SPRING_HOLE_OFFSET, 0, 0])
  cylinder(d = SPRING_HOLE_DIA, h = SPRING_HOLE_THICKNESS);

  #translate([0, 0, ROD_SIDE_LENGTH + BALL_SIDE_LENGTH - BALL_DIA/2])
  sphere(d = BALL_DIA);

  #hull() {
    translate([BALL_SIDE_OFFSET, 0, ROD_SIDE_LENGTH + BALL_SIDE_LENGTH - BALL_DIA])
    rotate([90, 0, 0])
    cylinder(d = BALL_DIA * 2, h = BALL_DIA * 2, center = true);

    translate([BALL_SIDE_OFFSET, 0, ROD_SIDE_LENGTH + BALL_SIDE_LENGTH])
    rotate([90, 0, 0])
    cylinder(d = BALL_DIA * 2, h = BALL_DIA * 2, center = true);
  }
}
