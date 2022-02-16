// grating mounts

roll = -3;  // angle

$fa = 6;  // make holes roundish
$fs = 0.8;
////  inner mount (against wall)
difference(){
translate([10,0,2.5])
cube([17,30,5],center = true);
    translate([10,0,6])      // centered on top
    rotate([0,roll,0])
    cube([14,14,6], center = true);  // 3 mm depth
    translate([10,10,3])
    cylinder(8,d=4,center = true);
    translate([10,-10,3])
    cylinder(8,d=4,center = true);
}
//// outer mount (towards mirror)
difference(){
translate([-10,0,2])
cube([16,30,4],center = true);
    translate([-10,0,4])      // centered on top
    rotate([0,roll,0])
    cube([14,14,5], center = true);  // 3 mm depth
    translate([-14,0,0])      // centered 
    rotate([0,roll,0])
    cube([20,12,6], center = true);  // through the block
 //   translate([-18,0,0])
   // cube([5,11,4],center = true);

    translate([-10,10,3])
    cylinder(8,d=2.5,center = true);
    translate([-10,-10,3])
    cylinder(8,d=2.5,center = true);
}