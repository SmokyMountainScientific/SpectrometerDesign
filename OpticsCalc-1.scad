/*********************************
*  Optics calculator for spherical mirror   *
*   slit at origin
*********************************/
echo("new file");
$fn = 64;
/********************************
* adjustable variables 
********************************/
print = false;

/*************************************
*  visible spectrometer parameters
*    Select either visible or uv-vis parameters
*    Comment out unused parameters
**************************************/
/*
focalLength = 50;  // focusing mirror, mirror 1
wavelength = [611, 546, 435];  // 3 wavelenghts in nm
  // wavelengths are represented in red, green and blue
linesPerMm =1200;   // grating lines per mm
angGratMirrorCt = -14;  // grating position to mirror center
normGratingAngle = -3;  // angle, grating normal to incoming ray
*/

/*************************************
*  uv-vis parameters
**************************************/

focalLength = 75;  // focusing mirror, mirror 1
wavelength = [700, 435, 300];  // 3 wavelenghts in nm
  // wavelengths are represented in red, green and blue
linesPerMm =600;   // grating lines per mm
disGrat = 70;  // 89  distance from collimating mirror to grating surface center,

dGratMirror1 = 32;  // distance from grating to mirror 1
angGratMirrorCt = -10;  //-18 angle, grating position to mirror center
normGratingAngle = -18;  // -28 did not work angle, grating normal to incoming ray
// note:  normGratingAngle and roll angle have different sign


/************************************
* function for finding point on circle where line intersects
* calculation assumes center of circle at origin, translate later
* quadratic equation gives: x = -2mb+/-sqrt((2mb^2-4*(1+m^2)*(b^2-r^2))/2*(1+m^2)
*   (see notebook SJC1 page 108)
***********************************/
 
function pointX0(m, b,f) = (-2*m*b + sqrt((2*m*b)^2-4*(1+m^2)*(b^2-(2*f)^2)))/2/(1+m^2) ;

module line(start, end, thickness = 0.3) {
    color("black")
    hull() {
        translate(start) sphere(thickness);
        translate(end) sphere(thickness);
    }
}
//line([0,0,0], [5,23,42]);
/***************************************
*  variables that you might not want to change
**********************************************
*   slit located at origin
*   surface of colimating mirror on y-axis at focal length from slit
*   Colimating mirror angle set to reflect slit to grating
***************************************/
slitPosn = [0,0];
mirror0Posn = [0,100];   // position of colimating mirror
mirror0Angle = -8;    // angle to reflect light from slit to grating
mirror0Edge = [[mirror0Posn[0]+6*cos(mirror0Angle), mirror0Posn[1]+7*sin(mirror0Angle)],
               [mirror0Posn[0]-6*cos(mirror0Angle),mirror0Posn[1]-7*sin(mirror0Angle)]];
    
/**************************************
*    Grating calculations
**************************************/


nmPerLine = 1000000/linesPerMm;
grating0Angle = 90 + 2*mirror0Angle;  // angle, x vector to grating-mirror 0 vector
gratingAngle = 180+2*mirror0Angle+ normGratingAngle;  // angle between grating and x axis
           
//  physical position of the grating center
gratingSize = [13,6,6];
pGratingPos = [disGrat*sin(2*mirror0Angle),mirror0Posn[1]-disGrat*cos(2*mirror0Angle)];
pGratEdge = [[pGratingPos[0]-gratingSize[0]/2*cos(gratingAngle),pGratingPos[1]-gratingSize[0]/2*sin(gratingAngle)],
    [pGratingPos[0]+gratingSize[0]/2*cos(gratingAngle),pGratingPos[1]+gratingSize[0]/2*sin(gratingAngle)]];
color("black")
translate([pGratingPos[0],pGratingPos[1],0])
cylinder(30,r = 1,center = true);    
dMirrorCt = 2*focalLength-dGratMirror1;
   // distance of grating center to center of circular mirror
gratingPos0 = [dMirrorCt*cos(angGratMirrorCt),dMirrorCt*sin(angGratMirrorCt)];  // position of grating relative to center of circular mirror

/******************************************
*  phi angles:  angle from grating normal
*  theta angles: angles at which different wavelengths leave grating
*     note: when normal grating angle is negative, sin is negative
********************************************/

