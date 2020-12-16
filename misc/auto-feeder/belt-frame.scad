HOLE_DIST = 78;
HOLE_DIA = 5.2;

BEARING_DIA = 10;
CENTER_OFFSET = 8;

FRAME_DIA = 20;
FRAME_THICKNESS = 3;


$fn = 50;

module frame() {
  difference() {
    hull() {
      for(i = [-1, 1]) {
        translate([i * HOLE_DIST/2, 0, 0])
        cylinder(d = FRAME_DIA, h = FRAME_THICKNESS);
      }

      translate([0, CENTER_OFFSET, 0])
      cylinder(d = FRAME_DIA, h = FRAME_THICKNESS);
    }

    translate([0, CENTER_OFFSET, 0])
    cylinder(d = HOLE_DIA, h = FRAME_THICKNESS);
    
    translate([-HOLE_DIST/2, 0, 0])
    cylinder(d = HOLE_DIA, h = FRAME_THICKNESS);

    translate([HOLE_DIST/2, 0, 0])
    cylinder(d = BEARING_DIA, h = FRAME_THICKNESS);
  }
}

frame();