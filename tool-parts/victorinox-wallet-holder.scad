WIDTH = 13;
LENGTH = 70;
THICKNESS = 3.5;

PEN_DIA = 3;
PEN_LENGTH = 68;

TOOTHPICK_WIDTH = 3.5;
TOOTHPICK_THICKNESS = 2.5;
TOOTHPICK_LENGTH = PEN_LENGTH;
TOOTHPICK_OFFSET = 4;

TWEEZERS_WIDTH = 3.5;
TWEEZERS_THICKNESS = 2.5;
TWEEZERS_LENGTH = PEN_LENGTH;
TWEEZERS_OFFSET = -4;

$fn = 50;

module holder() {
  difference() {
    translate([-WIDTH/2, -LENGTH, -THICKNESS/2])
    cube(size = [WIDTH, LENGTH, THICKNESS]);

    #rotate([90, 0, 0])
    cylinder(d = PEN_DIA, h = PEN_LENGTH);

    #translate([-TOOTHPICK_WIDTH/2 + TOOTHPICK_OFFSET, -TOOTHPICK_LENGTH, -TOOTHPICK_THICKNESS/2])
    cube(size = [TOOTHPICK_WIDTH, TOOTHPICK_LENGTH, TOOTHPICK_THICKNESS]);

    #translate([-TWEEZERS_WIDTH/2 + TWEEZERS_OFFSET, -TWEEZERS_LENGTH, -TWEEZERS_THICKNESS/2])
    cube(size = [TWEEZERS_WIDTH, TWEEZERS_LENGTH, TWEEZERS_THICKNESS]);
  }
}

holder();
