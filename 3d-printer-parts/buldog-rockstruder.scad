TUNER_BASE_THICKNESS = 3;
TUNER_GEAR_THICKNESS = 8;
TUNER_WIDTH = 18.5;
TUNER_LENGTH = 28;
TUNER_MOUNTING_HOLES_OFFSET = 9;
TUNER_MOUNTING_HOLES_SPACING = 22;
TUNER_MOUNTING_HOLES_DIA = 2;

WORM_AXLE_OFFSET_Z = 5;
WORM_AXLE_OFFSET_Y = 8;
WORM_AXLE_LENGTH = 35;
WORM_AXLE_DIA = 10;

HOB_GEAR_DIA = 15;
HOB_GEAR_LENGTH = 15;
HOB_AXLE_OFFSET = TUNER_LENGTH/2 - 10;
HOB_AXLE_BEARING_DIA = 11.5;
HOB_AXLE_BEARING_THICKNESS = 5;
HOB_AXLE_LENGTH = HOB_AXLE_BEARING_THICKNESS + HOB_GEAR_LENGTH + TUNER_GEAR_THICKNESS;
HOB_OFFSET_Y = 5;
HOB_OFFSET_X = 11.5;

BULDOG = false;

BULDOG_INNER_DIA = 35.5;
BULDOG_INNER_THICKNESS = 4;
BULDOG_MOUNT_HOLE_SPACING = 32;
BULDOG_MOUNT_HOLE_DIA = 3;

NEMA_WIDTH = 42;
NEMA_THICKNESS = 3;
NEMA_CORNER_DIA = 5;
NEMA_MOUNT_HOLE_SPACING = 31;
NEMA_MOUNT_HOLE_DIA = 3;

CABLE = true;

CABLE_MOUNT_OUTER_DIA = 18;
CABLE_MOUNT_INNER_DIA = 13;
CABLE_MOUNT_LENGTH = 12;

$fn = 50;

module tuner_neg() {
    translate([0, 0, -TUNER_GEAR_THICKNESS])
    union() {
        translate([0, HOB_AXLE_OFFSET/2, (TUNER_GEAR_THICKNESS-TUNER_BASE_THICKNESS) + TUNER_BASE_THICKNESS/2])
        cube(size = [TUNER_WIDTH, TUNER_LENGTH, TUNER_BASE_THICKNESS], center = true);
        
        cylinder(d = HOB_AXLE_BEARING_DIA, h = HOB_AXLE_LENGTH);

        cylinder(d = HOB_GEAR_DIA, h = TUNER_GEAR_THICKNESS + HOB_GEAR_LENGTH);
        
        translate([0, -TUNER_MOUNTING_HOLES_OFFSET, -HOB_AXLE_LENGTH/2])
        cylinder(d = TUNER_MOUNTING_HOLES_DIA, h = HOB_AXLE_LENGTH*2);

        translate([0, -TUNER_MOUNTING_HOLES_OFFSET + TUNER_MOUNTING_HOLES_SPACING, -HOB_AXLE_LENGTH/2])
        cylinder(d = TUNER_MOUNTING_HOLES_DIA, h = HOB_AXLE_LENGTH*2);
        
        translate([TUNER_WIDTH/2, WORM_AXLE_OFFSET_Y, TUNER_GEAR_THICKNESS-WORM_AXLE_OFFSET_Z])
        rotate([0, -90, 0])
        cylinder(d = WORM_AXLE_DIA, h = WORM_AXLE_LENGTH);
    }
}

module mount_holes(width, length, thickness, dia) {
   for(i = [-1, 1]) {
     for(j = [-1, 1]) {
      translate([i * width/2, j * length/2, 0])
      cylinder(d = dia, h = thickness);
     }
  }
}

module buldog_mount_holes() {
  mount_holes(BULDOG_MOUNT_HOLE_SPACING, 0, BULDOG_INNER_THICKNESS, BULDOG_MOUNT_HOLE_DIA);
}

module buldog_body() {
  cylinder(d = BULDOG_INNER_DIA, h = BULDOG_INNER_THICKNESS);
}

module nema_body() {
  hull() {
    w = NEMA_WIDTH - NEMA_MOUNT_HOLE_DIA;
    mount_holes(w, w, NEMA_THICKNESS, NEMA_CORNER_DIA);
  }
}

module nema_mount_holes() {
  mount_holes(NEMA_MOUNT_HOLE_SPACING, NEMA_MOUNT_HOLE_SPACING, NEMA_THICKNESS, NEMA_MOUNT_HOLE_DIA);
}

module cable_mount() {
  difference() {
    union() {
      translate([0, 0, -NEMA_THICKNESS])
      hull() {
        nema_body();
        translate([-NEMA_WIDTH/2 - CABLE_MOUNT_LENGTH + NEMA_THICKNESS/2, WORM_AXLE_OFFSET_Y, NEMA_THICKNESS/2])
        cube(size = [NEMA_THICKNESS, CABLE_MOUNT_OUTER_DIA - NEMA_THICKNESS, NEMA_THICKNESS], center = true);
      }
      
      translate([-NEMA_WIDTH/2, WORM_AXLE_OFFSET_Y, -WORM_AXLE_OFFSET_Z])
      rotate([0, -90, 0])
      cylinder(d = CABLE_MOUNT_OUTER_DIA, h = CABLE_MOUNT_LENGTH);
    }

    #translate([0, 0, -NEMA_THICKNESS]) {
      nema_mount_holes();
      if(BULDOG) {
        buldog_mount_holes();
      }
    }
    
    #nema_body();
    
    #tuner_neg();

    #translate([0, WORM_AXLE_OFFSET_Y, -WORM_AXLE_OFFSET_Z])
    rotate([0, -90, 0])
    cylinder(d = CABLE_MOUNT_INNER_DIA, h = CABLE_MOUNT_LENGTH + NEMA_WIDTH/2);
  }
}

module mount_plate() {
  difference() {
    if(BULDOG) {
      buldog_body();
    } else {
      nema_body();
    }
    #tuner_neg();
    if(BULDOG) {
      #buldog_mount_holes();      
    } else {
      #nema_mount_holes();      
    }
  }
}

mount_plate();

if(CABLE) {
  cable_mount();
}
