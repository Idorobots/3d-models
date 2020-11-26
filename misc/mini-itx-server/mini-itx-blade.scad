MINI_ITX_BOARD_WIDTH = 170;
MINI_ITX_BOARD_LENGTH = 170;

// Actual board dimensions, as these tend to be nonstandard.
BOARD_WIDTH = 170;
BOARD_LENGTH = 180;
BOARD_THICKNESS = 1.6;

MOUNT_HOLE_DIA = 4;
MOUNT_HOLE_SPACING = [
  [6.35, 165.1],
  [6.35, 33.02],
  [163.83, 10.16],
  [163.83, 165.1]
];

SUPPORT_THICKNESS = 3;
SUPPORT_CORNER_DIA = 2 * MOUNT_HOLE_DIA;

RAIL_THICKNESS = 2;
RAIL_CORNER_DIA = SUPPORT_CORNER_DIA;
FRONT_RAIL_EXTENSION = 10; // Extra 5 mm to facilitate connectors.
FRONT_RAIL_TAB_WIDTH = 28;
BACK_RAIL_EXTENSION = 5;
LEFT_RAIL_EXTENSION = 5;
RIGHT_RAIL_EXTENSION = 5;

INDEX = true;
INDEX_DIA = 2;
INDEX_SPACING = 145;
INDEX_OFFSET_Y = BOARD_LENGTH - MINI_ITX_BOARD_WIDTH; // Ensures that non-standard boards fit the same way as standard ones.
INDEX_OFFSET_X = BOARD_WIDTH - MINI_ITX_BOARD_LENGTH;

LEVER = true;
LEVER_MOUNT_DIA = 3.5;
LEVER_OFFSET_X = INDEX_OFFSET_X;
LEVER_OFFSET_Y = INDEX_OFFSET_Y;

$fn = 30;

module mounting_holes() {
  #for(i = [0:len(MOUNT_HOLE_SPACING)-1]) {
    translate([MOUNT_HOLE_SPACING[i][0], MOUNT_HOLE_SPACING[i][1], 0])
    cylinder(d = MOUNT_HOLE_DIA, h = 10);
  }
}

module board() {
  difference() {
    cube(size = [BOARD_WIDTH, BOARD_LENGTH, BOARD_THICKNESS]);
    mounting_holes();
  }
}

module pairwise_hull() {
  for(i = [0:$children-1]) {
    for(j = [0:$children-1]) {
      hull() {
        children(i);
        children(j);
      }
    }
  }
}

module board_support() {
  difference() {
    pairwise_hull() {
      // Needs lazy union on module().
      /*for(i = [0:len(MOUNT_HOLE_SPACING)-1]) {
        translate([MOUNT_HOLE_SPACING[i][0], MOUNT_HOLE_SPACING[i][1], 0])
        cylinder(d = MOUNT_HOLE_DIA * 2, h = BOARD_THICKNESS);
      }*/

      translate([MOUNT_HOLE_SPACING[0][0], MOUNT_HOLE_SPACING[0][1], 0])
      cylinder(d = SUPPORT_CORNER_DIA, h = SUPPORT_THICKNESS);
      
      translate([MOUNT_HOLE_SPACING[1][0], MOUNT_HOLE_SPACING[1][1], 0])
      cylinder(d = SUPPORT_CORNER_DIA, h = SUPPORT_THICKNESS);
      
      translate([MOUNT_HOLE_SPACING[2][0], MOUNT_HOLE_SPACING[2][1], 0])
      cylinder(d = SUPPORT_CORNER_DIA, h = SUPPORT_THICKNESS);
      
      translate([MOUNT_HOLE_SPACING[3][0], MOUNT_HOLE_SPACING[3][1], 0])
      cylinder(d = SUPPORT_CORNER_DIA, h = SUPPORT_THICKNESS);
    }
    mounting_holes();
  }
}

module index() {
  #for(i = [-1, 1]) {
    translate([i * INDEX_SPACING/2, 0, 0])
    cylinder(d = INDEX_DIA, h = 10);
  }
}

module lever() {
  #cylinder(d = LEVER_MOUNT_DIA, h = 10);
}

