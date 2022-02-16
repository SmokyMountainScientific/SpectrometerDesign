
/*******************************
*  WheeTrometerBody-Calc-1
*  OpenSCAD program for generating body
*  and lid for WheeTrometer spectrometer
*  When lid = true, program generates lid
*  When lid is false, program generates body
*********************************/

  lid =true;  // when lid is true, the lid is generated

//  lid =false;  // when lid is false, the body is generated
/********************************
* adjustable variables, get these from OpticsCalc1 program
*  recommended visible parameters:
 GratPos = [-27.950, 4.5198];
 GratAngle = 161;
 Mirror1Pos = [20.4322, 37.4473];
 Mirror1Angle = -86.3085;
 CCDWallPos = [-34.1207, 54.3785];
 CCDAngle = 77.3194;

********************************/

/*GratPos = [-26.5885, 25.1586];
GratAngle = 136;
Mirror1Pos = [18.7462, 45.9926];
Mirror1Angle = 180+87.1395;
CCDWallPos = [-52.2968, 80.0835];
CCDAngle = 53.4107;  */

GratPos = [-25.1661, 24.0068];
GratAngle = 146;
Mirror1Pos = [22.818, 44.254];
Mirror1Angle = 86.7651;
CCDWallPos = [-52.8361, 75.5062];
CCDAngle = 59.4241;

SlitWallPos = [0,0];
SlitWallAngle = 0;
Mirror0Pos = [0,100];          // probably not good to change this
Mirror0Angle = -8;            // dont change this one either


/***************************************
*  End of adjustable Parameters    *
****************************************/

height = 31;      // interior wall height, for external dimension, add 2 x thickness
thickness = 3;

// positions for optical stuff

Posn = [[3+SlitWallPos[0],1.5+SlitWallPos[1],height/2+3],  
    // slit wall position, slit is actually at 0,0
        [Mirror0Pos[0], Mirror0Pos[1]-1.5,height/2+3],  // mirror 0
       // [Pos2[0],Pos2[1],height/2+3],  // grating
        [GratPos[0]+5*cos(GratAngle-90),GratPos[1]+5*sin(GratAngle-90),height/2+3],  // grating
        [Mirror1Pos[0],Mirror1Pos[1],height/2+3],   // mirror 1
        [CCDWallPos[0], CCDWallPos[1],height/2+3]]; // ccd
roughCalc = atan(Posn[2][0]/200);  // half the slit-mirror-grating angle  
Size = [[42,3,height],  //43 slit wall
        [36,12,height],  // mirror 0
        [23,10,height],  // grating
        [75,3,height],  // mirror 1
        [75,3,height]];  // ccd
Angle = [0,  // slit
        Mirror0Angle,  // mirror 1
        GratAngle,  // grating
 //       180+Mirror1Angle,
        Mirror1Angle,
        CCDAngle];  // ccd
         
ccdOffset = 3.2;
$fa = 6;  // make holes roundish
$fs = 0.8;

module fourHole(x, z, dia){   // method for creating four hole pattern
 //   xy = [1,-1];
for(a = [0:1],b=[0:1]){
  translate([x/2*xy[a],5,z/2*xy[b]])
    rotate([90,0,0])
   cylinder(30,d=dia,center = true);
}    
}
module wedge(l,h, angle){
    c = h/tan(angle);
    difference(){
        translate([0,c/2,h/2])
     cube([l,c,h],center = true);
     translate([0,c,0]) 
      rotate([angle,0,0])  
        cube([l+2,2*h*sin(angle),2*c*sin(angle)], center = true);
    }
}

holeDia = [2.5,3.5,6];  
xy = [+1,-1]; // used when multiple holes defined 
xShift = [-1.5,0,0,0,0];  // shift position of mirrors without affecting hole posns
// base polygon  ///
b00 = [Posn[0][0]+xShift[0]-Size[0][0]/2,Posn[0][1]-Size[0][1]/2];  // slit wall
b01 = [Posn[0][0]+xShift[0]+Size[0][0]/2,Posn[0][1]-Size[0][1]/2];
b10 = [Posn[1][0]-(Size[1][0]/2)*cos(Angle[1])+(Size[1][1]/2)*sin(Angle[1]),
        Posn[1][1]-(Size[1][0]/2)*sin(Angle[1])-(Size[1][1]/2)*cos(Angle[1])];
