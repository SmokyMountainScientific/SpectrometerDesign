/************************************
*  CuvetteMountOuter
*    connection for fiber optic to inner Cuvette mount
*    consistes of mount and spacer.  
*    5 mm ball lens goes in mount, spacer on top
*    Flanged sma905 connector screws to that
************************************/
pSpacer = false;

width = 34;
depth = 30;
xy = [1,-1];
xVal = 12;  // mounting hole dimensions
yVal = 10;
diam = 10;
spacer = 1;
ballDepth = 3.5;

holeDiam = [2.5,4];

$fa = 6;  // make holes roundish
$fs = 0.8;

module fourHole(x, y, dia, angle){
 //   xy = [1,-1];
for(a = [0:1],b=[0:1]){
    rotate([0,0,angle])
translate([x/2*xy[a],y/2*xy[b],5])
    cylinder(11,d=dia,center = true);
}    
}
if(pSpacer == true){
    difference(){
    translate([0,25,spacer/2])
     cube([14, 14,spacer], center = true);
        translate([0,25,0])
    fourHole(8.6,8.6,holeDiam[1],0);
         translate([0,25,4])
 cylinder(10,d=4,center = true); 
    }
}
else{
difference(){
 union(){
  translate([0,0,1.5])
  cube([width,depth,3],center = true);
          rotate([0,0,45])
  translate([0,0,5])
    cube([14, 14,6], center = true);
  
    }  // end of union
 
//  fourHole(2*xVal,2*yVal,holeDiam[1],0); 
  fourHole(8.6,8.6,holeDiam[0],45);

 translate([0,0,9-ballDepth/2])
 cylinder(ballDepth+1,d=5.5,center = true);  //top cylinder to put ball in
 translate([0,0,8-ballDepth/2])
 sphere(d=5.5);
 translate([0,0,4])
 cylinder(10,d=4,center = true);

        translate([9,5,0])
    cylinder(14,d = 4, center = true);
    translate([-9,5,0])
    cylinder(14,d = 4, center = true);
    translate([0,-12,0])
    cylinder(14,d = 4, center = true);
    translate([0,-12,10])
    cylinder(14,d = 6, center = true);
  translate([0,6,0])
  //rotate([0,45,0])
  cube([3.,20,1.],center = true);  //  groove to keep from scratching  
  translate([1.5,6,-1])
  rotate([0,45,0])
  cube([2.,20,2.],center = true); 
  translate([-1.5,6,-1])
  rotate([0,45,0])
  cube([2.,20,2.],center = true); 
}
}