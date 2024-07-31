THICKNESS = 2;
CAP_MOUNT_DIA = 26;
CAP_MOUNT_HOLE_DIA = 9;
DISTANCE = 160;
BAR_WIDTH = 14;
THICKNESS_BOTTLE = 3;
BOTTLE_MOUNT_DIA = 58;
BOTTLE_MOUNT_HOLE_DIA = 50;

$fn = 200;

difference() {
    union() {
        cylinder(d = CAP_MOUNT_DIA, h = THICKNESS);
        hull() {
            cylinder(d = BAR_WIDTH, h = THICKNESS);
            translate([0, DISTANCE, 0])
            cylinder(d = BAR_WIDTH, h = THICKNESS_BOTTLE);
        }
        translate([0, DISTANCE, 0])
        cylinder(d = BOTTLE_MOUNT_DIA, h = THICKNESS_BOTTLE);
    }
    cylinder(d = CAP_MOUNT_HOLE_DIA, h = THICKNESS);
    translate([0, DISTANCE, 0])
    cylinder(d = BOTTLE_MOUNT_HOLE_DIA, h = THICKNESS_BOTTLE);
}
