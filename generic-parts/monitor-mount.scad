SEGMENT_LENGTH_1 = 80;
SEGMENT_LENGTH_2 = 50;
SEGMENT_WIDTH = 40;
SEGMENT_DIA = 8;
SEGMENT_HOLE_DIA = 6;

FOOT_LENGTH = SEGMENT_WIDTH/2;
FOOT_WIDTH = SEGMENT_WIDTH;
FOOT_THICKNESS = 2;

MOUNT_LENGTH = 60 - SEGMENT_DIA;
MOUNT_WIDTH = SEGMENT_WIDTH;
MOUNT_THICKNESS = 3;
MOUNT_HOLE_DIA = 8;
MOUNT_HOLE_OFFSET_X = 10;
MOUNT_HOLE_OFFSET_Y = 12;

MOUNT_NOTCH_OFFSET_X = -MOUNT_WIDTH + 8;
MOUNT_NOTCH_OFFSET_Y = MOUNT_LENGTH - 30;

$fn = 30;


module bar(length, width, dia) {
  hull() {
    for(i = [1, -1]) {
      translate([i * (length - dia)/2, 0, 0])
      cylinder(d = dia, h = width);
    }
  }  
}

module rounded_rect(length, width, height, dia) {
  hull() {
    for(i = [1, -1]) {
      translate([0, i * (width - dia)/2, 0])
      bar(length, height, dia);
    }
  }
}

module segment(length) {
  difference() {
    union() {
      bar(length, SEGMENT_WIDTH/2, SEGMENT_DIA);
      translate([0, 0, SEGMENT_WIDTH/2])
      bar(length - 2*SEGMENT_DIA, SEGMENT_WIDTH/2, SEGMENT_DIA);
    }
    for(i = [1, -1]) {
      translate([i * (length - SEGMENT_DIA)/2, 0, 0])
      cylinder(d = SEGMENT_HOLE_DIA, h = SEGMENT_WIDTH/2);
    }
    translate([0, 0, SEGMENT_WIDTH/2])
    rotate([90, 0, 0])
    cylinder(d = SEGMENT_HOLE_DIA, h = SEGMENT_DIA, center = true);
  }
}

module connector() {
  difference() {
    l = 2 * SEGMENT_DIA + FOOT_THICKNESS;
    bar(l, SEGMENT_WIDTH/2, SEGMENT_DIA);

    for(i = [1, -1]) {
      translate([i * (l - SEGMENT_DIA)/2, 0, 0])
      cylinder(d = SEGMENT_HOLE_DIA, h = SEGMENT_WIDTH/2);
    }
  }
}

module foot() {
  difference() {
    l = SEGMENT_DIA + FOOT_THICKNESS;
    union() {
      translate([0, 0, -SEGMENT_WIDTH/2])
      bar(l, SEGMENT_WIDTH/2, SEGMENT_DIA);
      translate([l/2 - FOOT_THICKNESS, FOOT_LENGTH/2 - SEGMENT_DIA/2, 0])
      rotate([0, 90, 0])
      rotate([0, 0, 90])
      rounded_rect(FOOT_LENGTH, FOOT_WIDTH, FOOT_THICKNESS, SEGMENT_DIA);
    }
    
    translate([-(l - SEGMENT_DIA)/2, 0, -SEGMENT_WIDTH/2])
    cylinder(d = SEGMENT_HOLE_DIA, h = SEGMENT_WIDTH/2);
  }
}

module other_foot() {
  difference() {
    union() {
      l = 2 * SEGMENT_DIA + FOOT_THICKNESS;
      connector();
      translate([l/2, -SEGMENT_DIA/2, 0])
      rotate([90, 0, 0])
      rounded_rect(FOOT_LENGTH, FOOT_WIDTH, FOOT_THICKNESS, SEGMENT_DIA);
    }
  }
}

module mount() {
  difference() {
    l = SEGMENT_DIA + MOUNT_THICKNESS;
    union() {
      bar(l, SEGMENT_WIDTH/2, SEGMENT_DIA);
      translate([(MOUNT_LENGTH + l)/2 - MOUNT_THICKNESS, -(SEGMENT_DIA/2 - MOUNT_THICKNESS), 0])
      rotate([90, 0, 0])
      rounded_rect(MOUNT_LENGTH, MOUNT_WIDTH, MOUNT_THICKNESS, SEGMENT_DIA);
    }
    
    translate([-(l - SEGMENT_DIA)/2, 0, 0])
    cylinder(d = SEGMENT_HOLE_DIA, h = SEGMENT_WIDTH/2);
    
    translate([(MOUNT_LENGTH + l)/2 - MOUNT_THICKNESS + MOUNT_HOLE_OFFSET_Y, -(SEGMENT_DIA/2 - MOUNT_THICKNESS), -MOUNT_HOLE_OFFSET_X])
    rotate([90, 0, 0])
    cylinder(d = MOUNT_HOLE_DIA, h = MOUNT_THICKNESS);

    translate([(MOUNT_LENGTH + l)/2 - MOUNT_THICKNESS + MOUNT_NOTCH_OFFSET_Y, -(SEGMENT_DIA/2 - MOUNT_THICKNESS), -MOUNT_NOTCH_OFFSET_X])
    rotate([90, 0, 0])
    rounded_rect(MOUNT_LENGTH, MOUNT_WIDTH, MOUNT_THICKNESS, SEGMENT_DIA);
  }
}

//segment(SEGMENT_LENGTH_1);
//segment(SEGMENT_LENGTH_2);
//connector();
//foot();
//other_foot();
mount();