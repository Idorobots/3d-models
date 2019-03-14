TOP_DIAMETER = 115;
BOT_DIAMETER = 110;
HEIGHT = 10;
THICKNESS = 1.2;
N_STANDOFFS = 5;
STANDOFF_DIA = 10;
STANDOFF_HEIGHT = 4;

$fn = 100;

intersection() {
    union() {
        difference() {
            cylinder(d2 = TOP_DIAMETER, d1 = BOT_DIAMETER, h = HEIGHT);
            translate([0, 0, THICKNESS])
            cylinder(d2 = TOP_DIAMETER - 2 * THICKNESS, d1 = BOT_DIAMETER - 2 * THICKNESS, h = HEIGHT);
        }
        
        for(i = [0:N_STANDOFFS]) {
            rotate([0, 0, i * 360/N_STANDOFFS])
            translate([(BOT_DIAMETER - 2 * THICKNESS)/4, 0, THICKNESS])
            scale([1, 1, STANDOFF_HEIGHT/(STANDOFF_DIA/2)])
            sphere(d = STANDOFF_DIA);
        }
    }

    cylinder(d = TOP_DIAMETER, h = HEIGHT);
}