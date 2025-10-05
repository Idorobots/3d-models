FW_TOP_WIDTH = 3.5;
FW_TOP_LENGTH = 11.5;
FW_BOT_WIDTH = 6.5;
FW_BOT_LENGTH = 9.76;

USB_WIDTH = 9.5;
USB_DIA = 3.5;

HEIGHT = 5;

$fn = 50;

difference() {
  hull() {
    translate([-FW_TOP_WIDTH/2, -FW_TOP_LENGTH/2, 0])
    cube(size = [FW_TOP_WIDTH, FW_TOP_LENGTH, HEIGHT]);

    translate([-FW_BOT_WIDTH/2, -FW_TOP_LENGTH/2, 0])
    cube(size = [FW_BOT_WIDTH, FW_BOT_LENGTH, HEIGHT]);
  }

  #hull() {
    translate([0, -(USB_WIDTH-USB_DIA)/2, 0])
    cylinder(d = USB_DIA, h = HEIGHT);
    translate([0, (USB_WIDTH-USB_DIA)/2, 0])
    cylinder(d = USB_DIA, h = HEIGHT);
  }
}
