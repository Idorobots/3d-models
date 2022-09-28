WIDTH = 120;
LENGTH = WIDTH;
THICKNESS = 1.5;
HANDLE_LENGTH = 80;
HANDLE_WIDTH = 20;
CORNER_DIA = 20;

NUMBER = "👏";
NUMBER_SIZE = min(LENGTH, WIDTH) * 0.5;
NUMBER_FONT = "Segoe UI Emoji";
NUMBER_OFFSET = 0;

$fn = 100;

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

difference() {
    union() {
        rounded_rect(WIDTH, LENGTH, THICKNESS, CORNER_DIA);
        translate([0, -LENGTH/2 -HANDLE_LENGTH/2 +CORNER_DIA/2, 0])
        rounded_rect(HANDLE_WIDTH, HANDLE_LENGTH, THICKNESS, CORNER_DIA);
    }

    translate([0, NUMBER_OFFSET, THICKNESS/2])
    linear_extrude(THICKNESS/2)
    text(NUMBER, font=NUMBER_FONT, halign="center", valign="center", size = NUMBER_SIZE);
}
