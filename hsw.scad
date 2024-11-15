
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
    tip_diff = 0.2
) {
    hsw_h = STANDARD_HEIGHT - clearance_diff;
    r = hsw_h/2/cos(30);
    z = hsw_h/2;
    main_length = PLUG_LENGTH - tip_length;
    translate([0, 0, z])
    rotate([-90, 0, 0]) {
        cylinder(h=main_length, r=r, $fn=6);
        translate([0, 0, main_length])
            cylinder(h=tip_length, r1= r, r2 = r-tip_diff, $fn=6);
    }

}

module hswPlugArray(
    gridx, gridy, 
    align = false,
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
    
    //echo(str("offset: ", offset));
    align_start_x = base_start_x + offset;
    
    start_x = align ? align_start_x : centered_start_x;
    //echo(str("start_x: ", start_x));
    y = gridy * L_GRID / 2;
    for(i = [0: gridx]) {
        x = start_x + i * H_DISTANCE;
        if (x_lower<x && x<x_upper) {
            translate([x, y, 0])
                hswPlug(
                    clearance_diff=clearance_diff, 
                    tip_length=tip_length, 
                    tip_diff=tip_diff
                );
        }
    } 
}

// hswPlug();
hswPlugArray(10,1);
hswPlugArray(10,2, align=true);
hswPlugArray(10,3, align=true, align_offset=20.44);
hswPlugArray(10,4, align=true, align_n_grid=5);
// no negative align_n_grid support
//hswPlugArray(10,5, align=true, align_n_grid=-10);

hswPlugArray(11,11);
hswPlugArray(11,12, align=true);
hswPlugArray(11,13, align=true, align_offset=20.44);
hswPlugArray(11,14, align=true, align_n_grid=5);
//hswPlugArray(11,15, align=true, align_n_grid=-10);
