CORNER_DIA = 3;
SIDE_WIDTH = 12;
DEPTH = 0.7;
IMAGE_SCALE = 100;

SPHERE_ROUNDING = true;
SPHERE_DIA = SIDE_WIDTH * 1.375;

GENERIC = [
    ["dice/strength.svg", 0.9, [0, 0, 0]],
    ["dice/endurance.svg", 0.35, [90, 0, 0]],
    ["dice/agility.svg", 0.55, [-90, 0, 0]],
    ["dice/wisdom.svg", 0.6, [0, -90, 0]],
    ["dice/focus.svg", 0.6, [0, 90, 0]],
    ["dice/charisma.svg", 0.35, [180, 0, 0]]
];

WARRIOR = [
    ["dice/agility.svg", 0.55, [0, 0, 0]],
    ["dice/strength.svg", 0.9, [-90, 0, 0]],
    ["dice/strength.svg", 0.9, [90, 0, 0]],
    ["dice/endurance.svg", 0.35, [0, -90, 0]],
    ["dice/endurance.svg", 0.35, [0, 90, 0]],
    ["dice/blank.svg", 0.6, [180, 0, 0]]
];

ROGUE = [
    ["dice/charisma.svg", 0.35, [0, 0, 0]],
    ["dice/agility.svg", 0.55, [90, 0, 0]],
    ["dice/agility.svg", 0.55, [-90, 0, 0]],
    ["dice/strength.svg", 0.9, [0, -90, 0]],
    ["dice/strength.svg", 0.9, [0, 90, 0]],
    ["dice/blank.svg", 0.6, [180, 0, 0]]
];

CLERIC = [
    ["dice/strength.svg", 0.9, [0, 0, 0]],
    ["dice/endurance.svg", 0.35, [90, 0, 0]],
    ["dice/endurance.svg", 0.35, [-90, 0, 0]],
    ["dice/focus.svg", 0.6, [0, -90, 0]],
    ["dice/focus.svg", 0.6, [0, 90, 0]],
    ["dice/blank.svg", 0.6, [180, 0, 0]]
];

MAGE = [
    ["dice/charisma.svg", 0.35, [0, 0, 0]],
    ["dice/wisdom.svg", 0.6, [90, 0, 0]],
    ["dice/wisdom.svg", 0.6, [-90, 0, 0]],
    ["dice/focus.svg", 0.6, [0, -90, 0]],
    ["dice/focus.svg", 0.6, [0, 90, 0]],
    ["dice/blank.svg", 0.6, [180, 0, 0]]
];

RANGER = [
    ["dice/endurance.svg", 0.35, [0, 0, 0]],
    ["dice/agility.svg", 0.55, [90, 0, 0]],
    ["dice/agility.svg", 0.55, [-90, 0, 0]],
    ["dice/focus.svg", 0.6, [0, -90, 0]],
    ["dice/focus.svg", 0.6, [0, 90, 0]],
    ["dice/blank.svg", 0.6, [180, 0, 0]]
];

BARD = [
    ["dice/blank.svg", 0.6, [0, 0, 0]],
    ["dice/wisdom.svg", 0.6, [90, 0, 0]],
    ["dice/wisdom.svg", 0.6, [-90, 0, 0]],
    ["dice/charisma.svg", 0.35, [0, -90, 0]],
    ["dice/charisma.svg", 0.35, [0, 90, 0]],
    ["dice/blank.svg", 0.6, [180, 0, 0]]
];

DEFENCE = [
    ["dice/endurance.svg", 0.35, [0, 0, 0]],
    ["dice/blank.svg", 0.6, [90, 0, 0]],
    ["dice/blank.svg", 0.6, [-90, 0, 0]],
    ["dice/blank.svg", 0.6, [0, -90, 0]],
    ["dice/blank.svg", 0.6, [0, 90, 0]],
    ["dice/endurance.svg", 0.35, [180, 0, 0]]
];

ATTACK = [
    ["dice/hit.svg", 0.35, [0, 0, 0]],
    ["dice/blank.svg", 0.6, [90, 0, 0]],
    ["dice/blank.svg", 0.6, [-90, 0, 0]],
    ["dice/blank.svg", 0.6, [0, -90, 0]],
    ["dice/blank.svg", 0.6, [0, 90, 0]],
    ["dice/hit.svg", 0.35, [180, 0, 0]]
];

SIDES = CLERIC;
COLOR = "white";

$fn = 30;

module rounded_cube(width, length, height, corner_dia, rounding = SPHERE_DIA) {
    if(SPHERE_ROUNDING) {
        intersection() {
            cube(size = [width, length, height], center = true);
            sphere(d = rounding, $fn = $fn * 10);
        }
    } else {
        hull() {
            for(x = [-1, 1]) {
                for(y = [-1, 1]) {
                    for(z = [-1, 1]) {
                        translate([x * (width - corner_dia)/2, y * (length - corner_dia)/2, z * (height - corner_dia)/2])
                        sphere(d = corner_dia, $fn = $fn);
                    }
                }
            }
        }
    }
}
module side(filename, scale_factor, rotation) {
    rotate(rotation)
    translate([0, 0, SIDE_WIDTH/2 - DEPTH])
    linear_extrude(DEPTH * 2)
    scale(scale_factor * SIDE_WIDTH/IMAGE_SCALE)
    import(filename, center = true);
}

color(COLOR)
difference() {
    rounded_cube(SIDE_WIDTH, SIDE_WIDTH, SIDE_WIDTH, CORNER_DIA);
    for(side = SIDES) {
        side(side[0], side[1], side[2]);
    }
}