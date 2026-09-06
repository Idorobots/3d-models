//
// 70 mm to 60 mm fan adapter plate
// Rounded corners
//

$fn = 64;

// Parameters
thickness = 1.5;

outer_size = 70;
corner_radius = 5;

outer_hole_spacing = 61.5; // 70 mm fan standard
inner_hole_spacing = 50.0; // 60 mm fan standard

hole_diameter = 4.3;
airflow_opening = 58;

// Rounded square helper
module rounded_square(size, radius) {
    minkowski() {
        square([size - 2*radius, size - 2*radius], center=true);
        circle(r=radius);
    }
}

difference() {

    // Main plate
    linear_extrude(height = thickness)
    difference() {
        rounded_square(outer_size, corner_radius);

        // Airflow opening
        circle(d = airflow_opening);
    }

    // 70 mm fan mounting holes
    for (x = [-outer_hole_spacing/2, outer_hole_spacing/2])
    for (y = [-outer_hole_spacing/2, outer_hole_spacing/2])
        translate([x, y, -1])
            cylinder(d = hole_diameter, h = thickness + 2);

    // 60 mm fan mounting holes
    for (x = [-inner_hole_spacing/2, inner_hole_spacing/2])
    for (y = [-inner_hole_spacing/2, inner_hole_spacing/2])
        translate([x, y, -1])
            cylinder(d = hole_diameter, h = thickness + 2);
}
