PIPE_DIA = 8.2;
PIPE_OFFSET = 4.5;

PIPE_EXTENDERS = true;
PIPE_EXTENDERS_DIA = 10;
PIPE_EXTENDERS_LENGTH = 5;

PIPE_ANGLES = [
  [60, 0, 0],
  [60, 0, 125],
  [60, 0, 235],
];

FLAT_OFFSET = 2;
CONNECTOR_DIA = 25;

MOUNT_HOLE = true;
MOUNT_HOLE_HEAD_DIA = 8;
MOUNT_HOLE_HEAD_HEIGHT = 4;
MOUNT_HOLE_DIA = 3;

$fn = 50;

module pipes(dia = PIPE_DIA, length = CONNECTOR_DIA, offset = PIPE_OFFSET) {
    for (i = [0:len(PIPE_ANGLES)-1]) {
        rotate(PIPE_ANGLES[i])
        translate([0, 0, offset])
        cylinder(d = dia, h = length);
    }
}

module connector() {
    difference() {
        intersection() {
            translate([0, 0, FLAT_OFFSET])
            difference() {
                union() {
                    sphere(d = CONNECTOR_DIA);

                    if (PIPE_EXTENDERS) {
                        pipes(PIPE_EXTENDERS_DIA, CONNECTOR_DIA/2 - PIPE_OFFSET + PIPE_EXTENDERS_LENGTH);
                    }
                }

                #pipes();
            }

            cylinder(d = CONNECTOR_DIA * 5, h = CONNECTOR_DIA);
        }

        if (MOUNT_HOLE) {
            #cylinder(d = MOUNT_HOLE_DIA, h = CONNECTOR_DIA);
            #translate([0, 0, CONNECTOR_DIA/2 + FLAT_OFFSET - MOUNT_HOLE_HEAD_HEIGHT])
            cylinder(d = MOUNT_HOLE_HEAD_DIA, h = MOUNT_HOLE_HEAD_HEIGHT);
        }
    }
}

connector();
