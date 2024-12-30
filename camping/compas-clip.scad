WIDTH = 23;
LENGTH = WIDTH;
CORNER_DIA = 5;
BASE_THICKNESS = 3;
RETAINER_THICKNESS = 5;
RETAINER_DIA = WIDTH;

COMPASS_DIA = 20;
HOLE_DIA = 5;
HOLE_TOP_DIA = 6;

WEBBING_THICKNESS = 1.5;
WEBBING_WIDTH = 20;
CLIP_THICKNESS = 5;


$fn = 50;

module rounded_rect(w, l, h, d) {
    hull() {
        for(i = [-1, 1]) {
            for(j = [-1, 1]) {
                translate([i * (w-d)/2, j*(l-d)/2, 0])
                cylinder(d = d, h = h);
            }
        }
    }
}

module retainer() {
    difference() {
        union() {
            rounded_rect(WIDTH, LENGTH, BASE_THICKNESS, CORNER_DIA);
            cylinder(d = RETAINER_DIA, h = RETAINER_THICKNESS + BASE_THICKNESS);
        }

        cylinder(d = HOLE_DIA, h = BASE_THICKNESS);
        translate([0, 0, BASE_THICKNESS - 1])
        cylinder(d = HOLE_TOP_DIA, h = 1);
        translate([0, 0, BASE_THICKNESS])
        cylinder(d = COMPASS_DIA, h = RETAINER_THICKNESS);
    }
}

module retainer_clip() {
    union() {
        difference() {
            rounded_rect(WIDTH, CLIP_THICKNESS, WEBBING_WIDTH, CLIP_THICKNESS);
            translate([(CLIP_THICKNESS-WEBBING_THICKNESS)/2, 0, 0])
            rounded_rect(WIDTH, WEBBING_THICKNESS, WEBBING_WIDTH, WEBBING_THICKNESS);
        }
        translate([WEBBING_WIDTH/2+WEBBING_THICKNESS/3, -WEBBING_THICKNESS/2, 0])
        rounded_rect(WEBBING_THICKNESS, WEBBING_THICKNESS, WEBBING_WIDTH, WEBBING_THICKNESS);

        translate([0, BASE_THICKNESS+CLIP_THICKNESS/2, WEBBING_WIDTH/2])
        rotate([90, 90, 0])
        nub();
    }
}

module nub() {
    difference() {
        union() {
            cylinder(d = HOLE_TOP_DIA-0.2, h = 0.8);
            cylinder(d = HOLE_DIA, h = BASE_THICKNESS);
        }
        rounded_rect(HOLE_TOP_DIA, 1, BASE_THICKNESS-1, 1);
    }
}

//retainer();
retainer_clip();
