WIDTH = 13.5;
HEIGHT = 50;
LENGTH = 10;
THICKNESS = 1.2;
STUD_DIA = 4;

$fn = 50;

intersection() {
    union() {
        difference() {
            cube(size = [WIDTH + 2 * THICKNESS, LENGTH + 2 * THICKNESS, HEIGHT], center = true);
            cube(size = [WIDTH, LENGTH, HEIGHT], center = true);
        }

        for(i = [-1, 1]) {
            translate([0, i * (LENGTH+THICKNESS)/2, HEIGHT/3])
            sphere(d = STUD_DIA);

            translate([0, i * (LENGTH+THICKNESS)/2, -HEIGHT/3])
            sphere(d = STUD_DIA);
        }
    }

    cube(size = [WIDTH + 2 * THICKNESS, LENGTH + 2 * THICKNESS, HEIGHT], center = true);
}