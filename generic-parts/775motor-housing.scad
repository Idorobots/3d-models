THICKNESS = 1;
HOUSING_OUTER_DIA = 35;
HOUSING_INNER_DIA = HOUSING_OUTER_DIA - 2 * THICKNESS;
HOUSING_LENGTH = 80;

DC_PORT_DIA = 8;

SWITCH_WIDTH = 7;
SWITCH_LENGTH = 15;
SWITCH_HEIGHT = 10;
SWITCH_HOLE_SPACING = 19;
SWITCH_HOLE_DIA = 1.5;
SWITCH_OFFSET = 5;

$fn = 50;

module switch() {
  translate([-SWITCH_WIDTH/2, -SWITCH_LENGTH/2, 0])
  cube(size = [SWITCH_WIDTH, SWITCH_LENGTH, SWITCH_HEIGHT]);
  
  translate([0, -SWITCH_HOLE_SPACING/2, 0])
  cylinder(d = SWITCH_HOLE_DIA, h = SWITCH_HEIGHT);

  translate([0, SWITCH_HOLE_SPACING/2, 0])
  cylinder(d = SWITCH_HOLE_DIA, h = SWITCH_HEIGHT);
}

module ball_cylinder(dia, height) {
  union() {
    cylinder(d = dia, h = height - dia/2);
    translate([0, 0, height - dia/2])
    sphere(d = dia);
  }
}

module housing() {
  difference() {
    union() {
      ball_cylinder(HOUSING_OUTER_DIA, HOUSING_LENGTH);
      
      translate([-HOUSING_OUTER_DIA/2, 0, HOUSING_LENGTH - SWITCH_LENGTH/2 - SWITCH_OFFSET])
      rotate([90, 0, 90])
      hull()
      scale([(SWITCH_WIDTH + 2 * THICKNESS)/SWITCH_WIDTH, (SWITCH_LENGTH + 2 * THICKNESS)/SWITCH_LENGTH, HOUSING_OUTER_DIA/2/SWITCH_HEIGHT])
      switch();
      
    }
    
    #ball_cylinder(HOUSING_INNER_DIA, HOUSING_LENGTH - THICKNESS);
    
    #cylinder(d = DC_PORT_DIA, h = HOUSING_LENGTH);
    
    #translate([-HOUSING_OUTER_DIA/2, 0, HOUSING_LENGTH - SWITCH_LENGTH/2 - SWITCH_OFFSET])
    rotate([90, 0, 90])
    switch();
  }
}

housing();