D20_CORNER_DIA = 2;
D20_WIDTH = 22;
D20_SPACING = 5;

D6_WIDTH = 13;
D6_CORNER_DIA = 2;
D6_COUNT = 5;
D6_SPACING = 3;

DICE_SPACING = 10;
DICE_POOL_WIDTH = D6_COUNT * D6_WIDTH + (D6_COUNT-1) * D6_SPACING;
DICE_POOL_LENGTH = 3 * D6_WIDTH + 2 * D6_SPACING;

THICKNESS = 4;
BASE_THICKNESS = 2;

WIDTH = 2 * D20_WIDTH + 2 * DICE_SPACING + D6_COUNT * D6_WIDTH + (D6_COUNT-1) * D6_SPACING;
LENGTH = D20_WIDTH + DICE_POOL_LENGTH + DICE_SPACING;
CORNER_DIA = 10;

D6_OFFSET = D6_WIDTH/2;
D20_ANGLE = [23, 0, 0];
D20_OFFSET = cos(D20_ANGLE[0]) * D20_WIDTH/2;

MAIN_DICE_MARKER_THICKNESS = THICKNESS + 1;
MAIN_D20_MARKER_DIA = D20_WIDTH + D20_SPACING;
MAIN_D6_MARKER_WIDTH = D6_COUNT * D6_WIDTH + (D6_COUNT+1) * D6_SPACING;
MAIN_D6_MARKER_LENGTH = D6_WIDTH + 2 * D6_SPACING;
MAIN_D6_MARKER_CORNER_DIA = 5;

SYMBOL_SIZE = 5;
SYMBOL_DEPTH = 1;

$fn = 100;

module rounded_rect(width, length, height, side_dia, spherical = false) {
    hull() {
        for(i = [-1, 1]) {
            for(j = [-1, 1]) {
                translate([i * (width-side_dia)/2, j * (length-side_dia)/2, 0])
                if(spherical) {
                    translate([0, 0, -(height - side_dia)/2])
                    sphere(d = side_dia);
                    translate([0, 0, (height - side_dia)/2])
                    sphere(d = side_dia);
                } else {
                    cylinder(d = side_dia, h = height, center = true); 
                }
            }
        }
    }
}

module icosahedron(width, corner_dia) {
   phi=0.5*(sqrt(5)+1);
   hull() {
       rounded_rect(width, width/phi, corner_dia, corner_dia, spherical = true);
       rotate([90,90,0]) rounded_rect(width, width/phi, corner_dia, corner_dia, spherical = true);
       rotate([90,0,90]) rounded_rect(width, width/phi, corner_dia, corner_dia, spherical = true);
   }
}

module symbol(txt, height, size = SYMBOL_SIZE) {
    linear_extrude(height, center = true)
    text(txt, size = size, font = "FontAwesome", halign = "center", valign = "center");
}

difference() {
    union() {
        translate([0, 0, THICKNESS/2])
        rounded_rect(WIDTH, LENGTH, THICKNESS, CORNER_DIA);

        translate([-WIDTH/2 + D20_WIDTH/2, LENGTH/2 - D20_WIDTH/2, 0])
        cylinder(d = MAIN_D20_MARKER_DIA, h = MAIN_DICE_MARKER_THICKNESS);

        translate([WIDTH/2 - D20_WIDTH/2, LENGTH/2 - D20_WIDTH/2, 0]) 
        cylinder(d = MAIN_D20_MARKER_DIA, h = MAIN_DICE_MARKER_THICKNESS);

        translate([0, LENGTH/2 - D20_WIDTH/2, MAIN_DICE_MARKER_THICKNESS/2])
        rounded_rect(MAIN_D6_MARKER_WIDTH, MAIN_D6_MARKER_LENGTH, MAIN_DICE_MARKER_THICKNESS, MAIN_D6_MARKER_CORNER_DIA);
    }

    #translate([0, 0, BASE_THICKNESS]) {
        translate([-WIDTH/2 + D20_WIDTH/2, LENGTH/2 - D20_WIDTH/2, , D20_OFFSET]) {
            rotate(D20_ANGLE)
            icosahedron(D20_WIDTH, D20_CORNER_DIA);
            symbol("", 2 * D20_OFFSET + 2 * SYMBOL_DEPTH);
        }

        translate([-WIDTH/2 + D20_WIDTH/2, LENGTH/2 - D20_WIDTH/2 - D20_WIDTH - D20_SPACING, D20_OFFSET]) {
            rotate(D20_ANGLE)
            icosahedron(D20_WIDTH, D20_CORNER_DIA);
            symbol("", 2 * D20_OFFSET + 2 * SYMBOL_DEPTH);
        }

        translate([WIDTH/2 - D20_WIDTH/2, LENGTH/2 - D20_WIDTH/2, D20_OFFSET]) {
            rotate(D20_ANGLE)
            icosahedron(D20_WIDTH, D20_CORNER_DIA);
            symbol("", 2 * D20_OFFSET + 2 * SYMBOL_DEPTH);
        }

        for(i = [0:D6_COUNT-1]) {
            translate([-WIDTH/2 + D6_WIDTH/2 + D20_WIDTH + DICE_SPACING + i*(D6_WIDTH + D6_SPACING), LENGTH/2 - D20_WIDTH/2, D6_OFFSET]) {
                rounded_rect(D6_WIDTH, D6_WIDTH, D6_WIDTH, D6_CORNER_DIA, spherical = true);
                symbol("", D6_WIDTH + 2 * SYMBOL_DEPTH);
            }
        }

        translate([0, -D20_WIDTH/2, THICKNESS/2]) {
            rounded_rect(DICE_POOL_WIDTH, DICE_POOL_LENGTH, THICKNESS, CORNER_DIA);
            symbol("", THICKNESS + 2 * SYMBOL_DEPTH, size = 2 * SYMBOL_SIZE);
        }
    }
}