DIAMETER = 30;
HEIGHT = 10;
INSET_DIAMETER = 19;
INSET_HEIGHT = 4;

$fn = 50;

difference() {
    intersection() {
        cylinder(
            r1 = DIAMETER/2,
            r2 = DIAMETER/2,
            h = HEIGHT
        );

        scale([1, 1, HEIGHT/(DIAMETER/2)])
            sphere(
                r = DIAMETER/2
            );
    }

    intersection() {
        cylinder(
            r1 = INSET_DIAMETER/2,
            r2 = INSET_DIAMETER/2,
            h = INSET_HEIGHT*2,
            center = true
        );

        scale([1, 1, INSET_HEIGHT/(INSET_DIAMETER/2)])
            sphere(
                r = INSET_DIAMETER/2
            );

    }
}
