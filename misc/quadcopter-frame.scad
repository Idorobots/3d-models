$fn = 32;

// --- Main dimensions -------------------------------------------------------
motor_spacing = 90;
frame_thickness = 3; //1.0;
frame_collar_thickness = 0; //2.0;
frame_collar_width = 0.8;

motor_diameter = 10.8;//8.5;
motor_clearance = 0;
motor_bore = motor_diameter + motor_clearance;
motor_collar_id = 14; //motor_diameter;
motor_collar_od = 16;//;motor_diameter + 3;
motor_collar_base_height = 1.5;
motor_collar_height = frame_thickness + frame_collar_thickness; //10;

// Full-height inward-facing split in each motor mount.
motor_slit_width = 2.5;
motor_slit_extra = 1.0;          // guarantees the slit opens through outer wall
motor_slit_bore_overlap = 0.6;   // overlap into bore avoids zero-thickness/tangent cut

// --- Center frame ----------------------------------------------------------
center_width = 29; //30; // 29;
center_height = 55; //57.0; // 55;
center_corner_radius = 2.0;
center_rail_width = 3.5;
center_crossbar_width = center_rail_width - 1;
center_crossbars = 1;

// --- Twin-beam arm geometry ------------------------------------------------
beam_root_spacing = 20.0;
beam_motor_spacing = 4.0;
beam_root_width = center_rail_width + 1;
beam_motor_width = beam_root_width - 1;
beam_root_embed = 6.0;
beam_motor_overlap = 2.0;

mx = motor_spacing/2;
my = motor_spacing/2;
motor_pts = [[ mx, my],[-mx, my],[-mx,-my],[ mx,-my]];

mount_hole_dia = 2;
mount_hole_standoff_dia = 5;
controller_spacing_x = center_width - center_rail_width;
controller_spacing_y = 32;
sensor_spacing_x = 20;
sensor_spacing_y = center_height - center_rail_width;

mount_holes_proto = [
  [-controller_spacing_x/2, -controller_spacing_y/2],
  [-controller_spacing_x/2, controller_spacing_y/2],
  [controller_spacing_x/2, -controller_spacing_y/2],
  [controller_spacing_x/2, controller_spacing_y/2],
  [-sensor_spacing_x/2, -sensor_spacing_y/2],
  [-sensor_spacing_x/2, sensor_spacing_y/2],
  [sensor_spacing_x/2, -sensor_spacing_y/2],
  [sensor_spacing_x/2, sensor_spacing_y/2]/**/
];

controller_spacing_front_alt = 25;
controller_spacing_back_alt = 27;
controller_spacing_y_alt = 49.5;
mount_holes_alt = [
  /*[-controller_spacing_back_alt/2, -controller_spacing_y_alt/2],
  [-controller_spacing_front_alt/2, controller_spacing_y_alt/2],
  [controller_spacing_back_alt/2, -controller_spacing_y_alt/2],
  [controller_spacing_front_alt/2, controller_spacing_y_alt/2]/**/
];

mount_holes = [for(L = [mount_holes_proto,mount_holes_alt], a = L) a];

module rounded_rect_2d(w,h,r){
    hull(){
        for(x=[-w/2+r,w/2-r]) for(y=[-h/2+r,h/2-r])
            translate([x,y]) circle(r=r);
    }
}

module center_outline_2d(){
    rounded_rect_2d(center_width,center_height,center_corner_radius);
}

module center_voids_2d(){
    win_w = center_width - 2*center_rail_width;
    usable_h = center_height - 2*center_rail_width - center_crossbar_width * center_crossbars;
    win_h = usable_h/(center_crossbars + 1);
    win_y = center_crossbar_width + win_h;

    for(i=[0:center_crossbars])
        translate([0,i*win_y-center_height/2+win_h/2+center_rail_width])
        rounded_rect_2d(win_w,win_h,1.35);
}

module tapered_beam_2d(a,b,w_a,w_b){
    hull(){
        translate(a) circle(d=w_a);
        translate(b) circle(d=w_b);
    }
}

// Return the two tangent points from point q to a circle centered at c.
// The tangent circle is inset by half the beam tip width, so the outer edge
// of the tapered beam meets the motor-pod OD approximately tangentially.
function tangent_pts(q,c,r) =
    let(vx=q[0]-c[0], vy=q[1]-c[1], d2=vx*vx+vy*vy, d=sqrt(d2),
        a=r*r/d2, h=r*sqrt(max(0,d2-r*r))/d2,
        bx=c[0]+a*vx, by=c[1]+a*vy,
        ox=-vy*h, oy=vx*h)
    [[bx+ox,by+oy],[bx-ox,by-oy]];

function d2(a,b) = (a[0]-b[0])*(a[0]-b[0]) + (a[1]-b[1])*(a[1]-b[1]);
function embedded_root(anchor,target,embed) =
    let(ddx=target[0]-anchor[0], ddy=target[1]-anchor[1], ll=sqrt(ddx*ddx+ddy*ddy))
    [anchor[0]-ddx/ll*embed, anchor[1]-ddy/ll*embed];

// One pair of beams for a motor in quadrant (sx, sy).
// Beam A exits through the corresponding front/back corner; beam B exits
// through the side rail. At the motor end, each beam terminates on an inset
// tangent circle so its outside edge flows into the motor pod instead of
// entering it at an arbitrary angle.
module corner_twin_arm_2d(sx,sy){
    motor = [sx*mx, sy*my];

