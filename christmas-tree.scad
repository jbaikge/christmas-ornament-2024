$fn = 20;

// This defines the scale for everything
height = 118;

// How thick to make the pieces
thickness = 2;

// How thick to make the supports
support_thickness = 0.6;

width = height * 3 / 4;
trunk_width = height / 8;

// Needs to be set before positions is defined since we need
// to call diameter()
num = 6;

positions = [
    [
        trunk_width * 3 + diameter(6) / 2,
        diameter(1) / 2
    ],
    [
        trunk_width * 3 + diameter(2) / 2,
        diameter(2) / 2
    ],
    [
        trunk_width * 3.5 + diameter(6) * 0.90,
        height - diameter(3) / 2
    ],
    [
        trunk_width * 3.5 + diameter(6) + diameter(3) * 0.80,
        height - diameter(4) / 2
    ],
    [
        trunk_width * 4 + diameter(6) * 0.90,
        diameter(5) / 2
    ],
    [
        trunk_width * 2.0 + diameter(6) / 2,
        height - diameter(6) / 2
    ],
];

//angles = rands(0, 360, num, 10800);
angles = [174.732, 45, 152.613, 53.7928, 45.1305, 11.5987];

//#square([220, 140]);

// Layers and trunk
translate([thickness * 4, thickness * 4, 0]) {
    difference() {
        linear_extrude(thickness) {
            translate([trunk_width / 2, 0, 0])
                hanger_trunk(height, trunk_width, thickness);

            translate([trunk_width * 1.333, height, 0])
                rotate([180, 0, 0])
                    left_trunk(height, trunk_width, thickness);

            translate([trunk_width * 1.666, height, 0])
                rotate([180, 0, 0])
                    right_trunk(height, trunk_width, thickness);

            // Place layers in a pattern to optimize space
            for(i = [1 : 1 : num])
                translate(positions[i-1])
                    rotate([0, 0, angles[i-1]])
                        layer(i + 4, diameter(i));
        }

        // Place the trunks in the center of each layer and position
        // evenly along the Z axis
        for (i = [1 : 1 : num]) {
            position = [
                positions[i-1][0],
                positions[i-1][1],
                -height * (num - i + 1) / (num + 1),
            ];
            translate(position)
                vertical_trunk(height, trunk_width, thickness);
        }
    }
}

// Outer ring
linear_extrude(thickness) {
    difference() {
        hull() {
            minX = thickness;
            maxX = thickness * 6 + positions[3][0] + diameter(4) / 2;
            minY = thickness;
            maxY = thickness * 4 * 2 + height;
            if(maxX + thickness > 220)
                echo("!!! maxX is outside printable area", maxX);
            // Lower left
            translate([minX, minY, 0])
                circle(thickness);
            // Upper left
            translate([minX, maxY, 0])
                circle(thickness);
            // Upper right
            translate([maxX, maxY, 0])
                circle(thickness);
            // Lower right
            translate([maxX, minY, 0])
                circle(thickness);
        }
        hull() {
            minX = thickness * 3;
            maxX = thickness * 4 + positions[3][0] + diameter(4) / 2;
            minY = thickness * 3;
            maxY = thickness * 3 * 2 + height;
            // Lower left
            translate([minX, minY, 0])
                circle(thickness);
            // Upper left
            translate([minX, maxY, 0])
                circle(thickness);
            // Upper right
            translate([maxX, maxY, 0])
                circle(thickness);
            // Lower right
            translate([maxX, minY, 0])
                circle(thickness);
        }
    }
}

// Supports
color("goldenrod") linear_extrude(support_thickness) {
    // Bottom of main trunk
    translate([
        thickness * 3.5 + trunk_width / 2,
        0
    ])
        square([thickness, thickness * 4]);
    // Through the middle of all trunk pieces
    translate([
        0,
        thickness * 3 + height * 0.50
    ])
        square([thickness * 3 + trunk_width * 2, thickness]);
    // Bottom (top?) of left trunk
    translate([
        thickness * 4 + trunk_width * 1.333 - trunk_width / 3 / 2,
        thickness * 4 + height - 1
    ])
        square([trunk_width / 3 / 2 - thickness / 2, thickness * 4]);
    // Bottom (top?) of right trunk
    translate([
        thickness * 4 + trunk_width * 1.666 + thickness / 2,
        thickness * 4 + height - 1
    ])
        square([trunk_width / 3 / 2 - thickness / 2, thickness * 4]);
    // Bottom of layer #1
    translate([
        thickness * 3.5 + positions[0][0],
        0
    ])
        square([thickness, thickness * 2 + positions[0][1]]);
    // Top of layer #1
    translate([
        thickness * 3.5 + positions[0][0],
        thickness * 5.5 + positions[0][1]
    ])
        square([thickness, diameter(6) / 2]);
    // Bottom of layer #2
    translate([
        thickness * 3.5 + positions[1][0],
        0
    ])
        square([thickness, positions[1][1]]);
    // Top of layer #2
    translate([
        thickness * 3.5 + positions[1][0],
        thickness * 6.0 + positions[1][1]
    ])
        square([thickness, diameter(6) / 2]);
    // Top of layer #6
    translate([
        thickness * 3.5 + positions[5][0],
        trunk_width + positions[5][1]
    ])
        square([thickness, diameter(6) / 2]);
    // Top of layer #4
    translate([
        thickness * 3.5 + positions[3][0],
        positions[3][1] + trunk_width
    ])
        square([thickness, diameter(4) / 2]);
    // Top of layer #3
    translate([
        thickness * 3.5 + positions[2][0],
        positions[2][1] + trunk_width
    ])
        square([thickness, diameter(3) / 2]);
    // Bottom of layer #5
    translate([
        thickness * 3.5 + positions[4][0],
        0
    ])
        square([thickness, diameter(4) / 2]);
    // Custom tri-spiked piece to hold layers 3, 4, and 5 in place
    center_345 = [
        thickness * 3.5 + (positions[4][0] + positions[3][0] + positions[2][0]) / 3,
        thickness * 3.5 + (positions[4][1] + positions[3][1] + positions[2][1]) / 3
    ];
    translate(center_345)
        circle(thickness);
    translate(center_345)
        rotate([0, 0, 60])
            translate([-thickness / 2, 0, 0])
                square([thickness, diameter(3) / 2]);
    translate(center_345)
        rotate([0, 0, 300])
            translate([-thickness / 2, 0, 0])
                square([thickness, diameter(4) / 2 - trunk_width / 2]);
    translate(center_345)
        rotate([0, 0, 180])
            translate([-thickness / 2, 0, 0])
                square([thickness, diameter(5) / 2 - trunk_width / 2]);
}

function diameter(i) = width * i / num;

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
                    circle(thickness / 1.5);
                    translate([0, -thickness / 2, 0])
                        square(thickness, center = true);
                }
                circle(thickness / 3);
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

module vertical_trunk(height, trunk_width, thickness) {
    rotate([90, 0, 0])
        union() {
            linear_extrude(thickness, center = true)
                base_trunk(height, trunk_width, thickness);
            rotate([0, 90, 0])
                linear_extrude(thickness, center = true)
                    base_trunk(height, trunk_width, thickness);
        }
}

/**
 * Uses a bunch of trig to figure out how to make each layer
 *
 * @see https://calcresource.com/geom-ngon.html
 */
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

    //#circle(tip_radius);
    circle(root_radius, $fn = teeth * 2);
    for(i = [1 : 1 : teeth])
        rotate([0, 0, i / teeth * 360])
            translate([reference_radius, 0, 0])
                circle(tooth_radius, $fn = 3);
}