//theta = [for(a = [0:2]) grating0Angle - asin(wavelength[a]/nmPerLine -
//    sin(normGratingAngle))];
echo("gratingAngle: ",gratingAngle);
LPD = [for(a=[0:2])wavelength[a]/nmPerLine];  // lambda divided by gratings spacing
    echo("lambda / spacing:",LPD);
phi = [for(a = [0:2]) asin(wavelength[a]/nmPerLine + sin(abs(normGratingAngle)))];
    echo("phi",phi);
theta = [for(a = [0:2]) normGratingAngle - phi[a]+grating0Angle];
 //   grating0Angle - asin(wavelength[1]/nmPerLine-sin(normGratingAngle)),
   // grating0Angle - asin(wavelength[2]/nmPerLine- sin(normGratingAngle))];
    
    // uncomment next line to report thega angles
  //  echo("theta values: ",theta);

gratingOuterPosns = 
   [[gratingPos0[0]+gratingSize[0]/2*cos(gratingAngle),gratingPos0[1]+gratingSize[0]/2*sin(gratingAngle)],
   [gratingPos0[0]-gratingSize[0]/2*cos(gratingAngle),gratingPos0[1]-gratingSize[0]/2*sin(gratingAngle)]]; 
   
/**************************************************
*  shift translates positions calculated using 
*    center of focusing mirror as origin
*    use of shifted origin simplifies calculations
***************************************************/
shift = [pGratingPos[0]-gratingPos0[0],pGratingPos[1]-gratingPos0[1]];  // move origin when rendering

