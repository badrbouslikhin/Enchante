// Physical dimensions
loops = 12;
length = 29.6;
width = 30;
copper_width = 0.3;
copper_spacing = 0.3;
thickness = 0.03556;

for(i=[0:loops]) {
    // Bottom half horizontal lines
    // Starting condition
    if(i < 2) {
        translate([0,2*i*copper_spacing,0])
            cube([length - 2*i*copper_spacing,copper_width,thickness]);
    }
    else {
        translate([2*(i-1)*copper_spacing,2*i*copper_spacing,0])
            cube([length - (4*i-2)*copper_spacing,copper_width,thickness]);
    }
    
    // Right half vertical lines
    translate([length-2*i*copper_spacing,2*i*copper_spacing,0])
        cube([copper_width,width - 4*i*copper_spacing,thickness]);
    
    // Top half horizontal lines
    translate([2*(loops-i)*copper_spacing,width-2*(loops-i)*copper_spacing-copper_spacing,0])
        cube([length-4*(loops-i)*copper_spacing,copper_width,thickness]);
    
    // Left half vertical lines
    if(i < 1) {
        translate([0,2*copper_spacing,0])
            cube([copper_width,(width - 2*copper_spacing),thickness]);
    }
    // Last segment must be shorter in order to add the connexion pads
    if(i==loops) {
        translate([2*i*copper_spacing,2*(i+3)*copper_spacing,0])
            cube([copper_width,width-(4*i+6)*copper_spacing,thickness]);
    }
    else {
        translate([2*i*copper_spacing,2*(i+1)*copper_spacing,0])
            cube([copper_width,width-(4*i+2)*copper_spacing,thickness]);
    }  
}
