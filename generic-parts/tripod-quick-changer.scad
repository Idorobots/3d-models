LENGTH = 22;
FRONT_WIDTH = 13.5;
BACK_WIDTH = 17.5;
THICKNESS = 1.7;
LIP = 2.5;
CORNER_DIA = 5;
HEIGHT = 8;

SCREW_DIA = 4;
SCREW_HEAD_DIA = 8;
SCREW_HEAD_LENGTH = 5;

NOTCH_WIDTH = 6;
NOTCH_LENGTH = 3.5;
NOTCH_OFFSET = 0.5;
NOTCH_DEPTH = 1;

$fn = 50;

module slide(front_width, back_width, length, thickness, corner_dia) {  
    hull() {
        fw = front_width - corner_dia;
        bw = back_width - corner_dia;
        l = length - corner_dia;
        translate([-fw/2, l/2, 0])
        cylinder(d = corner_dia, h = thickness);
        
        translate([fw/2, l/2, 0])
        cylinder(d = corner_dia, h = thickness);
        
        translate([-bw/2, -l/2, 0])
        cylinder(d = corner_dia, h = thickness);
        
        translate([bw/2, -l/2, 0])
        cylinder(d = corner_dia, h = thickness);
    }
}

difference() {
    union() {
        slide(FRONT_WIDTH, BACK_WIDTH, LENGTH, THICKNESS, CORNER_DIA);
        slide(FRONT_WIDTH - 2 * LIP, BACK_WIDTH - 2 * LIP, LENGTH, HEIGHT, CORNER_DIA);
    }
    
    translate([0, LENGTH/2 - NOTCH_LENGTH/2 - NOTCH_OFFSET, 0])
    cube(size = [NOTCH_WIDTH, NOTCH_LENGTH, NOTCH_DEPTH * 2], center = true);
    
    cylinder(d = SCREW_DIA, h = HEIGHT);
    cylinder(d = SCREW_HEAD_DIA, h = SCREW_HEAD_LENGTH);
}