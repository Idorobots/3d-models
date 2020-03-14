RANDOM_SEED_MOUND = 156;
RANDOM_SEED_SPIKES = 156;

LENGTH = 25;
WIDTH = 20;
HEIGHT = 12;
ANGLE = 45;

SPIKE_DIA = 2.1;
SPIKE_LENGTH = 30;
SPIKE_TOP_LENGTH = 7;
N_SPIKES = LENGTH/2;

X_BASE_ANGLE = 55;
Y_BASE_ANGLE = 0;

X_ANGLE_RAND = 10;
Y_ANGLE_RAND = 5;
X_RAND = 0;
Y_RAND = 6;
Z_RAND = 2;
LENGTH_RAND = 5;

MOUND_CHUNKYNESS = 6;
MOUND_CHUNK_MAX_SIZE = 15;
MOUND_CHUNKS = 300;
MOUND_CHUNKS_GROUP = 10;

$fn = 50;

module spike(dia, length, top_length) {
    union() {
        cylinder(d = dia, h = length - top_length);
        translate([0, 0, length - top_length])
        cylinder(d1 = dia, d2 = 0, h = top_length);
        translate([0, 0, -length])
        cylinder(d = dia, h = length);
    }
}

module spikes() {
    seeds = rands(0, 12375764435432, 6, RANDOM_SEED_SPIKES);
    x_delta = rands(-X_RAND, X_RAND, N_SPIKES, seeds[0]);
    y_delta = rands(-Y_RAND, Y_RAND, N_SPIKES, seeds[1]);
    z_delta = rands(0, Z_RAND, N_SPIKES, seeds[2]);
    x_angle_delta = rands(-X_ANGLE_RAND, X_ANGLE_RAND, N_SPIKES, seeds[3]);
    y_angle_delta = rands(-Y_ANGLE_RAND, Y_ANGLE_RAND, N_SPIKES, seeds[4]);
    len_delta = rands(-LENGTH_RAND, LENGTH_RAND, N_SPIKES, seeds[5]);

    for(i = [0:N_SPIKES-1]) {
        x = (i + 1) * LENGTH/(N_SPIKES+1) + x_delta[i] - LENGTH/2;
        rotate([0, 0, (x / LENGTH) * ANGLE])
        translate([x, y_delta[i], z_delta[i]])
        rotate([X_BASE_ANGLE + x_angle_delta[i], Y_BASE_ANGLE + y_angle_delta[i], 0])
        spike(SPIKE_DIA, SPIKE_LENGTH + len_delta[i], SPIKE_TOP_LENGTH);
    }
}

module base(width, length, height, angle) {
    if(angle == 0) {
        translate([-length/2, -width/2, 0])
        cube(size = [length, width, height]);
    } else {
        r = (length + width/2) * 360/(2 * angle * 3.1415);
        translate([0, r - width/2, 0])
        rotate([0, 0, 270 - angle/2])
        rotate_extrude(angle = angle, convexity = 10)
        square(size = [r, height]);
    }
}

module mound() {
    seeds = rands(0, 12375764435432, 4, RANDOM_SEED_MOUND);
    x = rands(-LENGTH/2, LENGTH/2, MOUND_CHUNKS, seeds[0]);
    y = rands(-WIDTH/2, WIDTH/2, MOUND_CHUNKS, seeds[1]);
    z = rands(0, HEIGHT, MOUND_CHUNKS, seeds[2]);
    size = rands(1, MOUND_CHUNK_MAX_SIZE, MOUND_CHUNKS, seeds[3]);
    intersection() {
        base(WIDTH, LENGTH, HEIGHT, ANGLE);
        union() {
            for(i = [0:MOUND_CHUNKS/MOUND_CHUNKS_GROUP-1]) {
                hull() {
                    for(j = [0:MOUND_CHUNKS_GROUP-1]) {
                        index = i * MOUND_CHUNKS_GROUP + j;
                        z_delta = z[index] * (WIDTH/2 - abs(y[index]))/(WIDTH/2) - size[index]/2;
                        rotate([0, 0, (x[index] / LENGTH) * ANGLE])
                        translate([x[index], y[index], z_delta])
                        rotate([540*x[index], 389*y[index], 734*z[index]])
                        sphere(d = size[index], $fn = MOUND_CHUNKYNESS);
                    }
                }
            }
        }
    }
}

difference() {
    mound();
    #spikes();
}