b11 =  [Posn[1][0]+(Size[1][0]/2)*cos(Angle[1])+(Size[1][1]/2)*sin(Angle[1]),
        Posn[1][1]+(Size[1][0]/2)*sin(Angle[1])-(Size[1][1]/2)*cos(Angle[1])];
b12 =  [Posn[1][0]-(Size[1][0]/2)*cos(Angle[1])-(Size[1][1]/2)*sin(Angle[1]),
        Posn[1][1]-(Size[1][0]/2)*sin(Angle[1])+(Size[1][1]/2)*cos(Angle[1])];
b13 =  [Posn[1][0]+(Size[1][0]/2)*cos(Angle[1])-(Size[1][1]/2)*sin(Angle[1]),
        Posn[1][1]+(Size[1][0]/2)*sin(Angle[1])+(Size[1][1]/2)*cos(Angle[1])];
b20 =  [Posn[2][0]+(Size[2][0]/2)*cos(Angle[2])-(Size[2][1]/2)*sin(Angle[2]),
        Posn[2][1]+(Size[2][0]/2)*sin(Angle[2])+(Size[2][1]/2)*cos(Angle[2])];
b21 =  [Posn[2][0]-(Size[2][0]/2)*cos(Angle[2])-(Size[2][1]/2)*sin(Angle[2]),
        Posn[2][1]-(Size[2][0]/2)*sin(Angle[2])+(Size[2][1]/2)*cos(Angle[2])];
b30 =  [Posn[3][0]-(Size[3][0]/2)*cos(Angle[3])+(Size[3][1]/2)*sin(Angle[3]),
        Posn[3][1]-(Size[3][0]/2)*sin(Angle[3])-(Size[3][1]/2)*cos(Angle[3])];
b31 =  [Posn[3][0]+(Size[3][0]/2)*cos(Angle[3])+(Size[3][1]/2)*sin(Angle[3]),
        Posn[3][1]+(Size[3][0]/2)*sin(Angle[3])-(Size[3][1]/2)*cos(Angle[3])];
b42 =  [Posn[4][0]-(Size[4][0]/2)*cos(Angle[4])-(Size[4][1]/2)*sin(Angle[4]),
        Posn[4][1]-(Size[4][0]/2)*sin(Angle[4])+(Size[4][1]/2)*cos(Angle[4])];
b43 =  [Posn[4][0]+(Size[4][0]/2)*cos(Angle[4])-(Size[4][1]/2)*sin(Angle[4]),
        Posn[4][1]+(Size[4][0]/2)*sin(Angle[4])+(Size[4][1]/2)*cos(Angle[4])];

    

thick = [6,6,6,6,6];          // wall thickness to accomodate screws

ConPts = [b01,b30,
         b31,b11,
         b12,b43,     //b10 changed to b12
         b42,b20,
         b21,b00];  // connection points  