difference(){
union(){       
color("white",0.2)
linear_extrude(height = 6, center= true)
polygon(points = [ [0,0],  mirror0Edge[0], mirror0Edge[1]]);

color("white",0.2)
linear_extrude(height = 6, center= true)
polygon(points = [ mirror0Edge[0], pGratEdge[0], pGratEdge[1], mirror0Edge[1]]);
 translate([0,1,0])              
 cube([20,1,6], center = true);
 
 translate([0,100,0])  // mirror 0 represented as cube
 rotate(mirror0Angle)
 cube([20,1,6],center = true);
    

    
     /************************************************
    * find intersection of lines with circle
    *  Lines leave grating center and edges at angle theta    
    *  pointX0 function uses slopes and intercepts for rays 
    ************************************************/
    echo("theta",theta);
     
 slope = [tan(theta[0]),tan(theta[1]),tan(theta[2])];

 intercept = [for(a = [0:2]) [gratingOuterPosns[0][1]-gratingOuterPosns[0][0]*slope[a],
        gratingPos0[1]-gratingPos0[0]*slope[a],
        gratingOuterPosns[1][1]-gratingOuterPosns[1][0]*slope[a]]];
 // echo("intercept: ",intercept);
 
 pX = [for(a = [0:2])[for (b = [0:2]) pointX0(slope[a],intercept[a][b],focalLength)]];
// echo("x values on circle: ",pX);
 
 pointOnCircle = [for(a = [0:2])[for(b=[0:2])[pX[a][b],slope[a]*pX[a][b]+intercept[a][b]]]];
 // echo("points on circle: ",pointOnCircle);
 
//     circle check:  maximum deviation observed:  98.5 mm rather than 100 mm
/*    for(a = [0:2]){
        for(b = [0:2]){
            check = sqrt(pointOnCircle[a][b][0]^2 + sqrt(pointOnCircle[a][b][1]^2));
        echo("Check circle: ",a,b,check);
        }
    }  */
    // end of circle check
 
// slope check:  all slope checks gave ratio = 1
 /*
 for(a = [0:2], b = [0:1]){
     slopeCheck = (pointOnCircle[a][2*b][1]-gratingOuterPosns[b][1])/(pointOnCircle[a][2*b][0]-gratingOuterPosns[b][0]);
     ratio = slopeCheck / slope[a];
     echo("slope check: ",slopeCheck,"slope:",slope[a],"ratio: ",ratio);
 }
 */
 
 slope2 = [for(a = [0:2]) [for(b = [0:2])pointOnCircle[a][b][1]/pointOnCircle[a][b][0]]];   // angle x axis to origin to point on circle
  //echo("slope 2; ",slope2);
 
        // phi is angle between x axis vector and origin to point on circle
phi = [for(a = [0:2])[for(b = [0:2]) atan(slope2[a][b])]];          
   //  echo("phi:", phi);
     

    
    
 slope3 = [for(a = [0:2])[for(b = [0:2]) tan(180+2*phi[a][b]-theta[a])]];    // angle of reflected ray 
 
 //echo("slope 3: ",slope3);
 
intercept3 = [for(a = [0:2])[for(b = [0:2])pointOnCircle[a][b][1]-slope3[a][b]*pointOnCircle[a][b][0]]];  
 //echo("intercept3: ",intercept3);
 
 // have slopes and intercepts for rays leaving focusing mirror
//  focus points are where lines cross
    
focusX = [for(a = [0:2])(intercept3[a][2]-intercept3[a][0])/(slope3[a][0]-slope3[a][2])];
    //,(intercept3[a][0]- slope3[a][0]/slope3[a][2]*intercept3[a][2])/(1-slope3[a][0]/slope3[a][2])]];

focus = [for(a = [0:2])[focusX[a],focusX[a]*slope3[a][0]+intercept3[a][0]]];
//echo("focus: ",focus);

/*****************************************************************
*  Calculate and print out the physical locations of the foci    *
******************************************************************/
pFocus = [for(a = [0:2])focus[a]+shift];
   // echo("physical focal points: ",pFocus);

for(a = [0:2]){
    color("black")
   translate(pFocus[a])
    cylinder(h=10,r=0.25, center = true);
} 

/**************************************************************
*   size, position and slope of detector
*  use locations of outer ray points to locate center, slope
****************************************************************/
 
detectorSize = [29
,2,8];
dWallSize = [60,3,8];
dXShift = 6;  // due to assymmetry of the detector board
detectorWallDepth = -5;  // offset from detector to wall
// detector slope is slope between two outer foci
detectorSlope =(pFocus[0][1]-pFocus[2][1])/(pFocus[0][0]-pFocus[2][0]); 
detectorAngle = atan(detectorSlope);
//echo("detector Angle: ",detectorAngle);
d1Slope =(pFocus[0][1]-pFocus[1][1])/(pFocus[0][0]-pFocus[1][0]);
d1Angle = atan(d1Slope);
//echo("d1angle:",d1Angle);
deltaAngle = detectorAngle - d1Angle;

detAvPos = [(pFocus[0][0]+pFocus[2][0])/2,(pFocus[0][1]+pFocus[2][1])/2];
//echo("detector Average Position: ",detAvPos);

////////////////// something wrong in here? //////////////////////
//////////////////  shiftXY is supposed to move detector toward focus[1] ////
dist01 = sqrt((pFocus[0][1]-pFocus[1][1])^2+(pFocus[0][0]-pFocus[1][0])^2);
//echo("dist02:",dist01);
dist13 = dist01*sin(deltaAngle);
shiftXY = [dist13*sin(detectorAngle+90)*.33,-1*dist13*cos(detectorAngle+90)*.33];
//echo("shiftXY: ",shiftXY);


detectorMeanPosn = detAvPos+shiftXY;
//echo("detector Mean Posn:",detectorMeanPosn);

//translate(shift)
translate(detectorMeanPosn)
rotate(detectorAngle)
color("black")
cylinder(h = 15, r = 0.5, center = true);
translate(detectorMeanPosn)
rotate(detectorAngle)
cube(detectorSize,center = true);

dWallShift = [detectorWallDepth*cos(detectorAngle-90),detectorWallDepth*sin(detectorAngle-90)];
//angle1 = detectorAngle-90;
//dWallShift = [0,0,0];
detectorWallPosn = detectorMeanPosn + dWallShift;
//translate(detectorWallPosn)
translate(detectorMeanPosn)
rotate(detectorAngle)
//translate([dXShift,0,0])
translate([0,-detectorWallDepth,0])
color("black")
cylinder(h=15,r = 0.5, center = true);
// error here
translate(detectorWallPosn)
rotate(detectorAngle)
cube(dWallSize, center = true);
// true detector position
/*translate(detectorMeanPosn)
rotate(detectorAngle)
translate([0,-detectorWallDepth,0])
cube(dWallSize,center = true);*/
//echo("CCDWallPos ",detectorWallPosn);  //line 233
//echo("CCDAngle",detectorAngle);

/***************************************************
*  render mirror 1, focusing mirror
*    calculated position and angle.
******************************************************/
mirrorSize = [50,6,8];
wallSize = [68,3,8];
depthM =2.5;  // depth of grinding cut on mirror
dMShift = mirrorSize[1]/2-depthM;
m1WallShift = 9;  // distance from average point to wall
point0 = pointOnCircle[0][2]+shift;
point1 = pointOnCircle[2][0]+shift;
// use black cylinders to locate positions on mirror
   color("black")
    translate(point0)
    cylinder(h=10,r=0.25, center = true);
   color("black")
    translate(point1)
    cylinder(h=10,r=0.25, center = true);
avX = (point0[0]+point1[0])/2;
avY = (point0[1]+point1[1])/2;
mirror1Slope = (point0[1]-point1[1])/(point0[0]-point1[0]);
backAngle = atan(-1/mirror1Slope);
mirrorShift = [dMShift*cos(backAngle),dMShift*sin(backAngle)];
m1PosShift = [m1WallShift*cos(backAngle),m1WallShift*sin(backAngle)];
mirror1Pos = [avX,avY,0]+mirrorShift;
mirror1Angle = atan(mirror1Slope);
m1WallPos = [avX,avY,0]+m1PosShift;

difference(){
    translate(mirror1Pos)
    rotate(mirror1Angle)
    cube(mirrorSize,center = true);
    translate(shift)
    cylinder(h = 10, r=2*focalLength, center= true);
}

translate(m1WallPos)
rotate(mirror1Angle)
cube(wallSize,center = true);
//echo("Mirror1Pos",m1WallPos);  // moved from line 275
//echo("Mirror1Angle",mirror1Angle);

/*********************************************************
*  begin rendering rays
**********************************************************/

rays = ["red","green","blue"];  // colors for ray paths
h =8;
 for(a = [0:2]){
color(rays[a],0.3)
translate([shift[0],shift[1],0])
linear_extrude(height = h, center= true)
//polygon(points = [circlePosns[0],circlePosns[1],circlePosns[2]]);
polygon(points = [   //[0,0],
    gratingOuterPosns[0],
    pointOnCircle[a][0],
    pointOnCircle[a][1],
    pointOnCircle[a][2],
    gratingOuterPosns[1]]);
    
    color(rays[a],0.3)
translate([shift[0],shift[1],0])
linear_extrude(height = h, center= true)
//polygon(points = [circlePosns[0],circlePosns[1],circlePosns[2]]);
polygon(points = [   //[0,0],

    pointOnCircle[a][0],
    pointOnCircle[a][1],
    pointOnCircle[a][2],
    focus[a]]);

}  // end of a loop
   

translate(gratingPos0)
translate([shift[0],shift[1],0])
rotate(gratingAngle)
translate([0,gratingSize[1]/2,0])
cube(gratingSize, center = true);

/************************************
*   grating wall calcs
*********************************/
gratOffset = gratingSize[1]+4.5; // thickness of grating + inner mount
gratShift = [gratOffset*sin(-1*gratingAngle),gratOffset*cos(-1*gratingAngle)];
gratWallPos = gratingPos0+gratShift+shift;
translate(gratWallPos)
rotate(gratingAngle)
cube([20,3,6], center = true);

echo("GratPos",gratWallPos);
echo("GratAngle ",gratingAngle);
echo("Mirror1Pos",m1WallPos);  // moved from line 275
echo("Mirror1Angle",mirror1Angle);
echo("CCDWallPos ",detectorWallPosn);  //line 233
echo("CCDAngle",detectorAngle);
} // end of union
/*if(print){
    // cut grating
translate(gratingPos0)
translate([shift[0],shift[1],0])
rotate(gratingAngle)
cube([gratingSize[0]+2,gratingSize[1]+2,gratingSize[2]+2], center = true);
    // cut slit
 translate([0,1,0])              
 cube([22,5,17], center = true);     // slit
    // cut mirror0
    translate([0,100,0])
 rotate(-1*mirror0Angle)
 cube([22,3,17],center = true);
}  */
}  // end of difference

