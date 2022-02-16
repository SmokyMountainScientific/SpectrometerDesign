
height = 6;
length = 60;
width = 31;

thickness = 3;
hole = [4,4];  
plugWidth = 14;
plugDepth = 4;

$fa = 6;
$fs = 0.8;

module fourHole(x, y, diam){
    xy = [1,-1];
for(a = [0:1],b=[0:1]){
translate([x/2*xy[a],y/2*xy[b],5])
    cylinder(11,d=diam,center = true);
}    
}

 difference(){
 union(){
/*difference(){
cube([length,width,thickness]);  // base
    translate([13,thickness,-1])
    cube([38,25,thickness]);      // cut out from base
}  */
     translate([13,thickness,0])
     cube([38,25,thickness]);
// walls
 translate([13,0,0])
 cube([38,3,height]);
 translate([13,28,0])
 cube([38,3,height]);
 translate([10,3,0])
 cube([3,25,height]);
 translate([51,3,0])
 cube([3,25,height]);

 translate([13,3,0])
 cylinder(height,3,3);
  
  translate([13,28,0])
 cylinder(height,3,3);
  translate([51,3,0])
 cylinder(height,3,3);
  translate([51,28,0])
 cylinder(height,3,3);
 }   // end of union
   // mounting holes in base
 /* translate([4,7,-1])
    cylinder(thickness+2,d = hole[0]);
   translate([4,24,-1])
    cylinder(thickness+2,d = hole[0]));
   translate([57,7,-1])
    cylinder(thickness+2,d = hole[0]));
   translate([57,24,-1])
    cylinder(thickness+2,d = hole[0]));
 */
  translate([13,3,height-8])
   cylinder(9,d=hole[0]);
   translate([13,28,height-8])
   cylinder(9,d=hole[0]);
   translate([51,3,height-8])
   cylinder(9,d=hole[0]);
   translate([51,28,height-8])
   cylinder(9,d=hole[0]);
 //  translate([9+thickness/2,18+thickness - plugWidth/2,height-plugDepth/2])
   translate([9+thickness/2,15.5,height-plugDepth/2])
   cube([3,plugWidth,plugDepth+1], center = true); 
   translate([9+thickness/2,15.5,height-plugDepth/2+2])
   cube([7,9,plugDepth+1], center = true);  // y was 7
   
   
 } 