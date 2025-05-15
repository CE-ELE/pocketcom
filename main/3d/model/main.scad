/*                              
 * ╔══════════════════════════════════════════════════════════╗
 * ║ Pocketcomm Enclosure v3.0.1                              ║
 * ║ made by CE-ELE                                           ║
 * ╚══════════════════════════════════════════════════════════╝
 *
 * Features:
 * ┌────────────────────────────────────────────────────────┐
 * │ ▪ OLED Display Integration (SSD1306)                   │
 * │ ▪ Dual Button Interface with Custom Caps               │
 * │ ▪ USB Type-C Charging System (TP4056)                  │
 * │ ▪ Solar Panel Power Integration                        │
 * │ ▪ LoRa Wireless Communication Module                   │
 * │ ▪ Built-in Battery Management                          │
 * │ ▪ Advanced Ventilation System                          │
 * └────────────────────────────────────────────────────────┘
 *
 * ═══════════════════════════════════════════════════════════
 * MIT License => Copyright (c) 2025 CE-ELE
 * ═══════════════════════════════════════════════════════════
 */

$fn        = 100;
eps        = 0.01;

// main params
case_w     = 100;    // Width
case_h     = 40;     // Height 
case_d     = 22;     // Depth
wall       = 2;      // Wall thickness
radius     = 8;      // Corner radius

// display config
display_w    = 27.3;   // Width
display_h    = 27.8;   // Height
display_d    = 2.5;    // Depth
display_pos  = [10, 6];

display_mount_d    = 2;
display_active_w   = 21.744;
display_active_h   = 10.864;
display_color      = [0.1, 0.1, 0.4, 1];

// button params
button_d       = 6;    // Diameter
button_h       = 4.3;  // Height
button_cap_d   = 8;    // Cap diameter
button_spacing = 12;
button_pos     = [display_pos[0], display_pos[1] + display_h + 5];
button_colors  = [[0.4, 0.4, 0.4, 1], [0.8, 0.8, 0.8, 1], [0.1, 0.1, 0.1, 1]];

// USB-C port and module
usb_w         = 9;
usb_h         = 3.2;
usb_d         = 7.2;
usb_pos       = [case_w - 12, case_h/2 - usb_h/2];
usb_module_w  = 28;
usb_module_h  = 17;
usb_module_d  = 1.6;
usb_colors    = [[0, 0.3, 0, 1], [0.8, 0.8, 0.8, 1], [0.1, 0.1, 0.1, 1]];

// LoRa config
antenna_d     = 6;
antenna_pos   = [case_w - 5, case_h - 5];
lora_module_w = 16.8;
lora_module_h = 16;
lora_module_d = 3;
lora_colors   = [[0.55, 0.09, 0.09, 1], [0.85, 0.65, 0.13, 1], [0.1, 0.1, 0.1, 1]];

// solar panel setup
solar_w       = 60;
solar_h       = 30;
solar_d       = 2;
solar_pos     = [(case_w - solar_w)/2, (case_h - solar_h)/2];
solar_colors  = [[0, 0, 0.5, 1], [0.25, 0.41, 0.88, 1], [0.44, 0.5, 0.56, 1]];
solar_cells   = [6, 3];
solar_gap     = 1;

// battery parameters
battery_w     = 30;
battery_h     = 40;
battery_d     = 8;
battery_pos   = [15, 5];
battery_colors = [[0.75, 0.75, 0.75, 1], [1, 1, 1, 1], [0.1, 0.1, 0.1, 1]];

// additional features
vent_d        = 1.5;
vent_spacing  = 3;
vent_rows     = 4;
vent_cols     = 8;
vent_pattern  = "grid";
vent_pos      = [case_w - 35, 5];

text_size     = 3;
text_depth    = 0.6;
font_name     = "Liberation Sans:style=Bold";
text_color    = [0.1, 0.1, 0.1, 1];

module rounded_box(w, h, d, r) {
    hull() 
        for(x=[0,w-r], y=[0,h-r]) 
            translate([x,y,0]) 
                cylinder(r=r, h=d);
}

module oled_display() {
    color(display_color)
    difference() {
        cube([display_w, display_h, display_d]);
        for(x=[2, display_w-2], y=[2, display_h-2])
            translate([x, y, -eps]) 
                cylinder(d=display_mount_d, h=display_d+2*eps);
    }
    color([0,0,0,1])
    translate([(display_w-display_active_w)/2, (display_h-display_active_h)/2, display_d-0.1])
        cube([display_active_w, display_active_h, 0.2]);
}

