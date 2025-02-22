BASE_THICKNESS = 2;
SHAFT_LENGTH = 5;
SHAFT_DIA = 7;

PLATFORM_MOUNT_DIA = 50;//80;
PLATFORM_MOUNT_HOLE_DIA = 3;
PLATFORM_MOUNT_SPACING = 20;

COOLER_MOUNT_DIA = 60;
COOLER_MOUNT_HOLE_DIA = 3;

$fn = 30;

difference() {
    h = BASE_THICKNESS + SHAFT_LENGTH;
    union() {
        hull() {
            translate([-COOLER_MOUNT_DIA/2, 0, 0])
            cylinder(d = SHAFT_DIA, h = BASE_THICKNESS);
            translate([-PLATFORM_MOUNT_DIA/2, -PLATFORM_MOUNT_SPACING/2, 0])
            cylinder(d = SHAFT_DIA, h = BASE_THICKNESS);
            translate([-PLATFORM_MOUNT_DIA/2, PLATFORM_MOUNT_SPACING/2, 0])
            cylinder(d = SHAFT_DIA, h = BASE_THICKNESS);
        }
        translate([-COOLER_MOUNT_DIA/2, 0, 0])
        cylinder(d = SHAFT_DIA, h = h);
    }

    #translate([-COOLER_MOUNT_DIA/2, 0, 0])
    cylinder(d = COOLER_MOUNT_HOLE_DIA, h = h);

    #translate([-PLATFORM_MOUNT_DIA/2, -PLATFORM_MOUNT_SPACING/2, 0])
    cylinder(d = PLATFORM_MOUNT_HOLE_DIA, h = h);

    #translate([-PLATFORM_MOUNT_DIA/2, PLATFORM_MOUNT_SPACING/2, 0])
    cylinder(d = PLATFORM_MOUNT_HOLE_DIA, h = h);
}
