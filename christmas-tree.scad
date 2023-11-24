$fn = 1000;

height = 140;

width = 100;

thickness = 2;

trunk_width = height / 10;

positions = [
    [width * 1, 0, 0],
    [width * 2, 0, 0],
    [width * 3, 0, 0],
    [width * 4, 0, 0],
    [width * 5, 0, 0],
    [width * 6, height / 2, 0],
];

num = len(positions);

angles = rands(0, 360, num, height * width);

linear_extrude(thickness) {
    translate([trunk_width / 2 + 6, 6, 0])
        hanger_trunk(height, trunk_width, thickness);

    translate([trunk_width * 1.333 + 6, height + 6, 0])
        rotate([180, 0, 0])
            left_trunk(height, trunk_width, thickness);

    translate([trunk_width * 1.666 + 6, height + 6, 0])
        rotate([180, 0, 0])
            right_trunk(height, trunk_width, thickness);

    for(i = [1 : 1 : num])
        translate(positions[i-1])
            rotate([0, 0, angles[i-1]])
                layer(i + 4, width * log(10 * i / num));
}

module base_trunk(height, trunk_width, thickness) {
    coords = [
        [0, height],
        [thickness / 2, height],
        [trunk_width / 2, trunk_width / 2],
        [trunk_width / 2 / 3, trunk_width / 2],
        [trunk_width / 2 / 3, 0],
        [0, 0]
    ];
    polygon(coords);
    mirror([1, 0, 0])
        polygon(coords);
}

module hanger_trunk(height, trunk_width, thickness) {
    union() {
        difference() {
            base_trunk(height, trunk_width, thickness);
            translate([-thickness / 2, height - height * 5 / 20, 0])
                square([thickness, height * 2 / 20]);
            translate([-thickness / 2, height - height * 17 / 20, 0])
                square([thickness, height * 2 / 20]);
        }
        translate([0, height + thickness / 2, 0])
            difference() {
                union() {
                    circle(thickness / 2);
                    translate([0, -thickness / 2, 0])
                        square(thickness, center = true);
                }
                circle(thickness / 4);
            }
    }
}

module left_trunk(height, trunk_width, thickness) {
    difference() {
        base_trunk(height, trunk_width, thickness);
        translate([thickness / 2, 0, 0])
            square([trunk_width / 2, height]);
        translate([-thickness / 2, 0, 0])
            square([thickness, height * 3 / 20]);
        translate([-thickness / 2, height - height * 16 / 20, 0])
            square([thickness, height * 12 / 20]);
        translate([-thickness / 2, height - height * 3 / 20, 0])
            square([thickness, height * 3 / 20]);
    }
}

module right_trunk(height, trunk_width, thickness) {
    difference() {
        base_trunk(height, trunk_width, thickness);
        translate([-trunk_width / 2 - thickness / 2, 0, 0])
            square([trunk_width / 2, height]);
        translate([-thickness / 2, 0, 0])
            square([thickness, height * 4 / 20]);
        translate([-thickness / 2, height - height * 15 / 20, 0])
            square([thickness, height * 10 / 20]);
        translate([-thickness / 2, height - height * 4 / 20, 0])
            square([thickness, height * 4 / 20]);
    }
}

module layer (teeth, diameter) {
    tip_radius = diameter / 2;
    echo("tip radius", tip_radius);

    central_angle = 360 / teeth;
    echo("central angle", central_angle);

    // Create a triangle with:
    // bottom length = tip_radius
    // left angle = central_angle / 2
    // right angle = 30 (1/2 equilateral triangle angle)
    // Find the length of the right side
    obtuse_angle = 180 - 30 - central_angle / 2;
    tooth_edge = tip_radius * sin(central_angle / 2) / sin(obtuse_angle);
    root_radius = tip_radius * sin(30) / sin(obtuse_angle);
    echo("tooth side", tooth_edge);

    tooth_height = sqrt(3) * tooth_edge / 2;
    echo("tooth height", tooth_height);

    tooth_radius = tooth_edge / sqrt(3);
    echo("tooth radius", tooth_radius);

    reference_radius = tip_radius - tooth_radius;

    circle(root_radius, $fn = teeth * 2);
    for(i = [1 : 1 : teeth])
        rotate([0, 0, i / teeth * 360])
            translate([reference_radius, 0, 0])
                circle(tooth_radius, $fn = 3);
}
