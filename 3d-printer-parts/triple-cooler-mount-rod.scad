WALL_THICKNESS = 1.5;
LENGTH = 20;

TOP_THICKNESS = 4;
TOP_INNER_DIA = 2;

BOT_THICKNESS = 6.5;
BOT_INNER_DIA = 2.5;

ROD_LENGTH = LENGTH - BOT_THICKNESS - TOP_THICKNESS;
ROD_WIDTH = 4;


$fn = 30;

module bot_mount() {
  rotate([0, 90, 0])
  translate([0, 0, -BOT_THICKNESS/2-WALL_THICKNESS])
  union() {
    difference() {
      hull() {
        cylinder(d = ROD_WIDTH, h = BOT_THICKNESS + 2 * WALL_THICKNESS);
        translate([0, BOT_THICKNESS, 0])
        cylinder(d = ROD_WIDTH, h = BOT_THICKNESS + 2 * WALL_THICKNESS);
      }
      translate([0, 0, WALL_THICKNESS])
      cylinder(d = BOT_THICKNESS + WALL_THICKNESS, h = BOT_THICKNESS);
    }
    translate([0, 0, WALL_THICKNESS])
    scale([1.0, 1.0, 0.75])
    sphere(d = BOT_INNER_DIA);
    
    translate([0, 0, BOT_THICKNESS + WALL_THICKNESS])
    scale([1.0, 1.0, 0.75])
    sphere(d = BOT_INNER_DIA);
  }
}

module top_mount() {
  translate([0, ROD_LENGTH + BOT_THICKNESS, 0])
  rotate([0, 90, 0])
  translate([0, 0, -TOP_THICKNESS/2])
  difference() {
    hull() {
      cylinder(d = ROD_WIDTH, h = TOP_THICKNESS);
      translate([0, TOP_THICKNESS, 0])
      cylinder(d = ROD_WIDTH, h = TOP_THICKNESS);
    }
    translate([0, TOP_THICKNESS, 0])
    cylinder(d = TOP_INNER_DIA, h = TOP_THICKNESS);
  }
}

module rod() {
  translate([0, ROD_LENGTH/2 + BOT_THICKNESS, 0])
  cube([ROD_WIDTH, ROD_LENGTH, ROD_WIDTH], center = true);
}

module mount() {
  union() {
    bot_mount();
    rod();
    top_mount();
  }
}

mount();