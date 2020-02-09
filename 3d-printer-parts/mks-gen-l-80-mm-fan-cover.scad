PCB_MOUNT_DIA = 4;
PCB_MOUNT_SPACING_X = 101.5;
PCB_MOUNT_SPACING_Y = 76;

FAN_MOUNT_DIA = 5;
FAN_DIA = 78;
FAN_MOUNT_SPACING = 71.5;
FAN_OFFSET_X = 7;
FAN_OFFSET_Y = 0;

THICKNESS = 2;
CORNER_DIA = 5;
WIDTH = PCB_MOUNT_SPACING_X + CORNER_DIA;
LENGTH = PCB_MOUNT_SPACING_Y + CORNER_DIA;

$fn = 50;

module mounting_holes(width, length, height, dia) {
    for(i = [-1, 1]) {
        for(j = [-1, 1]) {
            translate([i * width/2, j * length/2, 0])
            cylinder(d = dia, h = height);
        }
    }
}

module rounded_rect(width, length, height, corner_dia) {
    hull()
    mounting_holes(width, length, height, corner_dia);
}

difference() {
    rounded_rect(WIDTH, LENGTH, THICKNESS, CORNER_DIA);

    mounting_holes(PCB_MOUNT_SPACING_X, PCB_MOUNT_SPACING_Y, THICKNESS, PCB_MOUNT_DIA);

    translate([-(PCB_MOUNT_SPACING_X - FAN_MOUNT_SPACING)/2 + FAN_OFFSET_X, -(PCB_MOUNT_SPACING_Y - FAN_MOUNT_SPACING)/2 + FAN_OFFSET_Y, 0])
    union() {
        mounting_holes(FAN_MOUNT_SPACING, FAN_MOUNT_SPACING, THICKNESS, FAN_MOUNT_DIA);
        difference() {
            l = FAN_DIA - FAN_MOUNT_DIA;
            rounded_rect(l, l, THICKNESS, FAN_MOUNT_DIA);
            mounting_holes(FAN_MOUNT_SPACING, FAN_MOUNT_SPACING, THICKNESS, FAN_MOUNT_DIA * 2);
        }
    }
}