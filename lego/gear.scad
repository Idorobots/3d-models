TOOTH_BOT_WIDTH = 1.5;
TOOTH_TOP_WIDTH = 1;
TOOTH_LENGTH = 2.2;

BEVEL_HEIGHT = 1.6;
BEVEL_ANGLE = 60;
Z_UNIT = 7.9;

$fn = 50;


module tooth(top_width, bot_width, length) {
    //   4 ___ 3
    //    /   \
    //   /_____\
    //  1       2
    polygon([
        [-length/2, -bot_width/2], // 1
        [-length/2, bot_width/2],  // 2
        [length/2, top_width/2],   // 3
        [length/2, -top_width/2]   // 4
    ]);
}

module teeth(n, diameter, top_width, bot_width, length, inner) {
    union() {
        for(i = [0:n]) {
            rotate([0, 0, i * 360/n])
            translate([-(diameter-length * (inner ? 0.9 : 1.1))/2, 0, 0])
            rotate([0, 0, inner ? 0 : 180])
            tooth(top_width, bot_width, length);
        }
    }
}

module bevel(diameter, height, angle) {
    difference() {
        cylinder(d = diameter, h = height);
        cylinder(d1 = diameter - 2 * sin(angle) * height, d2 = diameter, h = height);
    }
}

module gear(teeth, outer_dia, inner_dia, height) {
    h = height * Z_UNIT;
    union() {
        difference() {
            cylinder(d = outer_dia - 2 * TOOTH_LENGTH, h = h);
            cylinder(d = inner_dia, h = h);
        }
        difference() {
            linear_extrude(height = h)
            teeth(teeth, outer_dia, TOOTH_TOP_WIDTH, TOOTH_BOT_WIDTH, TOOTH_LENGTH, false);

            bevel(outer_dia, BEVEL_HEIGHT, BEVEL_ANGLE);
            
            if(height >= 1) {
                translate([0, 0, h])
                rotate([180, 0, 0])
                bevel(outer_dia, BEVEL_HEIGHT, BEVEL_ANGLE);
            }
        }
    }
}

gear(14, 13, 3, 0.4);