module button(with_cap=true) {
    color(button_colors[0]) 
        cylinder(d=button_d, h=button_h);
    if(with_cap)
        color(button_colors[1])
        translate([0,0,button_h])
        difference() {
            cylinder(d=button_cap_d, h=1);
            translate([0,0,0.8])
                for(i=[0:3]) 
                    rotate([0,0,i*90]) 
                        translate([-0.25,-1.5,0]) 
                            cube([0.5,3,0.3]);
        }
}

module tp4056_module() {
    color(usb_colors[0]) 
        cube([usb_module_w, usb_module_h, usb_module_d]);
    color(usb_colors[1]) 
        translate([(usb_module_w-usb_w)/2, -usb_d, 0]) 
            cube([usb_w, usb_d, usb_h]);
    color(usb_colors[2]) 
        translate([usb_module_w-8, usb_module_h/2-4, usb_module_d]) 
            cube([6, 8, 1]);
}

module solar_panel() {
    color(solar_colors[0]) 
        cube([solar_w, solar_h, solar_d]);
    translate([1,1,solar_d-0.5])
        for(x=[0:solar_cells[0]-1], y=[0:solar_cells[1]-1])
            color(solar_colors[1])
            translate([x*(solar_w-2)/solar_cells[0], y*(solar_h-2)/solar_cells[1], 0])
                cube([(solar_w-2)/solar_cells[0] - solar_gap, 
                     (solar_h-2)/solar_cells[1] - solar_gap, 0.6]);
}

module battery() {
    color(battery_colors[0]) 
        cube([battery_w, battery_h, battery_d]);
    color(battery_colors[1]) 
        translate([1,battery_h/2-8,battery_d-eps]) 
            cube([battery_w-2,16,eps]);
    color(battery_colors[2]) {
        translate([2,battery_h/2,battery_d]) 
            linear_extrude(0.1) 
                text("1000mAh", size=3, halign="left", valign="center");
        translate([2,battery_h/2-4,battery_d]) 
            linear_extrude(0.1) 
                text("3.7V", size=3, halign="left", valign="center");
    }
}

module vent_holes() {
    if(vent_pattern=="grid")
        for(x=[0:vent_cols-1], y=[0:vent_rows-1])
            translate([x*vent_spacing, y*vent_spacing, -eps])
                cylinder(d=vent_d, h=wall + 2*eps);
}

module logo() {
    color([0,0,0,1])
    translate([case_w/2 - 22, case_h/2 - 6, text_depth])
        linear_extrude(text_depth)
            text("PocketCom", size=6, font=font_name);
}

module pocketcom_case() {
    difference() {
        color([0.95, 0.95, 0.95, 1]) 
            rounded_box(case_w, case_h, case_d, radius);
        translate([wall, wall, wall]) 
            cube([case_w - 2*wall, case_h - 2*wall, case_d - wall]);
        
        translate([display_pos[0], display_pos[1], -eps]) 
            cube([display_active_w, display_active_h, wall+2*eps]);
        for(i=[0:1]) 
            translate([button_pos[0] + i * button_spacing, button_pos[1], -eps]) 
                cylinder(d=button_d, h=wall+2*eps);
        translate([usb_pos[0], usb_pos[1], -eps]) 
            cube([usb_w, usb_h, wall+2*eps]);
        translate([antenna_pos[0], antenna_pos[1], -eps]) 
            cylinder(d=antenna_d, h=wall+2*eps);
        translate([solar_pos[0], solar_pos[1], case_d - solar_d]) 
            cube([solar_w, solar_h, solar_d + eps]);
        translate(vent_pos) 
            vent_holes();
        logo();
    }

    translate([wall, wall, wall]) {
        translate(display_pos) 
            oled_display();
        for(i=[0:1]) 
            translate([button_pos[0] + i * button_spacing, button_pos[1], 0]) 
                button();
        translate([usb_pos[0]-10, usb_pos[1]-7, 0]) 
            tp4056_module();
        translate([case_w - 25, case_h - 25, 0]) 
            color(lora_colors[0]) 
                cube([lora_module_w, lora_module_h, lora_module_d]);
        translate(battery_pos) 
            battery();
    }

    translate([solar_pos[0], solar_pos[1], case_d - solar_d]) 
        solar_panel();
}

pocketcom_case();
