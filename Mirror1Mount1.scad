// mirror 1 mount
xy = [1,-1];
thick = 6;
$fa = 6;
$fs = 0.8;
holeDepth = 4;

difference(){
    translate([0,0,thick/2])
cube([30,30,thick], center = true);
    translate([0,0,thick+1])
    cylinder(2*holeDepth+2,d = 21, center = true);
    for (a=[0:1]){
     for (b=[0:1]){
        translate([0,0,4])
         rotate(90)
         translate([xy[a]*10,xy[b]*10,0])
         cylinder(10,d=4, center = true);
    }   
    }
}
