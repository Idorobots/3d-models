HOLE_DIA = 3;
HOLE_SIZE = 5;
THICKNESS = 1.5;

CHAIN_DELTA = 1;
CHAIN_SPACING = 8;

FRONT_WIDTH = 8;
FRONT_DIA = HOLE_DIA + 2 * THICKNESS;
BACK_WIDTH = 2;
BACK_DIA = FRONT_DIA + CHAIN_DELTA;

$fn = 50;

module chain_link_base() {
  union() {
    hull() {
      translate([-(FRONT_DIA + CHAIN_SPACING)/2, 0, 0])
      cylinder(d = FRONT_DIA, h = FRONT_WIDTH, center = true);      

      translate([(BACK_DIA + CHAIN_SPACING)/2, 0, 0])
      cylinder(d = FRONT_DIA, h = FRONT_WIDTH, center = true); 
    }
    hull() {
      translate([(BACK_DIA + CHAIN_SPACING)/2, 0, 0])
      cylinder(d = BACK_DIA, h = FRONT_WIDTH + 2 * BACK_WIDTH + CHAIN_DELTA, center = true);

      translate([-(BACK_DIA + CHAIN_SPACING)/2, 0, 0])
      cylinder(d = BACK_DIA, h = FRONT_WIDTH + 2 * BACK_WIDTH + CHAIN_DELTA, center = true);
    }
  }
}

module holes() {
  #union() {
    translate([-(FRONT_DIA + CHAIN_SPACING + CHAIN_DELTA)/2, 0, 0])
    cylinder(d = HOLE_DIA, h = FRONT_WIDTH + 2 * BACK_WIDTH + 2 * CHAIN_DELTA, center = true);

    translate([(BACK_DIA + CHAIN_SPACING + CHAIN_DELTA)/2, 0, 0])
    cylinder(d = HOLE_DIA, h = FRONT_WIDTH + 2 * BACK_WIDTH + 2 * CHAIN_DELTA, center = true);
  
    difference() {
      cube(size = [HOLE_SIZE + HOLE_DIA, BACK_DIA, HOLE_SIZE + HOLE_DIA], center = true);

      for(i = [0:3]) {
        rotate([0, i * 360/4, 0])
        translate([-(HOLE_SIZE + HOLE_DIA)/2, -(BACK_DIA - HOLE_DIA)/2, 0])
        hull() {
          cylinder(d = HOLE_DIA, h = HOLE_SIZE + HOLE_DIA, center = true);
          translate([0, HOLE_SIZE, 0])
          cylinder(d = HOLE_DIA, h = HOLE_SIZE + HOLE_DIA, center = true);
        }
      }
    }
  }
}

module chain_link() {
  difference() {
    intersection() {
      hull() {
        chain_link_base();
        translate([0, BACK_DIA, 0])
        chain_link_base();
      }
      cube(size = [FRONT_DIA + BACK_DIA + 2 * CHAIN_SPACING, BACK_DIA, FRONT_WIDTH + 2 * BACK_WIDTH + CHAIN_DELTA], center = true);
    }

    #translate([(BACK_DIA + CHAIN_SPACING)/2, 0, 0])
    hull() {
      translate([0, BACK_DIA, 0])
      cylinder(d = BACK_DIA, h = FRONT_WIDTH + CHAIN_DELTA, center = true);
      translate([0, -BACK_DIA, 0])
      cylinder(d = BACK_DIA, h = FRONT_WIDTH + CHAIN_DELTA, center = true);
      translate([BACK_DIA, 0, 0])
      cylinder(d = BACK_DIA, h = FRONT_WIDTH + CHAIN_DELTA, center = true);
    }
    
    #translate([-(FRONT_DIA + CHAIN_SPACING + CHAIN_DELTA)/2, 0, (FRONT_WIDTH + BACK_WIDTH + CHAIN_DELTA)/2])
    hull() {
      translate([0, BACK_DIA, 0])
      cylinder(d = BACK_DIA, h = BACK_WIDTH + CHAIN_DELTA, center = true);
      translate([0, -BACK_DIA, 0])
      cylinder(d = BACK_DIA, h = BACK_WIDTH + CHAIN_DELTA, center = true);  
      translate([-BACK_DIA, 0, 0])
      cylinder(d = BACK_DIA, h = BACK_WIDTH + CHAIN_DELTA, center = true);  
    }
    
    #translate([-(FRONT_DIA + CHAIN_SPACING + CHAIN_DELTA)/2, 0, -(FRONT_WIDTH + BACK_WIDTH + CHAIN_DELTA)/2])
    hull() {
      translate([0, BACK_DIA, 0])
      cylinder(d = BACK_DIA, h = BACK_WIDTH + CHAIN_DELTA, center = true);
      translate([0, -BACK_DIA, 0])
      cylinder(d = BACK_DIA, h = BACK_WIDTH + CHAIN_DELTA, center = true);
      translate([-BACK_DIA, 0, 0])
      cylinder(d = BACK_DIA, h = BACK_WIDTH + CHAIN_DELTA, center = true);  
    }
    
    holes();
  }
}

!chain_link();
translate([(BACK_DIA + CHAIN_SPACING + CHAIN_DELTA/2), 0, 0])
chain_link();