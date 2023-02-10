MAGNET_DIA = 10;
MAGNET_THICKNESS = 2;

MARKER_DIA = 25;
MARKER_THICKNESS = MAGNET_THICKNESS + 1.5;

SYMBOL_THICKNESS = 0.5;
SYMBOL_INLAY_DIA = MARKER_DIA - 2;
SYMBOL_SIZE = 0.6 * MARKER_DIA;
SYMBOL_FONT = "URW Bookman:style=Demi";
SYMBOL = "L";

$fn = 100;

union() {
  difference() {
    cylinder(d = MARKER_DIA, h = MARKER_THICKNESS);
    translate([0, 0, MARKER_THICKNESS - SYMBOL_THICKNESS])
    cylinder(d = SYMBOL_INLAY_DIA, h = SYMBOL_THICKNESS);
    cylinder(d = MAGNET_DIA, h = MAGNET_THICKNESS);
  }

  translate([0, 0, MARKER_THICKNESS - SYMBOL_THICKNESS])
  linear_extrude(SYMBOL_THICKNESS)
  text(SYMBOL, font = SYMBOL_FONT, size = SYMBOL_SIZE, valign = "center", halign = "center");
}
