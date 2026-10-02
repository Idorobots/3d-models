/*
  Parametric drive wheel / sprocket for LEGO rubber tread x939 / 43903
  -------------------------------------------------------------------
  Designed from the public LDraw geometry for 43903 and 55982:
    - track width: ~13.6 mm
    - supported wheel radius: ~8.4 mm (16.8 mm OD)
    - internal guide/drive lug: ~2.4 mm max axial width
    - lug projects inward to ~5.9 mm radius when wrapped around the wheel
    - 8 lug positions around a full wheel turn (45 deg pitch)

  The wheel is split axially at the center groove so both halves print flat,
  support-free.  The center groove clears the track's internal lugs, while
  8 small teeth in that groove sit between lugs and provide positive drive.

  Default 3 mm D-shaft assumption:
    round diameter = 3.0 mm
    flat depth     = 0.50 mm  -> 2.50 mm across the D before clearance

  Select output with `part`:
    "male"      = half with alignment pegs
    "female"    = half with alignment holes
    "both"      = both halves laid out for printing
    "assembly"  = assembled preview
    "coupon"    = small D-shaft fit-test coupon
*/

part = "assembly"; // [male,female,both,assembly,coupon]
idler = false;  // D-shaft or round shaft

// ---------- Track / wheel geometry ----------
wheel_radius       = 9;  // 18 mm OD;
wheel_width        = 16;
groove_width       = 3.6;
groove_root_width  = 2.0;
groove_root_radius = 5.50;  // below ~5.9 mm lug-tip radius, with clearance

// Positive-drive teeth in the center groove.
tooth_count        = 7;
tooth_outer_radius = wheel_radius;
tooth_angle        = 8.0;  // track lug gap is roughly 23 deg in the formed LDraw model
tooth_axial_total  = groove_width;
tooth_phase        = 0;

// ---------- Shaft ----------
shaft_d            = 3.50;
shaft_flat_depth   = 0.60;  // 3.0 mm round with 0.5 mm flat -> 2.5 mm D height
shaft_clearance    = 0.08;  // XY clearance per side; tune for your printer/material

// ---------- Half registration ----------
alignment_pins     = true;
peg_d              = 1.70;
peg_length         = 1.00;
peg_hole_clearance = 0.0;  // diametral clearance
peg_radius         = 3.65;
peg_angles         = [18, 137, 251]; // intentionally asymmetric so halves index uniquely

// ---------- Print / tessellation ----------
$fn = 50;
eps = 0.02;

half_width  = wheel_width/2;
groove_half = groove_width/2;
groove_root_half = groove_root_width/2;
tooth_half  = tooth_axial_total/2;

assert(groove_width < wheel_width, "groove_width must be less than wheel_width");
assert(groove_root_radius < tooth_outer_radius, "tooth_outer_radius must exceed groove_root_radius");
assert(tooth_outer_radius <= wheel_radius, "teeth should not exceed support rail radius");
assert(tooth_axial_total <= groove_width, "tooth_axial_total must fit inside groove_width");
assert(peg_radius + (peg_d + peg_hole_clearance)/2 < groove_root_radius,
       "alignment pins must fit inside the center hub/core");

// D-profile: flat is on +X.  For a 3 mm shaft with 0.5 mm flat depth,
// the un-cleared flat lies at x = +1.0 mm from shaft center.
module d_profile_2d() {
    bore_r = shaft_d/2 + shaft_clearance;
    flat_x = shaft_d/2 - shaft_flat_depth + shaft_clearance;
    intersection() {
        circle(r=bore_r);
        translate([-bore_r-eps, -bore_r-eps])
            square([bore_r + flat_x + 2*eps, 2*bore_r + 2*eps]);
    }
}

module d_bore(h) {
    translate([0,0,-eps])
        linear_extrude(height=h + 2*eps)
            d_profile_2d();
}

module bore(h) {
  translate([0, 0, -eps])
    linear_extrude(height=h + 2*eps)
      circle(r=shaft_d/2 + shaft_clearance);
}

// Annular sector for one drive tooth.
module annular_sector(r1, r2, angle, h, steps=12) {
    a0 = -angle/2;
    a1 =  angle/2;
    pts_outer = [for (i=[0:steps])
        let(a=a0 + (a1-a0)*i/steps)
            [r2*cos(a), r2*sin(a)]];
    pts_inner = [for (i=[steps:-1:0])
        let(a=a0 + (a1-a0)*i/steps)
            [r1*cos(a), r1*sin(a)]];
    linear_extrude(height=h)
        polygon(concat(pts_outer, pts_inner));
}

module relieved_half_body() {
    union() {
      cylinder(r=groove_root_radius, h=half_width);
      cylinder(r=wheel_radius, h=half_width-groove_half);
      translate([0, 0, half_width-groove_half])
      cylinder(r1=wheel_radius, r2=groove_root_radius, h=groove_root_half);
    }
}

module drive_teeth() {
    for (i=[0:tooth_count-1])
        rotate([0,0,tooth_phase + i*360/tooth_count])
            translate([0,0,half_width-groove_half])
                annular_sector(
                    groove_root_radius-eps,
                    tooth_outer_radius,
                    tooth_angle,
                    tooth_half+eps
                );
}

module male_pegs() {
    if (alignment_pins)
        for (a=peg_angles)
            rotate([0,0,a])
                translate([peg_radius,0,half_width-eps])
                    cylinder(d=peg_d, h=peg_length+eps, $fn=40);
}

module female_peg_holes() {
    if (alignment_pins)
        for (a=peg_angles)
            rotate([0,0,a])
                translate([peg_radius,0,half_width-peg_length-0.15])
                    cylinder(d=peg_d+peg_hole_clearance,
                             h=peg_length+0.20+eps, $fn=40);
}

module wheel_half(male=true) {
    difference() {
        union() {
            relieved_half_body();
            drive_teeth();
            if (male) male_pegs();
        }

        if(idler) {
          bore(half_width + (male ? peg_length : 0));
        } else {
          d_bore(half_width + (male ? peg_length : 0));
        }
        if (!male) female_peg_holes();
    }
}

// Printable orientation: broad outside face is flat on the bed, mating face up.
module printable_male()   { wheel_half(true); }
module printable_female() { wheel_half(false); }

module assembled() {
    // Male half: outer face at -half_width, mating face at z=0, pegs +Z.
    color([0.80,0.80,0.84])
        translate([0,0,-half_width]) printable_male();

    // Female half mirrored so its mating face is also at z=0.
    color([0.55,0.58,0.62])
        mirror([0,0,1])
            translate([0,0,-half_width]) printable_female();
}

module shaft_coupon() {
    // Fast print for dialing in shaft_clearance before committing to the wheel.
    difference() {
        hull() {
            translate([-4,0,0]) cylinder(d=8, h=4, $fn=48);
            translate([ 4,0,0]) cylinder(d=8, h=4, $fn=48);
        }
        translate([0,0,0]) d_bore(4);
    }
}

if (part == "male") {
    printable_male();
} else if (part == "female") {
    printable_female();
} else if (part == "both") {
    translate([-10,0,0]) printable_male();
    translate([ 10,0,0]) printable_female();
} else if (part == "assembly") {
    assembled();
} else if (part == "coupon") {
    shaft_coupon();
} else {
    echo("Unknown part selector: ", part);
}
