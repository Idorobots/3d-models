// Dual 60mm fan adapter, total height 80mm
// Fans bottom, HDD caddy mount holes top

$fn = 64;

// ---------- Parameters ----------
thickness = 2;

fan_size = 60;
fan_gap = 4;

fan_hole_spacing = 50;   // typical 60mm fan screw spacing
fan_screw_dia = 5.2;
fan_cutout_dia = 56;

adapter_height = 75;
corner_radius = 4;

// HDD caddy mount holes
caddy_hole_dia = 4.2;
caddy_hole_pitch = 92;   // left-right spacing
caddy_hole_y = 70;       // height from bottom

// ---------- Derived ----------
adapter_width = fan_size * 2 + fan_gap;

fan1_x = -fan_size/2 - fan_gap/2;
fan2_x =  fan_size/2 + fan_gap/2;
fan_y = fan_size/2;      // fans sit at bottom

// ---------- Helpers ----------
module rounded_rect(w, h, r) {
    hull() {
        translate([-w/2+r, r]) circle(r);
        translate([ w/2-r, r]) circle(r);
        translate([-w/2+r, h-r]) circle(r);
        translate([ w/2-r, h-r]) circle(r);
    }
}

module fan_holes(cx, cy) {
    translate([cx, cy])
        circle(d = fan_cutout_dia);

    for (x = [-fan_hole_spacing/2, fan_hole_spacing/2])
    for (y = [-fan_hole_spacing/2, fan_hole_spacing/2])
        translate([cx + x, cy + y])
            circle(d = fan_screw_dia);
}

// ---------- Model ----------
linear_extrude(height = thickness)
difference() {
    rounded_rect(adapter_width, adapter_height, corner_radius);

    fan_holes(fan1_x, fan_y);
    fan_holes(fan2_x, fan_y);

    // Caddy holes at top: left, center, right
    for (x = [-caddy_hole_pitch/2, 0, caddy_hole_pitch/2])
        translate([x, caddy_hole_y])
            circle(d = caddy_hole_dia);
}
