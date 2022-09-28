FILTER_DIA = 10.5;
FILTER_BASE_DIA = 15;
FILTER_BASE_HEIGHT = 1.5;

PEGS = 3;
PEG_DIA = 2.5;
PEG_SPACING_RADIUS = 9.5;
PEG_HEIGHT = 3;

ADAPTER_DIA = 23;
ADAPTER_HEIGHT = 3;

$fn = 50;

module adapter() {
  difference() {
    cylinder(d = ADAPTER_DIA, h = ADAPTER_HEIGHT);
    cylinder(d = FILTER_BASE_DIA, h = FILTER_BASE_HEIGHT);
    cylinder(d = FILTER_DIA, h = ADAPTER_HEIGHT);

    for(i = [0:PEGS]) {
      rotate([0, 0, i * 360/PEGS])
      translate([-PEG_SPACING_RADIUS, 0, 0])
      cylinder(d = PEG_DIA, h = PEG_HEIGHT);
    }
  }
}

adapter();
