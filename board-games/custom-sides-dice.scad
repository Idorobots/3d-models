CORNER_DIA = 3;
SIDE = 16;
DEPTH = 1;

IMAGE_SIDE = 256;

SIDES = ["dice/1.png", "dice/2.png", "dice/3.png", "dice/4.png", "dice/5.png", "dice/6.png"];

$fn = 10;

module rounded_cube(width, length, height, corner_dia) {
    hull() {
        for(x = [-1, 1]) {
            for(y = [-1, 1]) {
                for(z = [-1, 1]) {
                    translate([x * (width - corner_dia)/2, y * (length - corner_dia)/2, z * (height - corner_dia)/2])
                    sphere(d = corner_dia);
                }
            }
        }
    }
}

module side(filename) {
    translate([0, 0, DEPTH])
    scale([SIDE/IMAGE_SIDE, SIDE/IMAGE_SIDE, DEPTH/100])
    surface(file = filename, invert = true, center = true);
}

difference() {
    rounded_cube(SIDE, SIDE, SIDE, CORNER_DIA);
    union() {
        for(i = [0:3]) {
            rotate([i * 90, 0, 0])
            translate([0, 0, -SIDE/2])
            side(SIDES[i]);
        }
        for(i = [4:5]) {
            rotate([90, 0, 90 + (i - 4) * 180])
            translate([0, 0, -SIDE/2])
            side(SIDES[i]);
        }
    }
}