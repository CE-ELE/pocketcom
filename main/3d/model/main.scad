// ┌──────────────────────────────────────┐
// │ pocketcom – 3d base                  │
// └──────────────────────────────────────┘
// v2.2.5
// mit license
// made by CE-ELE

case_w              = 100;
case_h              = 40;
case_d              = 22;
wall                = 2;
radius              = 8;

display_w           = 27;
display_h           = 12;
display_pos         = [10, 6];

button_d            = 5;
button_spacing      = 12;

usb_w                = 9;
usb_h                = 4;
usb_pos              = [case_w - 12, case_h/2 - usb_h/2];

antenna_d            = 5;
antenna_pos          = [case_w - 5, case_h - 5];

solar_w              = 60;
solar_h              = 30;
solar_pos            = [(case_w - solar_w)/2, (case_h - solar_h)/2];





module rounded_box(w, h, d, r) {
    hull() {
        for (x = [0, w - r], y = [0, h - r])
            translate([x, y, 0])
                cylinder(r = r, h = d, $fn=40);
    }
}

module label(txt, pos, size = 4) {
    translate([pos[0], pos[1], 0.2])
        linear_extrude(0.6)
            text(txt, size = size, valign="bottom", halign="left");
}

module pocketshark_modern() {
    difference() {
        // outer shell
        rounded_box(case_w, case_h, case_d, radius);

        // inner cavity
        translate([wall, wall, wall])
            cube([case_w - 2*wall, case_h - 2*wall, case_d - wall]);

        // OLED screen
        translate([display_pos[0], display_pos[1], -1])
            cube([display_w, display_h, case_d + 2]);

        // buttons
        for (i = [0:1])
            translate([display_pos[0] + i * button_spacing, display_pos[1] + display_h + 5, -1])
                cylinder(h = case_d + 2, r = button_d / 2, $fn=30);

        // usb-c port
        translate([usb_pos[0], usb_pos[1], 5])
            cube([usb_w, usb_h, case_d]);

        // antenna hole
        translate([antenna_pos[0], antenna_pos[1], case_d/2])
            rotate([90,0,0])
                cylinder(h = case_h, r = antenna_d / 2, $fn=30);

        // solar panel
        translate([solar_pos[0], solar_pos[1], case_d - 1])
            cube([solar_w, solar_h, 2]);
    }

    // label
    label("PocketShark", [5, case_h - 6], size = 6);
    label("Pantalla", [display_pos[0], display_pos[1] - 4]);
    label("Botones", [display_pos[0], display_pos[1] + display_h + 16]);
    label("USB-C", [usb_pos[0] - 15, usb_pos[1]]);
    label("Antena", [antenna_pos[0] - 18, antenna_pos[1]]);
    label("Placa Solar", [solar_pos[0], solar_pos[1] - 4]);
}

color("grey") pocketshark_modern(); 
