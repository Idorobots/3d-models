THICKNESS = 2;
TOKEN_DIA = 24; // 21.5; // 23;
TEXT = "5";
TEXT_SIZE = 8;

BAR_WIDTH = 8;
BAR_LENGTH = 30;

HOLE_DIA = 4;

$fn = 200;

module token() {
  difference() {
    union() {
      difference() {
        cylinder(d = TOKEN_DIA, h = THICKNESS);
        #translate([0, TOKEN_DIA, 0])
        cylinder(d = TOKEN_DIA * 2, h = THICKNESS);
      }
      hull() {
        cylinder(d = BAR_WIDTH, h = THICKNESS);
        translate([0, BAR_LENGTH-BAR_WIDTH, 0])
        cylinder(d = BAR_WIDTH, h = THICKNESS);
      }
    }
    #translate([0, BAR_LENGTH-BAR_WIDTH, 0])
    cylinder(d = HOLE_DIA, h = THICKNESS);
    #translate([0, -TEXT_SIZE, THICKNESS - 0.5])
    linear_extrude(height = 1)
    text(TEXT, size = TEXT_SIZE, halign = "center");
  }
}

token();
