
clearance_diff = 0.0; // 0.01
tip_length = 1.5; // 0.1
tip_diff = 0.2; // 0.01
hook_length = 30;
hook_height = 10;
stopper_height = 1.5; // 0.1

top_diff = 1.0; // 0.1

/* [Hidden] */

L_GRID = 42.0;

// height: 13.4 - 0.3
STANDARD_HEIGHT = 13.1;

// distance between two horizontal hexagons
H_DISTANCE = 40.88;

GH_DIFF = L_GRID - H_DISTANCE;
PLUG_LENGTH = 10;

module hswPlug(
    clearance_diff = 0.0,
    tip_length = 1.5,
    tip_diff = 0.2,
    height = STANDARD_HEIGHT,
    length = PLUG_LENGTH,
    align_rtl = false
) {
    hsw_h = height - clearance_diff;
    z = hsw_h/2;
    r = z/cos(30);
    main_length = length - tip_length;
    rotate_angle = align_rtl ? 90: -90;
    translate([0, 0, z])
    rotate([rotate_angle, 0, 0]) {
        cylinder(h=main_length, r=r, $fn=6);
        translate([0, 0, main_length])
            cylinder(h=tip_length, r1= r, r2 = r-tip_diff, $fn=6);
    }

}

module bendingPart(
    radius
) {
    rotate_extrude(angle=90) {
        translate([radius,0, 0])
        rotate([0, 0, 90])
        circle(r = radius, $fn=6);
    }
}


module hswHook(
    clearance_diff = 0.0,
    tip_length = 1.5,
    tip_diff = 0.2,
    stopper_height = 0.5,
    hook_length = 30,
    hook_height = 10,
    top_diff = 2.0
){
    hsw_h = STANDARD_HEIGHT - clearance_diff;
    z = hsw_h/2;
    r = z/cos(30);
    translate([0, -r, 0])
    hswPlug(
        clearance_diff = clearance_diff,
        tip_length = tip_length,
        tip_diff = tip_diff,
        length = PLUG_LENGTH + hook_length + r
    );
    

    
    // insert stopper
    l = r*sin(30);
    stopper_points = [
        [-l, 0, 0], 
        [-l+stopper_height, 0, stopper_height],
        [l-stopper_height, 0, stopper_height],
        [l, 0, 0],
        [l, -stopper_height, 0],
        [-l, -stopper_height, 0]
    ];
    stopper_faces = [[0, 3, 2, 1], [0, 5, 4, 3], [0,1,5], [2,3,4], [1,2,4,5]];
    translate([0, hook_length, hsw_h])
    polyhedron(points = stopper_points, faces = stopper_faces);


    // hook top
    translate([0, -r, z])
    cylinder(h = hook_height+r-top_diff, r=r, $fn=6);
    translate([0, -r, z + hook_height+r-top_diff])
    cylinder(h = top_diff, r1 = r, r2 = r-top_diff, $fn=6);
    
    // connecting parts
    intersection() {
        translate([0, -r-z, 0])
        hswPlug(
            clearance_diff = clearance_diff,
            tip_length = 0,
            tip_diff = 0,
            length = PLUG_LENGTH + hook_length + r + z
        );
        translate([0, -r, 0])
        cylinder(h = hook_height+r+z, r=r, $fn=6);
        
        translate([-20, 0, r+z])
        rotate([0,90,0])
        cylinder(h = r+z+40, r = 18);
    }
}

hswHook(
    clearance_diff = clearance_diff,
    tip_length = tip_length,
    tip_diff = tip_diff,
    stopper_height = stopper_height,
    hook_length = hook_length,
    hook_height = hook_height,
    top_diff = top_diff
);



module hswPlugArray(
    gridx, gridy, 
    align = false,
    align_rtl = false,
    align_offset = 0.0,
    align_n_grid = 0.0,
    plug_tolerance = 8.0,
    clearance_diff = 0.0,
    tip_length = 1.5,
    tip_diff = 0.2
) {
    base_start_x = - gridx * L_GRID / 2;
    base_end_x = -base_start_x;
    x_lower = base_start_x + plug_tolerance;
    x_upper = -x_lower;
    centered_start_x = - (gridx-1) * H_DISTANCE / 2;

    offset = align_offset + align_n_grid * L_GRID % H_DISTANCE;
    echo(str("offset: ", offset));
    align_start_x = base_start_x - offset + H_DISTANCE;
    
    start_x = align ? align_start_x : centered_start_x;
    //echo(str("start_x: ", start_x));
    align_sign = align_rtl ? -1 : 1;
    y = align_sign * gridy * L_GRID / 2;
    for(i = [0: gridx]) {
        x = start_x + i * H_DISTANCE;
        if (x_lower<x && x<x_upper) {
            translate([x, y, 0])
                hswPlug(
                    clearance_diff=clearance_diff,
                    tip_length=tip_length, 
                    tip_diff=tip_diff,
                    align_rtl=align_rtl
                );
        }
    } 
}

//module testPlugArray(align_rtl = false) {
//    hswPlugArray(10,1, align_rtl=align_rtl);
//    hswPlugArray(10,2, align_rtl=align_rtl, align=true);
//    hswPlugArray(10,3, align_rtl=align_rtl, align=true, align_offset=20.44);
//    hswPlugArray(10,4, align_rtl=align_rtl, align=true, align_n_grid=5);
//
//    hswPlugArray(11,11, align_rtl=align_rtl);
//    hswPlugArray(11,12, align_rtl=align_rtl, align=true);
//    hswPlugArray(11,13, align_rtl=align_rtl, align=true, align_offset=20.44);
//    hswPlugArray(11,14, align_rtl=align_rtl, align=true, align_n_grid=5);
//}
//color("red") testPlugArray(false);
//color("blue") testPlugArray(true);


