N = 3; // 4;
SPACING = 25;
OFFSET = -27; // -47;

use </home/k/projects/3d/generic-parts/pci-bracket.scad>;

module keystone() {
  translate([0, 9, -8.4])
  rotate([0, 0, -90])
  import("/home/k/Models/keystone-socket.stl");
}

union() {
  difference() {
    pci_bracket();
    for(i = [0:N-1]) {
      translate([i * SPACING + OFFSET, 0, 0])
      hull()
      keystone();
    }
  }
  for(i = [0:N-1]) {
    translate([i * SPACING + OFFSET, 0, 0])
    keystone();
  }
}
