/* model of a jhead taken from http://reprap.org/wiki/J_Head_Nozzle#Version_6


* Material: Brass Bar Stock, 1/2" Square, 1.000" Long
Finished Weight: ~11.3 grams (will need verified)
* On the brass bar stock, find the center of the axis of the nozzle. 
(The axis is centered at 0.250 +-0.001, from one edge, 
and 0.157 -0.000 +0.003 from an adjacent edge.) 
* Turn the threaded end of the nozzle down to 0.3125 +0.000 -0.004.
This section is 0.500 +-0.005 long.
* For the first 0.150 +-0.010, of the threaded section, down to an 
OD of 0.255 (6.5mm) +0.000 -0.002.
* Thread the nozzle to 5/16-24 up to the shoulder of the heater section.
* Drill out the center of the nozzle with a 3.5mm drill bit. 
This will create a heat chamber that is the entire length of the brass nozzle.
* Machine the nozzle tip to the desired profile leaving the heater 
block section 0.325 thick.
* Drill the nozzle orifice.
* Using a size C drill bit, drill the heater resistor hole through the 
heater block section. The remaining brass, between this hole and the 
edge opposite of the melt chamber, should be 0.020 +-0.002 thick.
* 
* 
* 
*/

$fn=50;

heater_width = 12.7;
heater_length = 12.7;
heater_height = 8.225;
heater_hole_radius = 6.147/2;

nozzle_centre_y = 6.35;
nozzle_centre_x = 3.9878;

nozzle_thread_length = 12.7;
nozzle_thread_dia = 7.9375;
nozzle_thread_radius = nozzle_thread_dia/2;

nozzle_thread_start_length = 3.81;
nozzle_thread_start_dia = 6.5;

nozzle_base_height = 0.5;
nozzle_cone_height = 2.5;

heater_hole_wall_gap = 0.508;

module jhead_body()
{
	
}

module jhead_nozzle()
{	
	difference()
	{
		union()
		{
			difference()
			{
				union()
				{
					//threaded cylinder
					translate([nozzle_centre_x,nozzle_centre_y,heater_height])
					{
						cylinder(r=nozzle_thread_dia/2,h=nozzle_thread_length-nozzle_thread_start_length);
					}
					
					//top of threaded cylinder
					translate([nozzle_centre_x,nozzle_centre_y,heater_height+nozzle_thread_length-nozzle_thread_start_length])
					{
						cylinder(r=nozzle_thread_start_dia/2,h=nozzle_thread_start_length);
					}
					
					//heater block
					cube([heater_width, heater_length, heater_height]);

					//extended bit of nozzle head
					translate([nozzle_centre_x,nozzle_centre_y,-nozzle_base_height])
					{
						cylinder(r=nozzle_thread_start_dia/2,h=nozzle_base_height);
					}
					
					//nozzle cone
					translate([nozzle_centre_x,nozzle_centre_y,-nozzle_cone_height-nozzle_base_height])
					{
						cylinder(r1=0,r2=nozzle_thread_start_dia/2,h=nozzle_cone_height);
					}
					
					//sticky out bit at end of nozzle
					translate([nozzle_centre_x,nozzle_centre_y,-nozzle_cone_height-nozzle_base_height])
					{
						cylinder(r=0.5,h=1);
					}
				}
				
				union()
				{
					translate([nozzle_centre_x,nozzle_centre_y,0])
					{
						cylinder(r=3.5/2, h=heater_height+nozzle_thread_length+nozzle_thread_start_length+10);
						translate([0,0,-nozzle_cone_height+0.1])
						{
							cylinder(r1=0,r2=3.5/2,h=nozzle_cone_height);
						}
					}
				}
			}
		}
		
		translate([nozzle_centre_x,nozzle_centre_y,-20])
		{
			cylinder(r = 0.35/2, h = 200);
		}
		
		translate([heater_width-heater_hole_radius-heater_hole_wall_gap,15,heater_height/2])
		{
			rotate([90,0,0])
			{
				cylinder(r = heater_hole_radius, h = 20);
			}
		}
		
		/*/ expose cross section
		translate([-50,7,-12])
		{
			cube([100,100,100]);
		}*/
		
	}
	
}

jhead_nozzle();
