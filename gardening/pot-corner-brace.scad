LIP_WIDTH = 13.5;
LIP_THICKNESS = 10;
ROD_DIA = 15;
ROD_OFFSET = 15;

THICKNESS = 5;
HEIGHT = 15;
WIDTH = 20;

$fn = 50;

module lip_n_rod() {
    off = ROD_OFFSET/sqrt(2);
    union() {
        translate([off, off, 0])
        cube(size = [LIP_WIDTH, WIDTH + 2 * off + LIP_WIDTH, HEIGHT], center = true);

        rotate([0, 0, 90])
        translate([-off, off, 0])
        cube(size = [LIP_WIDTH, WIDTH + 2 * off + LIP_WIDTH, HEIGHT], center = true);

        hull() {
            cylinder(d = ROD_DIA, h = 2 * HEIGHT, center = true);

            w = LIP_WIDTH + 2 * THICKNESS;
            translate([off, -off, 0])
            cube(size = [w, w, 2 * HEIGHT], center = true);
        }
   }
}

module body() {
    off = ROD_OFFSET/sqrt(2);
    w = LIP_WIDTH + 2 * THICKNESS;
    l = WIDTH + off;
    h = HEIGHT + THICKNESS;
    hull() {
        translate([off, off, THICKNESS/2])
        cube(size = [w, l, h], center = true);

        rotate([0, 0, 90])
        translate([-off, off, THICKNESS/2])
        cube(size = [w, l, h], center = true);
    }
}

difference() {
    body();
    #lip_n_rod();
}
