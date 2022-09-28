FAN_WIDTH = 79.5;
FAN_HEIGHT = 14;
FAN_DIA = 78;
FAN_CORNER_DIA = 5;
FAN_MOUNT_DIA = 5;
FAN_MOUNT_SPACING = 71.5;

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
    mounting_holes(width - corner_dia, length - corner_dia, height, corner_dia);
}

difference() {
    rounded_rect(FAN_WIDTH, FAN_WIDTH, FAN_HEIGHT, FAN_CORNER_DIA);
    cylinder(d = FAN_DIA, h = FAN_HEIGHT);
    mounting_holes(FAN_MOUNT_SPACING, FAN_MOUNT_SPACING, FAN_HEIGHT, FAN_MOUNT_DIA);
}
