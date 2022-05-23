IRON_DIA = 11;
IRON_LENGTH = 2.5;

BASE_DIA_TOP = 16;
BASE_DIA_BOT = 20;
BASE_LENGTH = 15;

WALL_THICKNESS = 2;

$fn = 100;

module adapter() {
  difference() {
    union() {
      cylinder(d1 = BASE_DIA_BOT, d2 = BASE_DIA_TOP, h = BASE_LENGTH);
    }
  
    #cylinder(d = IRON_DIA, h = IRON_LENGTH);
    
    #translate([0, 0, IRON_LENGTH])
    cylinder(d1 = BASE_DIA_BOT - WALL_THICKNESS * 2, d2 = BASE_DIA_TOP - WALL_THICKNESS * 2, h = BASE_LENGTH);
  }
}

adapter();
