BNC_DIA = 11;
GROMMET_DIA = 13;
GROMMET_LENGTH = 10;
FLANGE_DIA = 18;
FLANGE_THICKNESS = 2;

$fn = 30;

difference() {
  union() {
    cylinder(d = FLANGE_DIA, h = FLANGE_THICKNESS);
    cylinder(d = GROMMET_DIA, h = GROMMET_LENGTH);
  }

  cylinder(d = BNC_DIA, h = GROMMET_LENGTH);
}
