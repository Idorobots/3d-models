thickness = 6;
clamp_height = 22;
clamp_width = 22;
clamp_depth = 28;

height = clamp_height + thickness;
width = clamp_width + 1.5 * thickness;
depth = clamp_depth;

screw_dia = 5;
screw_head_dia = 10;
screw_lip_height = 5;

mount_height = height;
mount_depth = clamp_depth;
mount_width = clamp_depth;


union() {
    difference() {
        cube([depth, width, height]);
        translate([-1, thickness, -1])
            cube([clamp_depth + 2, clamp_width, clamp_height + 1]);
    }
    translate([0, width, 0])
    difference() {
        polyhedron(points = [[0, 0, 0],
                             [0, mount_width, 0],
                             [0, 0, mount_height],
                             [mount_depth, 0, 0],
                             [mount_depth, mount_width, 0],
                             [mount_depth, 0, mount_height]],
                   faces = [[0,1,2],
                            [4,3,5],
                            [0,2,5,3],
                            [4,5,2,1],
                            [0,3,4,1]]);
        union() {
            translate([mount_depth/2, mount_width/2, -1])
                cylinder(d = screw_dia, h = mount_height + 2);
            translate([mount_depth/2, mount_width/2, screw_lip_height])
                cylinder(d = screw_head_dia, h = mount_height +2);
        }
    }
}