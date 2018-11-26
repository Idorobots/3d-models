HUB_BOTTOM_DIAMETER = 40;
HUB_TOP_DIAMETER = 18;
SHAFT_BOTTOM_DIAMETER = 10;
SHAFT_TOP_DIAMETER = 9.5;
SHAFT_KEY_WIDTH = 8;
HUB_HEIGHT = 25;

BLADE_CURVE_DIAMETER = 80;
BLADE_OUTER_HEIGHT = 28;
BLADE_MAX_HEIGHT = 31;
BLADE_INNER_HEIGHT = 15;
BLADE_THICKNESS = 3;
N_BLADES = 9;
HOLE_DIAMETER = 7;
HOLE_SPACING_DIAMETER = 50;

FAN_DIAMETER = 110;
LIP_HEIGHT = 2.5;
PLATE_THICKNESS = 3.5;

MIRRORED = true;

$fn = 50;

module hub_pos() {
    cylinder(d1 = HUB_BOTTOM_DIAMETER, d2 = HUB_TOP_DIAMETER, h = HUB_HEIGHT);
}

module hub_neg() {
    union() {
        intersection() {
            cylinder(d = SHAFT_TOP_DIAMETER, h = HUB_HEIGHT);
            translate([-SHAFT_KEY_WIDTH/2, -SHAFT_TOP_DIAMETER/2, 0])
            cube(size = [SHAFT_KEY_WIDTH, SHAFT_TOP_DIAMETER, HUB_HEIGHT]);
        }
        cylinder(d = SHAFT_BOTTOM_DIAMETER, h = HUB_HEIGHT/2);
    }
}

module plate_pos() {
    cylinder(d = FAN_DIAMETER, h = PLATE_THICKNESS + LIP_HEIGHT);
}

module plate_neg() {
    cylinder(d = FAN_DIAMETER - LIP_HEIGHT, h = LIP_HEIGHT);
}

module blade_pos() {
    translate([0, -BLADE_CURVE_DIAMETER/2, 0])
    intersection() {
        difference() {
            cylinder(d = BLADE_CURVE_DIAMETER, h = BLADE_MAX_HEIGHT);
            cylinder(d = BLADE_CURVE_DIAMETER - 2* BLADE_THICKNESS, h = BLADE_MAX_HEIGHT);
        }
        cube(size = BLADE_CURVE_DIAMETER);
    }
}

module blade_neg() {
    translate([0, -HOLE_SPACING_DIAMETER/2, 0])
    cylinder(d = HOLE_DIAMETER, h = BLADE_MAX_HEIGHT);
}

module blades_pos() {
    for(i = [0:N_BLADES]) {
        rotate([0, 0, i*(360/N_BLADES)])
        blade_pos();
    }
}

module blades_neg() {
    union() {
        for(i = [0:N_BLADES]) {
            rotate([0, 0, i*(360/N_BLADES) + (360/N_BLADES/3)])
            blade_neg();
        }
        difference() {
            translate([0, 0, BLADE_INNER_HEIGHT])
            cylinder(d1 = 0, d2 = FAN_DIAMETER/2, h = BLADE_MAX_HEIGHT-BLADE_INNER_HEIGHT);
            hub_pos();
        }
        difference() {
            cylinder(d = 2*FAN_DIAMETER, h = BLADE_MAX_HEIGHT);
            cylinder(d = FAN_DIAMETER, h = BLADE_MAX_HEIGHT);
        }
        difference() {
            cylinder(d = 3*FAN_DIAMETER, h = BLADE_MAX_HEIGHT);
            cylinder(d1 = 3*FAN_DIAMETER, d2=FAN_DIAMETER/2, h = BLADE_MAX_HEIGHT);
        }
    }
}

mirror([MIRRORED ? 1 : 0, 0, 0])
difference() {
    union() {
        hub_pos();
        plate_pos();
        blades_pos();
    }
    
    hub_neg();
    plate_neg();
    blades_neg();
}