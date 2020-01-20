OUTLET_OFFSET = 6;
OUTLET_INNER_DIA = 7;
OUTLET_OUTER_DIA = 10;

FAN_SIZE = 40;
FAN_DIA = 36;
FAN_THICKNESS = 10;

FAN_OUTLET_SIZE = 30;
FAN_OUTLET_OFFSET = (FAN_SIZE - FAN_OUTLET_SIZE)/2;
FAN_OUTLET_WALL_THICKNESS = 1;
FAN_OUTLET_ORING_SIZE = 2;
FAN_OUTLET_ORING_OFFSET = 1;

FAN_MOUNT_SPACING = 35;
FAN_MOUNT_DIA = 2;

BACKPLATE_THICKNESS = 1;
BACKPLATE_SIZE = FAN_SIZE;
BACKPLATE_CORNER_DIA = 4;

$fn = 50;

module rounded_rect(width, length, height, corner_dia) {
    hull() {
        for(i = [-1, 1]) {
            for(j = [-1, 1]) {
                translate([i*(width-corner_dia)/2, j*(length-corner_dia)/2, 0])
                cylinder(d = corner_dia, h = height);
            }
        }
    }
}

module outlet_pos() {
    translate([0, FAN_SIZE/2 + OUTLET_OFFSET + OUTLET_OUTER_DIA/2, BACKPLATE_THICKNESS + FAN_THICKNESS/2])
    rotate([0, -90, 0])
    translate([0, 0, -FAN_SIZE/2])
    union() {
        h = FAN_OUTLET_SIZE-OUTLET_OUTER_DIA/2;
        translate([0, 0, h])
        sphere(d = OUTLET_OUTER_DIA);
        cylinder(d = OUTLET_OUTER_DIA, h = h);
    }
}

module outlet_neg() {
    translate([0, FAN_SIZE/2 + OUTLET_OFFSET + OUTLET_OUTER_DIA/2, BACKPLATE_THICKNESS + FAN_THICKNESS/2])
    rotate([0, -90, 0])
    translate([0, 0, -FAN_SIZE/2])
    union() {
        h = FAN_OUTLET_SIZE-OUTLET_OUTER_DIA/2;
        translate([0, 0, h])
        sphere(d = OUTLET_INNER_DIA);
        cylinder(d = OUTLET_INNER_DIA, h = h);
        translate([0, 0, FAN_OUTLET_ORING_OFFSET])
        rotate_extrude()
        translate([-OUTLET_INNER_DIA/2, 0, 0])
        circle(d = FAN_OUTLET_ORING_SIZE);
    }
}

module mounting_holes() {
    for(i = [-1, 1]) {
        for(j = [-1, 1]) {
            translate([i * FAN_MOUNT_SPACING/2, j * FAN_MOUNT_SPACING/2, 0])
            cylinder(d = FAN_MOUNT_DIA, h = FAN_THICKNESS * 3, center = true);
        }
    }
}

module backplate() {
    rounded_rect(BACKPLATE_SIZE, BACKPLATE_SIZE, BACKPLATE_THICKNESS, BACKPLATE_CORNER_DIA);
}

module fan_outlet_pos() {
    rounded_rect(FAN_SIZE, FAN_SIZE, 2 * BACKPLATE_THICKNESS + FAN_THICKNESS, BACKPLATE_CORNER_DIA);
}

module fan_outlet_neg() {
    hull() {
        translate([FAN_OUTLET_OFFSET - (FAN_SIZE-FAN_OUTLET_SIZE)/2, FAN_OUTLET_WALL_THICKNESS/2, BACKPLATE_THICKNESS])
        rounded_rect(FAN_OUTLET_SIZE - FAN_OUTLET_WALL_THICKNESS * 2, FAN_SIZE - FAN_OUTLET_WALL_THICKNESS, FAN_THICKNESS, BACKPLATE_CORNER_DIA);    
        
        intersection() {
            rounded_rect(FAN_OUTLET_SIZE - FAN_OUTLET_WALL_THICKNESS * 2, FAN_SIZE * 2, FAN_THICKNESS, BACKPLATE_CORNER_DIA);
            
            outlet_neg();
        }
    }
}

module fan_neg() {
    translate([0, 0, BACKPLATE_THICKNESS])
    union() {
        rounded_rect(FAN_SIZE, FAN_SIZE, FAN_THICKNESS, BACKPLATE_CORNER_DIA);
        cutout = FAN_SIZE * 0.75;
        delta = (FAN_SIZE - cutout)/2;
        translate([0, -delta, 0])
        rounded_rect(FAN_SIZE * 2, cutout, FAN_THICKNESS + BACKPLATE_THICKNESS, BACKPLATE_CORNER_DIA);
        cylinder(d = FAN_DIA, h = FAN_THICKNESS + BACKPLATE_THICKNESS);
    }
}

difference() {
    union() {
        backplate();

        hull() {
            fan_outlet_pos();
            outlet_pos();
        }
    }
    
    outlet_neg();
    fan_outlet_neg();
    fan_neg();
    mounting_holes();
}