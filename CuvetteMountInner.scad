/******************************
*  Cuvette mount, inner                     *
*     need to confirm dimensions of cuvette *
*****************************/

cuvSize = 12.7;  // size of cuvette
size = [34,30,16];
xy = [1,-1];
holeDia = [2.5,3.5,6]; 
$fa = 6;  // make holes roundish
$fs = 0.8;
//  note: fourHole method changed from original:
//    module set to make holes in xy not xz
//    hole depth set
module fourHole(x, y, dia,depth){   // method for creating four hole pattern
for(a = [0:1],b=[0:1]){
  translate([x/2*xy[a],y/2*xy[b], depth+2])
//    rotate([90,0,0])
   cylinder(2*depth+1,d=dia,center = true);
}    
}

difference(){
    translate([0,0,7.5])
    cube(size, center = true);
    cube([3,10,10],center = true);  // through hole
    translate([0,7,size[2]])
    cube([cuvSize,30,cuvSize*2],center = true);  // main cuvette
   translate([0,7,13])
    cube([5,30,21],center = true);  //  groove to keep from scratching 
    translate([0,0,3])
    fourHole(24,20,holeDia[2],6);
    translate([0,0,-4])
    fourHole(24,20,holeDia[1],8);
    translate([9,5,9])
    cylinder(14,d = holeDia[0], center = true);
    translate([-9,5,9])
    cylinder(14,d = holeDia[0], center = true);
    translate([0,-12,9])
    cylinder(14,d = holeDia[0], center = true);
    
}  // end of difference