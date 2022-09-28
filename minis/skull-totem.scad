RANDOM_SEED_MOUND = 23;
RANDOM_SEED_SPIKES = RANDOM_SEED_MOUND;

SPIKE_DIA = 2.1;
SPIKE_LENGTH = 30;
SPIKE_TOP_LENGTH = 7;
N_SPIKES = 1;

X_BASE_ANGLE = 0;
Y_BASE_ANGLE = 0;

X_ANGLE_RAND = 5;
Y_ANGLE_RAND = 0;
X_RAND = 1;
Y_RAND = 2;
Z_RAND = 2;
LENGTH_RAND = 5;

HEIGHT = 12;
MOUND_DIA = 25;
MOUND_CHUNKYNESS = 6;
MOUND_CHUNK_MAX_SIZE = 15;
MOUND_CHUNKS = 50;
MOUND_CHUNKS_GROUP = 10;

use <toothpick-fortification.scad>;

$fn = 30;

module spikes() {
    seeds = rands(0, 12375764435432, 6, RANDOM_SEED_SPIKES);
    x_delta = rands(-X_RAND, X_RAND, N_SPIKES, seeds[0]);
    y_delta = rands(-Y_RAND, Y_RAND, N_SPIKES, seeds[1]);
    z_delta = rands(0, Z_RAND, N_SPIKES, seeds[2]);
    x_angle_delta = rands(-X_ANGLE_RAND, X_ANGLE_RAND, N_SPIKES, seeds[3]);
    y_angle_delta = rands(-Y_ANGLE_RAND, Y_ANGLE_RAND, N_SPIKES, seeds[4]);
    len_delta = rands(-LENGTH_RAND, LENGTH_RAND, N_SPIKES, seeds[5]);

    for(i = [0:N_SPIKES-1]) {
        d = MOUND_DIA * 0.75;
        x = (i + 1) * d/(N_SPIKES+1) + x_delta[i] - d/2;
        rotate([0, 0, (x / d)])
        translate([x, y_delta[i], z_delta[i]])
        rotate([X_BASE_ANGLE + x_angle_delta[i], Y_BASE_ANGLE + y_angle_delta[i] + x, 0])
        spike(SPIKE_DIA, SPIKE_LENGTH + len_delta[i], SPIKE_TOP_LENGTH);
    }
}

module mound(base_seed = RANDOM_SEED_MOUND) {
    seeds = rands(0, 12375764435432, 4, base_seed);
    r = rands(0, MOUND_DIA/2, MOUND_CHUNKS, seeds[0]);
    theta = rands(0, 360, MOUND_CHUNKS, seeds[1]);
    z = rands(0, HEIGHT, MOUND_CHUNKS, seeds[2]);
    size = rands(1, MOUND_CHUNK_MAX_SIZE, MOUND_CHUNKS, seeds[3]);
    intersection() {
        cylinder(d = 2 * MOUND_DIA, h = HEIGHT);
        union() {
            for(i = [0:MOUND_CHUNKS/MOUND_CHUNKS_GROUP-1]) {
                hull() {
                    for(j = [0:MOUND_CHUNKS_GROUP-1]) {
                        index = i * MOUND_CHUNKS_GROUP + j;
                        z_delta = z[index] * (MOUND_DIA/2 - abs(r[index]))/(MOUND_DIA/2) - size[index]/2;
                        r_delta = r[index] - size[index]/2;
                        rotate([0, 0, theta[index]])
                        translate([r_delta, 0, z_delta])
                        rotate([540*r[index], 389*theta[index], 734*z[index]])
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
