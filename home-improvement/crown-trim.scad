LENGTH = 200;
WIDTH = 50;
HEIGHT = 30;
DIA = 2 * WIDTH - 5;

ANGLED = false;

$fn = 250;

difference() {
    linear_extrude(LENGTH)
    difference() {
        polygon(points = [
            [-WIDTH, 0],
            [-WIDTH, HEIGHT],
            [0, HEIGHT],
            [0, 0],
        ]);
        scale([1.0, HEIGHT/WIDTH])
        circle(d = DIA);
        polygon(points = [
            [-WIDTH, min(HEIGHT, WIDTH)/2],
            [-WIDTH, HEIGHT],
            [-(WIDTH - min(HEIGHT, WIDTH)/2), HEIGHT]
        ]);
    }

    if(ANGLED) {
        translate([0, 0, LENGTH - WIDTH])
        rotate([0, -45, 0])
        cube(size = [WIDTH, HEIGHT, 2 * LENGTH]);
    }
}