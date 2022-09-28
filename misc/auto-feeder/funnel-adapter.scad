THICKNESS = 2;
WIDTH = 56.5;
LENGTH = 38.5;
HEIGHT = 5;

module adapter() {
  wt = 2 * THICKNESS;
  difference() {
    cube(size = [WIDTH + wt, LENGTH + wt, HEIGHT], center = true);
    cube(size = [WIDTH, LENGTH, HEIGHT], center = true);
  }
}

adapter();
