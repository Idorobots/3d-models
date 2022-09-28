BASE_DIA = 25.2;
BASE_THICKNESS = 3;

ADAPTER_DIA = BASE_DIA;
ADAPTER_THICKNESS = 0.5;

LIP_THICKNESS = 0.5;
LIP_DIA = BASE_DIA + LIP_THICKNESS * 2;
LIP_HEIGHT = ADAPTER_THICKNESS + BASE_THICKNESS;


HOOK_BOT_DIA = 6;
HOOK_TOP_DIA = 5;
HOOK_HEIGHT = BASE_THICKNESS + ADAPTER_THICKNESS + 0.5;
HOOK_OFFSET = 0.6;
HOOKS = ceil(BASE_DIA * 3.1415 / 23);

HOOKS_INSTEAD_OF_LIP = false;

$fn = 500;

difference() {
    union() {
        cylinder(d = ADAPTER_DIA, h = ADAPTER_THICKNESS);

        if(HOOKS_INSTEAD_OF_LIP) {
            for(i = [0:HOOKS-1]) {
                rotate([0, 0, i * 360/HOOKS])
                translate([0, ADAPTER_DIA/2 - HOOK_OFFSET, 0])
                cylinder(d1 = HOOK_BOT_DIA, d2 = HOOK_TOP_DIA, h = HOOK_HEIGHT);
            }
        } else {
            cylinder(d = LIP_DIA, h = LIP_HEIGHT);
        }
    }

    translate([0, 0, ADAPTER_THICKNESS]) {
        cylinder(d = BASE_DIA, h = BASE_THICKNESS);
        if(HOOKS_INSTEAD_OF_LIP) {
            cylinder(d = BASE_DIA - 2 * HOOK_OFFSET, h = HOOK_HEIGHT);
        }
    }
}
