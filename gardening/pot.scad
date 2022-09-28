TOP_DIA = 70;
BOT_DIA = 50;
HEIGHT = 120;

OUTLETS = 5;
OUTLET_DIA = 2;

$fn = 100;

difference() {
    cylinder(d1 = BOT_DIA, d2 = TOP_DIA, h = HEIGHT);
    #for(i = [0:OUTLETS]) {
        rotate([0, 0, i * 360/OUTLETS])
        translate([0, BOT_DIA/2, OUTLET_DIA/2])
        rotate([90, 0, 0])
        cylinder(d = OUTLET_DIA, h = BOT_DIA/2, center = true);
    }
}
