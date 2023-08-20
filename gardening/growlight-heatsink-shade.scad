HEATSINK_OUTER_DIA = 33;
HEATSINK_INNER_DIA = 17.5;
HEATSINK_HOLE_SPACING = 19;

LED_MOUNT_DIA = 23;
LED_MOUNT_HEIGHT = 2.5;
LED_DIA = 11;
LED_HEIGHT = 6;
LED_HOLE_DIA = 4;

MOUNT_HOLE_DIA = 2;
MOUNT_HOLE_HEAD_DIA = 5;

HEIGHT = 8;

$fn = 50;

module power_led() {
    difference() {
        union() {
            cylinder(d = LED_MOUNT_DIA, h = LED_MOUNT_HEIGHT, $fn = 6);
            cylinder(d = LED_DIA, h = LED_HEIGHT + LED_MOUNT_HEIGHT);
        }
        for(i = [0: 2]) {
            rotate([0, 0, i * 360/3])
            translate([-HEATSINK_HOLE_SPACING/2, 0, 0])
            cylinder(d = LED_HOLE_DIA, h = LED_MOUNT_HEIGHT);
        }
    }
}

module body() {
    difference() {
        cylinder(d = HEATSINK_OUTER_DIA, h = HEIGHT);
        translate([0, 0, LED_MOUNT_HEIGHT + 0.5])
        cylinder(d1 = LED_DIA, d2 = HEATSINK_OUTER_DIA, h = HEIGHT - LED_MOUNT_HEIGHT);

        for(i = [0: 2]) {
            rotate([0, 0, i * 360/3])
            translate([-HEATSINK_HOLE_SPACING/2, 0, 0]) {
                cylinder(d = MOUNT_HOLE_DIA, h = HEIGHT);
                translate([0, 0, LED_MOUNT_HEIGHT + 0.5])
                cylinder(d = MOUNT_HOLE_HEAD_DIA, h = HEIGHT);
            }
        }
    }
}

module shade() {
    difference() {
        body();
        #power_led();
    }
}


shade();
