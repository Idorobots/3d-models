WIDTH = 16;
LENGTH = 210;
THICKNESS = 1;
CORNER_DIA = 5;


$fn = 30;

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


rounded_rect(WIDTH, LENGTH, THICKNESS, CORNER_DIA);