module front_rail() {
  difference() {
    union() {
      difference() {
        hull() {
          translate([MOUNT_HOLE_SPACING[1][0], MOUNT_HOLE_SPACING[1][1], 0])
          cylinder(d = RAIL_CORNER_DIA, h = RAIL_THICKNESS);
            
          translate([MOUNT_HOLE_SPACING[2][0], MOUNT_HOLE_SPACING[2][1], 0])
          cylinder(d = RAIL_CORNER_DIA, h = RAIL_THICKNESS);

          translate([MOUNT_HOLE_SPACING[1][0], RAIL_CORNER_DIA/2, 0])
          cylinder(d = RAIL_CORNER_DIA, h = RAIL_THICKNESS);
            
          translate([MOUNT_HOLE_SPACING[2][0], RAIL_CORNER_DIA/2, 0])
          cylinder(d = RAIL_CORNER_DIA, h = RAIL_THICKNESS);
        }
        hull() {
          translate([MOUNT_HOLE_SPACING[1][0] + FRONT_RAIL_TAB_WIDTH, 0, 0])
          cylinder(d = RAIL_CORNER_DIA, h = RAIL_THICKNESS);

          translate([MOUNT_HOLE_SPACING[2][0] - FRONT_RAIL_TAB_WIDTH, 0, 0])
          cylinder(d = RAIL_CORNER_DIA, h = RAIL_THICKNESS);

        }
      }
      
      hull() {
        translate([MOUNT_HOLE_SPACING[1][0], RAIL_CORNER_DIA, 0])
        cylinder(d = RAIL_CORNER_DIA, h = RAIL_THICKNESS);
          
        translate([MOUNT_HOLE_SPACING[1][0] + FRONT_RAIL_TAB_WIDTH - RAIL_CORNER_DIA, RAIL_CORNER_DIA, 0])
        cylinder(d = RAIL_CORNER_DIA, h = RAIL_THICKNESS);

        translate([MOUNT_HOLE_SPACING[1][0], -FRONT_RAIL_EXTENSION + RAIL_CORNER_DIA/2, 0])
        cylinder(d = RAIL_CORNER_DIA, h = RAIL_THICKNESS);
          
        translate([MOUNT_HOLE_SPACING[1][0] + FRONT_RAIL_TAB_WIDTH - RAIL_CORNER_DIA, -FRONT_RAIL_EXTENSION + RAIL_CORNER_DIA/2, 0])
        cylinder(d = RAIL_CORNER_DIA, h = RAIL_THICKNESS);
      }

      hull() {
        translate([MOUNT_HOLE_SPACING[2][0], RAIL_CORNER_DIA, 0])
        cylinder(d = RAIL_CORNER_DIA, h = RAIL_THICKNESS);
          
        translate([MOUNT_HOLE_SPACING[2][0] - FRONT_RAIL_TAB_WIDTH + RAIL_CORNER_DIA, RAIL_CORNER_DIA, 0])
        cylinder(d = RAIL_CORNER_DIA, h = RAIL_THICKNESS);

        translate([MOUNT_HOLE_SPACING[2][0], -FRONT_RAIL_EXTENSION + RAIL_CORNER_DIA/2, 0])
        cylinder(d = RAIL_CORNER_DIA, h = RAIL_THICKNESS);
          
        translate([MOUNT_HOLE_SPACING[2][0] - FRONT_RAIL_TAB_WIDTH + RAIL_CORNER_DIA, -FRONT_RAIL_EXTENSION + RAIL_CORNER_DIA/2, 0])
        cylinder(d = RAIL_CORNER_DIA, h = RAIL_THICKNESS);
      }
    }

    mounting_holes();
    
    if(INDEX) {
      translate([(BOARD_WIDTH - INDEX_OFFSET_X)/2, - FRONT_RAIL_EXTENSION, 0])
      index();
    }
    
    if(LEVER) {
      translate([MOUNT_HOLE_SPACING[1][0], -FRONT_RAIL_EXTENSION + RAIL_CORNER_DIA/2, 0])
      lever();

      translate([MOUNT_HOLE_SPACING[2][0], -FRONT_RAIL_EXTENSION + RAIL_CORNER_DIA/2, 0])
      lever();
    }
  }
}

module back_rail() {
  difference() {
    hull() {
      translate([MOUNT_HOLE_SPACING[0][0], MOUNT_HOLE_SPACING[0][1], 0])
      cylinder(d = RAIL_CORNER_DIA, h = RAIL_THICKNESS);
        
      translate([MOUNT_HOLE_SPACING[3][0], MOUNT_HOLE_SPACING[3][1], 0])
      cylinder(d = RAIL_CORNER_DIA, h = RAIL_THICKNESS);

      translate([MOUNT_HOLE_SPACING[0][0], BOARD_LENGTH + BACK_RAIL_EXTENSION - RAIL_CORNER_DIA/2, 0])
      cylinder(d = RAIL_CORNER_DIA, h = RAIL_THICKNESS);
        
      translate([MOUNT_HOLE_SPACING[3][0], BOARD_LENGTH + BACK_RAIL_EXTENSION - RAIL_CORNER_DIA/2, 0])
      cylinder(d = RAIL_CORNER_DIA, h = RAIL_THICKNESS);
    }

    mounting_holes();
    
    if(INDEX) {
      translate([(BOARD_WIDTH - INDEX_OFFSET_X)/2, BOARD_LENGTH + BACK_RAIL_EXTENSION, 0])
      index();
    }
    
    if(LEVER) {
      translate([MOUNT_HOLE_SPACING[0][0], BOARD_LENGTH + BACK_RAIL_EXTENSION - RAIL_CORNER_DIA/2, 0])
      lever();

      translate([MOUNT_HOLE_SPACING[3][0], BOARD_LENGTH + BACK_RAIL_EXTENSION - RAIL_CORNER_DIA/2, 0])
      lever();
    }
  }
}

