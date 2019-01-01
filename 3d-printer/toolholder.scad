TOOL_SIZES = [2, 2.5, 3, 3.8, 4.8, 6, 9, 12.6];
SPACING = 5;
WALL_THICKNESS = 1.2;
CORNER_DIA = 10;
HEIGHT = 15;
WIDTH = max(TOOL_SIZES) + 2 * WALL_THICKNESS;
LENGTH = (len(TOOL_SIZES) - 1) * SPACING + sum(TOOL_SIZES, len(TOOL_SIZES)) + 2 * WALL_THICKNESS;

$fn = 50;

function sum(list, length, i = 0) =
  i < length - 1 ? list[i] + sum(list, length, i + 1) : list[i];

module rounded_rect(width, length, height, corner_dia) {
    hull() {
        for(i = [-1, 1]) {
            for(j = [-1, 1]) {
                translate([i * (width-corner_dia)/2, j * (length-corner_dia)/2, 0])
                cylinder(d = corner_dia, h = height);
            }
        }
    }
}


difference() {
    rounded_rect(WIDTH, LENGTH, HEIGHT, CORNER_DIA);

    for(i = [0:len(TOOL_SIZES)-1]) {
        translate([0, -LENGTH/2 + i * SPACING + sum(TOOL_SIZES, i) + TOOL_SIZES[i]/2, 0])
        cylinder(d = TOOL_SIZES[i], h = HEIGHT);
    }
}