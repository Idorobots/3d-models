WIDTH = 105.2;
LENGTH = 98.2;
HEIGHT = 9;
THICKNESS = 2;

BAR_WIDTH = 5;
BAR_HEIGHT = 1.5;

difference() {
    t2 = 2 * THICKNESS;
    cube(size = [WIDTH, LENGTH, HEIGHT]);
    translate([THICKNESS, THICKNESS, 0])
    difference() {
        cube(size = [WIDTH - t2, LENGTH - t2, HEIGHT]);
        translate([WIDTH/2 - BAR_WIDTH/2 - THICKNESS, 0, 0])
        cube(size = [BAR_WIDTH, LENGTH, BAR_HEIGHT]);

        translate([0, LENGTH/2 - BAR_WIDTH/2 - THICKNESS, 0])
        cube(size = [WIDTH, BAR_WIDTH, BAR_HEIGHT]);
    }
}