module left_rail() {
  difference() {
    hull() {
      translate([MOUNT_HOLE_SPACING[0][0], MOUNT_HOLE_SPACING[0][1], 0])
      cylinder(d = RAIL_CORNER_DIA, h = RAIL_THICKNESS);
        
      translate([MOUNT_HOLE_SPACING[1][0], MOUNT_HOLE_SPACING[1][1], 0])
      cylinder(d = RAIL_CORNER_DIA, h = RAIL_THICKNESS);

      translate([-LEFT_RAIL_EXTENSION + RAIL_CORNER_DIA/2, BOARD_LENGTH - RAIL_CORNER_DIA/2, 0])
      cylinder(d = RAIL_CORNER_DIA, h = RAIL_THICKNESS);
        
      translate([-LEFT_RAIL_EXTENSION + RAIL_CORNER_DIA/2, RAIL_CORNER_DIA/2 + LEVER_OFFSET_Y, 0])
      cylinder(d = RAIL_CORNER_DIA, h = RAIL_THICKNESS);
    }

    mounting_holes();
    
    if(INDEX) {
      translate([-LEFT_RAIL_EXTENSION, (BOARD_LENGTH + INDEX_OFFSET_Y)/2, 0])
      rotate(90, [0, 0, 1])
      index();
    }
    
    if(LEVER) {
      translate([-LEFT_RAIL_EXTENSION + RAIL_CORNER_DIA/2, BOARD_LENGTH - RAIL_CORNER_DIA/2, 0])
      lever();

      translate([-LEFT_RAIL_EXTENSION + RAIL_CORNER_DIA/2, RAIL_CORNER_DIA/2 + LEVER_OFFSET_Y, 0])
      lever();
    }
  }
}

module right_rail() {
  difference() {
    hull() {
      translate([MOUNT_HOLE_SPACING[2][0], MOUNT_HOLE_SPACING[2][1], 0])
      cylinder(d = RAIL_CORNER_DIA, h = RAIL_THICKNESS);
        
      translate([MOUNT_HOLE_SPACING[3][0], MOUNT_HOLE_SPACING[3][1], 0])
      cylinder(d = RAIL_CORNER_DIA, h = RAIL_THICKNESS);

      translate([BOARD_WIDTH + RIGHT_RAIL_EXTENSION - RAIL_CORNER_DIA/2, BOARD_LENGTH - RAIL_CORNER_DIA/2, 0])
      cylinder(d = RAIL_CORNER_DIA, h = RAIL_THICKNESS);
        
      translate([BOARD_WIDTH + RIGHT_RAIL_EXTENSION - RAIL_CORNER_DIA/2, RAIL_CORNER_DIA/2 + LEVER_OFFSET_Y, 0])
      cylinder(d = RAIL_CORNER_DIA, h = RAIL_THICKNESS);
    }

    mounting_holes();
    
    if(INDEX) {
      translate([BOARD_WIDTH + RIGHT_RAIL_EXTENSION, (BOARD_LENGTH + INDEX_OFFSET_Y)/2, 0])
      rotate(90, [0, 0, 1])
      index();
    }
    
    if(LEVER) {
      translate([BOARD_WIDTH + RIGHT_RAIL_EXTENSION - RAIL_CORNER_DIA/2, BOARD_LENGTH - RAIL_CORNER_DIA/2, 0])
      lever();

      translate([BOARD_WIDTH + RIGHT_RAIL_EXTENSION - RAIL_CORNER_DIA/2, RAIL_CORNER_DIA/2 + LEVER_OFFSET_Y, 0])
      lever();
    }
  }
}

!union() {
  translate([0, 0, -RAIL_THICKNESS])
  front_rail();

  translate([0, 0, -RAIL_THICKNESS])
  back_rail();

  translate([0, 0, -2 * RAIL_THICKNESS])
  left_rail();
  
  translate([0, 0, -2 * RAIL_THICKNESS])
  right_rail();

  color("green")
  board_support();
  
  color("blue")
  translate([0, 0, SUPPORT_THICKNESS + 2])
  board();
}

board_support();
front_rail();
back_rail();
left_rail();
right_rail();