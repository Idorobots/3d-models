LEDS = 3;

LED_ANGLE = 120;
LED_DIA = 20;
LED_MOUNT_HOLE_SPACING = 18;
LED_MOUNT_HOLE_DIA = 3;
LED_MOUNT_THICKNESS = 2;
LED_MOUNT_DIA = LED_DIA + LED_MOUNT_HOLE_DIA + 2;

S = sin(180 - LED_ANGLE);
C = cos(180 - LED_ANGLE);

CHANNEL_INNER_DIA = 20;
CHANNEL_OUTER_DIA = 25;
CHANNEL_HEIGHT = sin(180 - LED_ANGLE) * LED_MOUNT_DIA;

MOUNT_DIA = 41.5;
MOUNT_HEIGHT = 15;
MOUNT_CUTOUT_WIDTH = 17;
MOUNT_CUTOUT_OFFSET = -10;

$fn = 100;

module body() {
    intersection() {
        hull() {
            cylinder(d = CHANNEL_INNER_DIA, h = CHANNEL_HEIGHT);

            for(i = [0:LEDS-1]) {
                rotate([0, 0, i * 360/LEDS])
                translate([0, -CHANNEL_OUTER_DIA/2 - C * CHANNEL_HEIGHT/2 + LED_MOUNT_THICKNESS, LED_MOUNT_DIA/2 - LED_MOUNT_THICKNESS * S])
                rotate([(180 - LED_ANGLE), 0, 0])
                cylinder(d = LED_MOUNT_DIA, h = LED_MOUNT_THICKNESS, center = true);
            }
        }

        cylinder(d = CHANNEL_OUTER_DIA + 2 * C * CHANNEL_HEIGHT, h = CHANNEL_HEIGHT);
    }
}

module mount_holes() {
    for(i = [0:LEDS-1]) {
        rotate([0, 0, i * 360/LEDS])
        translate([0, -CHANNEL_OUTER_DIA/2 - C * CHANNEL_HEIGHT/2 + LED_MOUNT_THICKNESS, LED_MOUNT_DIA/2 - LED_MOUNT_THICKNESS * S])
        rotate([(180 - LED_ANGLE), 0, 0])
        rotate([0, 0, 45])
        for(j = [-1, 1]) {
            translate([-LED_MOUNT_HOLE_SPACING/2, 0, 0])
            cylinder(d = LED_MOUNT_HOLE_DIA, h = 3 * LED_MOUNT_THICKNESS, center = true);
            translate([LED_MOUNT_HOLE_SPACING/2, 0, 0])
            cylinder(d = LED_MOUNT_HOLE_DIA, h = 3 * LED_MOUNT_THICKNESS, center = true);
        }
    }
}

module channel() {
    cylinder(d = CHANNEL_INNER_DIA, h = CHANNEL_HEIGHT);
}

module mount() {
    difference() {
        cylinder(d = MOUNT_DIA, h = MOUNT_HEIGHT);
        #translate([-MOUNT_CUTOUT_WIDTH/2, MOUNT_CUTOUT_OFFSET, 0])
        cube(size = [MOUNT_CUTOUT_WIDTH, MOUNT_DIA, MOUNT_HEIGHT]);
    }
}

difference() {
    body();
    #mount_holes();
    #channel();
}

!mount();
