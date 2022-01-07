MAGNET_DIA = 14;
MAGNET_HEIGHT = 4;

HEX_DIA = 15.7;
HEX_HEIGHT = 16;

ADAPTER_DIA = 22;
ADAPTER_HEIGHT = HEX_HEIGHT + MAGNET_HEIGHT;


$fn = 50;

module flex_arm_adapter() {
  difference() {
    cylinder(d = ADAPTER_DIA, h = ADAPTER_HEIGHT);
    translate([0, 0, MAGNET_HEIGHT])
    cylinder(d = HEX_DIA, h = HEX_HEIGHT, $fn = 6);
    cylinder(d = MAGNET_DIA, h = MAGNET_HEIGHT);
  }
}

flex_arm_adapter();