if(lid == true){
    h0 = 3;  // height of rails
    th0 = 3;
    echo("lid = true");
    // rail along ccd wall
     rotate([0,180,0])
     translate([Posn[4][0],Posn[4][1],-th0-h0/2])  
    rotate(Angle[4])
    translate([0,-3.5,0])
    cube([50,3,h0],center = true); 
    
    rotate([0,180,0])
 //   translate([Posn[4][0],Posn[4][1],-Posn[4][2]])
    translate([Posn[4][0],Posn[4][1],-3])
    rotate(Angle[4])
    translate([ccdOffset-1,0,-3])
    cube([38,3,6], center = true);
    
  // rail along slit wall  
    rotate([0,180,0])
    translate ([3,5,-th0-h0/2])
    cube([20,2.5,h0],center = true);
    
/*    translate([-6,4.75,3])
    rotate([0,0,180])
    wedge(30,3,60); */
    
    // rail along mirror 2 wall
    rotate([0,180,0])
    translate([Posn[3][0],Posn[3][1],-th0-h0/2])  
    rotate(Angle[3])
    translate([0,3.5,0])
    cube([50,3,h0],center = true);
    
      // rail along mirror 1
    rotate([0,180,0])
    translate([Posn[1][0]-1.5,Posn[1][1]-9,-th0-h0/2])
    rotate(Angle[1])
    cube([30,6,h0], center = true);
    
        // fix problem with slit wall to grating wall connnection
  /*  rotate([0,180,0])
    translate([Posn[0][0],Posn[0][1],-1*thickness/2])
    rotate(Angle[0])
    cube([Size[0][0],Size[0][1],thickness],center = true);  
*/
 
  difference(){
    linear_extrude(height = th0, center= false)
    rotate([0,180,0])
    polygon(points = [b00,b01,b30,b31,b11,b13,b12,  //b10,
      b43,b42,b20,b21]); 
 //  holes   
   signVal = [1,-1,-1,1,-1];
  for(p=[0:4]){
   dx = ConPts[2*p][0]-ConPts[2*p+1][0];  // x distance between points
   dy = ConPts[2*p][1]-ConPts[2*p+1][1];;
   theta0 = atan(dy/dx);  //rotation angle
   d01 = sqrt((pow(dx,2)+pow(dy,2)));  // distance between points
   d04 = sqrt(pow(d01/2,2)+pow(thick[p]/2,2)); // distance to center
   gamma0 = theta0 + atan(thick[p]/d01);
       xPt0 = signVal[p]*d04*cos(gamma0);
       yPt0 = signVal[p]*d04*sin(gamma0);
  
   posn0 = [-1*ConPts[2*p][0]- xPt0,ConPts[2*p][1]+ yPt0,3];
      translate(posn0)
    //   translate([0,0,height/2-3])
      cylinder(100,d=holeDia[1],center = true);  // screw hole
    }  // end of lid mounting holes
  }
}  // end of lid

 
if(lid == false){
difference(){
     union(){

// create base

linear_extrude(height = 3, center= false)
polygon(points = [b00,b01,b30,b31,
         b11,b13,b12,  //b10,  // b10 removed for uv-vis
         b43,b42,b20,b21]); 
   // get points and angles for wall connections, 
  
//   signVal = [1,-1,-1,1];  // add versus subtract position
 /********************************************
 *   Wall Connectors
         note:  ConPts is before lid (line 122)
 ****************************************/
   flip = [180,180,180,0,180];
   extend = [0,4,4,0,3];
   move = [1,0,-4,2,-5];
   for(p=[0:4]){       // for each wall connector
   dx = ConPts[2*p][0]-ConPts[2*p+1][0];  // x distance between points
   dy = ConPts[2*p][1]-ConPts[2*p+1][1];;
   theta0 = atan(dy/dx);  //rotation angle
   d01 = sqrt((pow(dx,2)+pow(dy,2)));  // distance between points
       
   d04 = sqrt(pow(d01/2,2)+pow(thick[p]/2,2)); // distance to center
   gamma = theta0 + atan(thick[p]/d01);
  //     xPt = signVal[p]*d04*cos(gamma);
//       yPt = signVal[p]*d04*sin(gamma);
  
 //  posn = [ConPts[2*p][0]+ xPt,ConPts[2*p][1]+ yPt,3+height/2];
 posn = [ConPts[2*p][0],ConPts[2*p][1],3];
       translate(posn)
       rotate(theta0+flip[p])
       translate([move[p],0,0])
//       cube([d01,thick,height], center = true);  // connector
         cube([d01+extend[p],thick[p],height]);  // connector   
   }  // end of for loop
 
  for(a = [0:4]){
    translate([Posn[a][0]+xShift[a],Posn[a][1],Posn[a][2]])
    rotate(Angle[a])
    cube([Size[a][0],Size[a][1],Size[a][2]],center = true);
    }
//}
   /* translate([Posn[0][0],Posn[0][1],thickness/2])
    rotate(Angle[0])
    cube([Size[0][0],Size[0][1],thickness],center = true);  */
  //  translate([4,3,31])
 //   wedge(40,3,60);
    
}  // end of union
       //// mounting holes along x = 0 axis /////
  translate([0,20,2.5])
        cylinder(3.5,r1=1.5, r2 = 2.5,center = true);
translate([0,20,1.5])
        cylinder(3.5,d = holeDia[1],center = true);

   translate([0,80,2.5])
        cylinder(3.5,r1=1.5, r2 = 2.5,center = true); 
      translate([0,80,1.5])
        cylinder(3.5,d = holeDia[1],center = true); 

 // holes in slit wall
translate([0,0,height/2 + thickness])
rotate([90,0,0])
cylinder(14,d=10,center = true);

// holes for slit mounting screws
translate([0,0,height/2+thickness])
fourHole(24,20,holeDia[0]); // end of slit wall holes

///////// begin modifications for mirror 1
translate([Posn[1][0],Posn[1][1]+4,Posn[1][2]])
    rotate(Angle[1])
    cube([30,8,height+1], center = true); 
translate([Posn[1][0]-1.5,Posn[1][1]-9,Posn[1][2]])
    rotate(Angle[1])
    cube([30,7,height+1], center = true);

translate([Posn[1][0],Posn[1][1],Posn[1][2]])
    rotate(Angle[1])
    rotate([90,0,0])
    cylinder(20,d=18, center = true);
    // mounting screw holes
 
translate([Posn[1][0],Posn[1][1],Posn[1][2]])
   rotate(Angle[1])
fourHole(20,20,holeDia[0]); 
// end of mirror 1 modifications

  // begin modifications for grating
translate([Posn[2][0],Posn[2][1],Posn[2][2]])
    rotate(Angle[2])
    translate([0,-3,0])
    cube([17,8,height+2], center = true);
for (g = [0:1]){
translate([Posn[2][0],Posn[2][1],Posn[2][2]])
   rotate(Angle[2])
   translate([0,5,10*xy[g]])
   rotate([90,0,0])
   cylinder(14,d = holeDia[1], center = true);
translate([Posn[2][0],Posn[2][1],Posn[2][2]])
    rotate(Angle[2])
    translate([0,5,10*xy[g]])
    rotate([90,0,0])
    cylinder(2,d=holeDia[2],center = true);
}  // end of grating modification

    // begin focusing mirror holes
for (g = [0:1]){
translate([Posn[3][0],Posn[3][1],Posn[3][2]])
   rotate(Angle[3])
   translate([-28,-5,10*xy[g]])
   rotate([90,0,0])
   cylinder(14,d = holeDia[1], center = true);  // two holes 
translate([Posn[3][0],Posn[3][1],Posn[3][2]])
   rotate(Angle[3])
   translate([-28,-2,10*xy[g]])
   rotate([90,0,0])
   cylinder(3,d=holeDia[2],center = true);  // counter bore
}
translate([Posn[3][0],Posn[3][1],Posn[3][2]])
   rotate(Angle[3])
   translate([28,-5,0])
   rotate([90,0,0])
   cylinder(8,d=holeDia[2],center = true);  // counter bore
translate([Posn[3][0],Posn[3][1],Posn[3][2]])
   rotate(Angle[3])
   translate([28,-5,0])
   rotate([90,0,0])
   cylinder(14,d=holeDia[1],center = true);  // counter bore

//// begin ccd mods ////////
translate([Posn[4][0],Posn[4][1],Posn[4][2]])
    rotate(Angle[4])
    translate([ccdOffset-1,0,3])
    cube([39,4,height-4], center = true);

translate([Posn[4][0],Posn[4][1],Posn[4][2]])
   rotate(Angle[4])
   translate([ccdOffset,0,0])   // ccdOffset = -8
fourHole(53,18,holeDia[0]); 
// end of ccd modification

   // begin lid mounting holes
   signVal = [-1,-1,-1,1,-1];
for(p=[0:4]){
   dx = ConPts[2*p][0]-ConPts[2*p+1][0];  // x distance between points
   dy = ConPts[2*p][1]-ConPts[2*p+1][1];;
   theta0 = atan(dy/dx);  //rotation angle
   d01 = sqrt((pow(dx,2)+pow(dy,2)));  // distance between points
   d04 = sqrt(pow(d01/2,2)+pow(thick[p]/2,2)); // distance to center
   gamma = theta0 + atan(thick[p]/d01);
       xPt = signVal[p]*d04*cos(gamma);
       yPt = signVal[p]*d04*sin(gamma);
  
   posn = [ConPts[2*p][0]+ xPt,ConPts[2*p][1]+ yPt,3+height/2];
      translate(posn)
       translate([0,0,height/2-3])
      cylinder(10,d=holeDia[0],center = true);  // screw hole
}  // end of lid mounting holes
}
}  // end of if lid is false
//}