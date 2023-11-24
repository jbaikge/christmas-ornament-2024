$fn = 1000;

height = 140;

thickness = 2;

positions = [
    [height * 1, 0, 0],
    [height * 2, 0, 0],
    [height * 3, 0, 0],
    [height * 4, 0, 0],
    [height * 5, 0, 0],
    [height * 6, 0, 0],
];

num = len(positions);

angles = rands(0, 360, num, height);

echo("height", height, "num", num, "diameter", height * 1 / num);

linear_extrude(thickness) {
    for(i = [1 : 1 : num])
        translate(positions[i-1])
            rotate([0, 0, angles[i-1]])
                layer(i + 4, height * (i / num));
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
