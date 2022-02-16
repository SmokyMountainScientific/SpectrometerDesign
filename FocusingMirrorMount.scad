// focusing mirror mount, mirror size: 50 x 20

$fa = 6;  // make holes roundish
$fs = 0.8;

difference(){
translate([0,0,4])
cube([66.5, 27, 8], center = true);
    translate([0,0,4])
    cube([51,21,10], center = true);
    translate([28,0,4])
    cylinder(10,d = 2.5, center = true);
        translate([-28,-10,4])
    cylinder(10,d = 2.5, center = true);
           translate([-28,10,4])
    cylinder(10,d = 2.5, center = true);
}
translate([-25,0,7])
cube([2,22,2], center = true);
translate([25,0,7])
cube([2,22,2], center = true);