    corner_anchor = [sx*center_width/2, sy*center_height/2];
    side_anchor   = [sx*center_width/2,
                     sy*(center_height/2 - beam_root_spacing)];

    // Centerline radius that makes a beam of beam_motor_width approximately
    // tangent to the outside of the pod. A tiny overlap gives a robust union.
    tangent_overlap = 0.0;
    tangent_r = motor_collar_od/2 - beam_motor_width/2 - tangent_overlap;

    ta = tangent_pts(corner_anchor,motor,tangent_r);
    tb = tangent_pts(side_anchor,motor,tangent_r);

    // Choose the tangent branch that keeps the two beams on their natural
    // outer/inner sides and prevents them crossing before reaching the pod.
    // For each root, pick the tangent point closest to the same-side target
    // used by the previous split-arm layout.
    center_ref = [(corner_anchor[0]+side_anchor[0])/2,
                  (corner_anchor[1]+side_anchor[1])/2];
    dx = motor[0]-center_ref[0];
    dy = motor[1]-center_ref[1];
    L = sqrt(dx*dx+dy*dy);
    ux = dx/L;
    uy = dy/L;
    px = -uy;
    py =  ux;

    guide_plus  = [motor[0] + px*beam_motor_spacing/2,
                   motor[1] + py*beam_motor_spacing/2];
    guide_minus = [motor[0] - px*beam_motor_spacing/2,
                   motor[1] - py*beam_motor_spacing/2];

    plus_is_corner = d2(corner_anchor,guide_plus) <= d2(corner_anchor,guide_minus);
    guide_a = plus_is_corner ? guide_plus : guide_minus;
    guide_b = plus_is_corner ? guide_minus : guide_plus;

    motor_a = d2(ta[0],guide_a) <= d2(ta[1],guide_a) ? ta[0] : ta[1];
    motor_b = d2(tb[0],guide_b) <= d2(tb[1],guide_b) ? tb[0] : tb[1];

    root_a = embedded_root(corner_anchor,motor_a,beam_root_embed);
    root_b = embedded_root(side_anchor,motor_b,beam_root_embed);

    tapered_beam_2d(root_a,motor_a,beam_root_width,beam_motor_width);
    tapered_beam_2d(root_b,motor_b,beam_root_width,beam_motor_width);
}

// 2D slit for a motor pod. Local +X is rotated to point from the motor toward
// the coordinate origin, so every slit faces inward and mirrors automatically.
module motor_slit_2d(p){
    inward_x = -p[0];
    inward_y = -p[1];
    ang = atan2(inward_y,inward_x);
    outer_r = motor_collar_od/2;

    slit_start = motor_bore/2 - motor_slit_bore_overlap;
    slit_end = outer_r + motor_slit_extra;
    slit_len = slit_end - slit_start;

    translate(p)
        rotate(ang)
            // Overlaps the bore slightly and extends beyond the pod OD, making
            // a clean open split with no tangent/zero-thickness edge.
            translate([(slit_start + slit_end)/2, 0])
                square([slit_len, motor_slit_width], center=true);
}

module flat_frame_2d(){
    difference(){
        union(){
            center_outline_2d();
            for(sx=[-1,1]) for(sy=[-1,1]) corner_twin_arm_2d(sx,sy);
        }

        center_voids_2d();

        // Motor bores and inward-facing splits are also cut through base.
        for(p=motor_pts){
            translate(p) circle(d=max(motor_bore,motor_collar_id));
            motor_slit_2d(p);
        }
    }
}

module flat_top_2d(){
    difference(){
        union(){
            center_outline_2d();
        }

        center_voids_2d();
    }
}


module motor_collar(p){
    inward_x = -p[0];
    inward_y = -p[1];
    ang = atan2(inward_y,inward_x);
    outer_r = motor_collar_od/2;
    slit_start = motor_bore/2 - motor_slit_bore_overlap;
    slit_end = outer_r + motor_slit_extra;
    slit_len = slit_end - slit_start;

    translate(p)
    difference(){
        cylinder(h=motor_collar_height+0.15,d=motor_collar_od);

        translate([0,0,-0.1])
            cylinder(h=motor_collar_height+0.5,d=motor_bore);

        translate([0, 0, motor_collar_base_height])
        cylinder(h = motor_collar_height, d = motor_collar_id);

        // Same inward-facing slit as the base, extending through the entire
        // raised collar height. Together with flat_frame_2d(), this produces
        // one continuous split from the underside to the very top.
        rotate([0,0,ang])
            translate([(slit_start + slit_end)/2,
                       0,
                       motor_collar_height/2])
                cube([slit_len,
                      motor_slit_width,
                      motor_collar_height+0.6], center=true);
    }
}

module center_frame() {
  difference() {
    linear_extrude(height=frame_thickness + frame_collar_thickness)
    children();

    translate([0, 0, frame_thickness])
    linear_extrude(height=frame_collar_thickness + 0.1)
    difference() {
      offset(r=-frame_collar_width)
      children();
      for(h=mount_holes) {
        translate(h)
        circle(d=mount_hole_standoff_dia);
      }
    }
    for(h=mount_holes) {
      translate([h.x, h.y, -0.1])
      cylinder(d=mount_hole_dia, h=frame_thickness + frame_collar_thickness + 0.2);
    }
  }
}

union(){
    !union() {
      center_frame() flat_frame_2d();
      for(p=motor_pts) motor_collar(p);
    }
    translate([0, 0, 12])
    center_frame() flat_top_2d();
}
