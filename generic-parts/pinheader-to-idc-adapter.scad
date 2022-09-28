PINHEADER_WIDTH = 5.2;
PINHEADER_LENGTH = 78;
PINHEADER_HEIGHT = 8.5;

IDC_WIDTH = 6.2;
IDC_LENGTH = 81;
IDC_NUB_WIDTH = 3;
IDC_NUB_THICKNESS = 1;

module adapter() {
  difference() {
    union() {
      translate([-IDC_WIDTH/2, -IDC_LENGTH/2, 0])
      cube(size = [IDC_WIDTH, IDC_LENGTH, PINHEADER_HEIGHT]);
      translate([-IDC_WIDTH/2 - IDC_NUB_THICKNESS, -IDC_NUB_WIDTH/2, 0])
      cube(size = [IDC_NUB_THICKNESS, IDC_NUB_WIDTH, PINHEADER_HEIGHT]);
    }
    translate([-PINHEADER_WIDTH/2, -PINHEADER_LENGTH/2, 0])
    cube(size = [PINHEADER_WIDTH, PINHEADER_LENGTH, PINHEADER_HEIGHT]);
  }
}

adapter();
