
thick  = 3;

module fourHole(x, y, dia){   // method for creating four hole pattern
    xy = [1,-1];
for(a = [0:1],b=[0:1]){
  translate([x/2*xy[a],y/2*xy[b],0])
   
   cylinder(30,d=dia,center = true);
}    
}

difference(){
    cube([60,29,thick], center = true);
    translate([2,0,0])
    cube([45,15,10],center = true);
    cube([40,20,10],center = true);
    fourHole(53,18,4);
}