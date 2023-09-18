WIDTH = 92;
LENGTH = 92;
HEIGHT = 8;
CORNER_DIA = 20;

$fn = 50;

hull() {
    for(i = [-1, 1]) {
        for(j = [-1, 1]) {
            translate([i * (WIDTH-CORNER_DIA)/2, j * (LENGTH-CORNER_DIA)/2, 0])
            cylinder(d = CORNER_DIA, h = HEIGHT);
        }
    }
}
