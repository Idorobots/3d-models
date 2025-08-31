LEFT = "../../../Models/MoldTemplate_Left_FlatBottom.stl";
RIGHT = "../../../Models/MoldTemplate_Right_FlatBottom.stl";
MODEL = "../../../Models/nozzle-wiper-holder.stl";

TRANSLATION = [0, 0, 0];
ROTATION = [0, 0, 0];

CHANNEL_LENGTH = 18;

SIDE = "left"; // "left" // "right"
CHANNEL_PLACEMENT = "top"; // "top" // "side" // "right"

CHANNEL_PORT_DIA = 7;
CHANNEL_PORT_LENGTH = 5;
CHANNEL_NOZZLE_LENGTH = 5;
CHANNEL_NOZZLE_DIA = 2;

HOLES = true;
HOLE_DIA = 12;
HOLE_SPACING_X = 12.5;
HOLE_SPACING_Y = 10.5;
HOLE_HEIGHT = 40;
HOLE_SPAN_X = 100;
HOLE_SPAN_Y = 76;
HOLE_MARGIN = 10;

$fn = 30;

module channel() {
  union() {
    cylinder(d = CHANNEL_PORT_DIA, h = CHANNEL_PORT_LENGTH);
    cylinder(d = CHANNEL_PORT_DIA, h = CHANNEL_LENGTH - CHANNEL_NOZZLE_LENGTH);
    translate([0, 0, CHANNEL_LENGTH - CHANNEL_NOZZLE_LENGTH])
    cylinder(d1 = CHANNEL_PORT_DIA, d2 = CHANNEL_NOZZLE_DIA, h = CHANNEL_NOZZLE_LENGTH);
  }
}

module channel_placement() {
if(CHANNEL_PLACEMENT == "top" || CHANNEL_PLACEMENT == "side") {
    translate([CHANNEL_PLACEMENT == "side" ? 38.25 : 0, 38, 0])
    rotate([90, 0, 0])
    children();
  } else {
    translate([-51, -0.25, 0])
    rotate([0, 90, 0])
    children();
  }
}

module holes() {
  translate([-HOLE_SPAN_X/2, -HOLE_SPAN_Y/2, -HOLE_HEIGHT/2])
  for(i = [0:(HOLE_SPAN_X/HOLE_SPACING_X) + 1]) {
    for(j = [0:(HOLE_SPAN_Y/HOLE_SPACING_Y)]) {
      translate([(i - 1) * HOLE_SPACING_X + (j % 2) * HOLE_SPACING_X/2 + HOLE_DIA/2,
                 j * HOLE_SPACING_Y + HOLE_DIA/2,
                 0])
      rotate([0, 0, 30])
      cylinder(d = HOLE_DIA, h = HOLE_HEIGHT, $fn = 6);
    }
  }
}

module side() {
  if(SIDE == "left") {
    import(LEFT);
  } else {
    import(RIGHT);
  }
}

module model() {
  translate(TRANSLATION)
  rotate(ROTATION)
  import(MODEL);
}

difference() {
  side();

  #channel_placement()
  channel();

  #if (HOLES) {
    difference() {
      intersection() {
        holes();
        scale([(HOLE_SPAN_X - HOLE_MARGIN)/HOLE_SPAN_X,
               (HOLE_SPAN_Y - HOLE_MARGIN)/HOLE_SPAN_Y, 1.0])
        hull()
        side();
      }

      scale(1.5)
      hull()
      model();

      #channel_placement()
      scale(1.5)
      hull()
      channel();
    }
  }

  #model();
}
