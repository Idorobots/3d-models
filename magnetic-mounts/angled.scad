SCREW_DIA = 2.8;
STANDOFF_DIA = 9;
STANDOFF_HEIGHT = 8;
SCREW_LENGTH = STANDOFF_HEIGHT - 3;

MAGNET_DIA = 10.5;
MAGNET_HEIGHT = 3.1;
HOLDER_DIA = MAGNET_DIA+1.2;
HOLDER_HEIGHT = 5.25;

ANGLE = 90;
ROUNDED = false;

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

module magnet_mount() {
    union() {
        intersection() {
            if(ROUNDED) sphere(d = HOLDER_DIA);
            cylinder(d = HOLDER_DIA, h = HOLDER_DIA/2);
        }
        translate([0, 0, -HOLDER_HEIGHT])
            tube(HOLDER_DIA, MAGNET_DIA, HOLDER_HEIGHT, MAGNET_HEIGHT);
    }    
}

module mount_joint() {
    rotate([ANGLE, 0, 0])
        magnet_mount();
}

union() {
    mount_joint();
    difference() {
        translate([0, -HOLDER_DIA/2+STANDOFF_DIA/2, -STANDOFF_HEIGHT])
            standoff();
        hull() 
            mount_joint();
    }
}