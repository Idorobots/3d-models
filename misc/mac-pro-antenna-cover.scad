width = 62.5;
length = 183;
corner_dia = 13;

thickness = 0.5;


$fn = 20;

module rounded_rect(w, l, h, d) {
  hull() {
    for(i = [-1, 1]) {
     for(j = [-1, 1]) {
       translate([i*(w-d)/2, j*(l-d)/2, 0])
       cylinder(d = d, h = h);
     }
    }
  }
}

rounded_rect(width, length, thickness, corner_dia);
