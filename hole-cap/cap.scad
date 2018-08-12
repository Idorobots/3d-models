thickness = 1.2;
wall_thickness = 2;
diameter = 80;
height = 10;

opening_dia = 40;

$fn = 100;

difference() {
  cylinder(d = diameter + wall_thickness, h = height);
  translate([0, 0, thickness])
    cylinder(d = diameter, h = height);

  cylinder(d = opening_dia, h = 4 * thickness, center=true);
}
