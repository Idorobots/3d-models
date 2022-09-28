SCREW_DIA = 2.8;
STANDOFF_DIA = 6;
STANDOFF_HEIGHT = 6;
SCREW_LENGTH = STANDOFF_HEIGHT;

PEG_DIA = 3;
PEG_LENGTH = 3;
MOUNT_DIA = STANDOFF_DIA;
MOUNT_LENGTH = 10;

ANGLE = 90;
ROUNDED = false;
PEG = false;

$fn = 30;

module tube(outer_dia, inner_dia, outer_height, inner_height) {
    difference() {
        cylinder(d = outer_dia, h = outer_height);
        cylinder(d = inner_dia, h = inner_height);
    }
}

module standoff() {
    tube(STANDOFF_DIA, SCREW_DIA, STANDOFF_HEIGHT, SCREW_LENGTH);
}

module peg(outer_dia, inner_dia, outer_height, inner_height) {
    union() {
        cylinder(d = outer_dia, h = outer_height);
        cylinder(d = inner_dia, h = inner_height);
    }
}

module mount() {
    union() {
        intersection() {
            if(PEG) {
                peg(MOUNT_DIA, PEG_DIA, MOUNT_LENGTH, MOUNT_LENGTH + PEG_LENGTH);
            } else {
                tube(MOUNT_DIA, PEG_DIA, MOUNT_LENGTH, MOUNT_LENGTH);
            }
            if(ROUNDED) {
                translate([0, 0, MOUNT_DIA/2])
                    union() {
                        cylinder(d = MOUNT_DIA, h = MOUNT_LENGTH+PEG_LENGTH);
                        sphere(d = MOUNT_DIA);
                    }
            } else {
                cylinder(d = MOUNT_DIA, h = MOUNT_LENGTH+PEG_LENGTH);
            }
        }
    }
}

module mount_joint() {
    rotate([ANGLE, 0, 0])
        translate([0, 0, -MOUNT_DIA/2])
        mount();
}

union() {
    mount_joint();
    difference() {
        translate([0, -MOUNT_DIA/2+STANDOFF_DIA/2, -STANDOFF_HEIGHT])
            standoff();
        hull()
            mount_joint();
    }
}
