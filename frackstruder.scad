use <nema17.scad>
use <groovemount.scad>
use <jhead_nozzle_holder.scad>
use <jhead.scad>

$fn = 500;

baseplate_thickness = 10;
baseplate_height = 420;
baseplate_width = 165;

tube_radius = 40;
tube_dia = tube_radius * 2;
tube_height = 100;
tube_wall_thickness = 5;

clamp_height = 77;
clamp_wall_width = 20;
clamp_height = 100;

z_carriage_depth_from_clamp = 87;

collar_wall_thickness = 5;
collar_height = 10;

extruder_base_height = 7;
extruder_gantry_depth = 70;

mounting_bracket_wall_thickness = 5;
mounting_bracket_lengthX = 30;
mounting_bracket_lengthY = 70;
mounting_bracket_lengthZ = 55;

nema17_side = 42.2;

idler_width = 10;
idler_height = 39;
idler_depth = 2;

module l_bracket(wall_thickness, lengthX, lengthY, lengthZ)
{
	translate([wall_thickness, 0, 0])
	{
		cube([lengthX, lengthY, wall_thickness]);
		
		rotate([0,-90,0])
		{
			cube([lengthZ, lengthY, wall_thickness]);
		}
	}
}

module baseplate()
{
	cube([baseplate_thickness,baseplate_width,baseplate_height]);
}

module clamp()
{
	
	difference()
	{
		union()
		{
			translate([tube_dia*0.66,-(tube_dia*1.8)/2,0])
			{
				//clamp+baseplate face
				cube([tube_radius*0.4,tube_dia*1.8,clamp_height]);
			}
			translate([0,-(tube_dia*1.4)/2,0])
			{
				//square clampy bit
				cube([tube_dia*0.66,tube_dia*1.4,clamp_height]);
			}
			//clamp cylinder
			cylinder(r=tube_radius+clamp_wall_width, h = clamp_height);
		}
		
		translate([0,0,-0.5])
		{
			//bit in the middle of the clamp
			cylinder(r=tube_radius, h = clamp_height+1);
		}
	}
}

module tubing()
{
	difference()
	{
		//the tubing
		cylinder(r=tube_radius, h = tube_height);
		//hole in the tubing
		translate([0,0,-0.5])
		{
			cylinder(r=tube_radius-tube_wall_thickness, h = tube_height+1);
		}
	}
	
	//collar to hold tubingin place
	translate([0,0, tube_height - collar_height])
	{
		tubing_collar();
	}
}

module tubing_collar()
{
	difference()
	{
		cylinder(r=tube_radius+collar_wall_thickness, h=collar_height);
		translate([0,0,-0.5])
		{
			cylinder(r=tube_radius, h=collar_height+1);
		}
	}
}

module extruder()
{
	//bit that goes in the tube
	difference()
	{
		cylinder(r=tube_radius-tube_wall_thickness, h = extruder_base_height);
		translate([0,0,-0.5])
		{
			cylinder(r=tube_radius-tube_wall_thickness-5, h = extruder_base_height+1);
		}
	}
	
	//the bits that connect the tube thingy to the gantry
	difference()
	{
		translate([0,0,-(extruder_gantry_depth-nema17_side)])
		{
			cylinder(r=tube_radius-tube_wall_thickness-5, h = (extruder_gantry_depth-nema17_side+extruder_base_height));
		}
		translate([0,0,-(extruder_gantry_depth-nema17_side)-0.5])
		{
			cylinder(r=tube_radius-tube_wall_thickness-10, h = (extruder_gantry_depth-nema17_side+extruder_base_height)+1);
		}
		for(i=[1,-1])
		{
			translate([-40,-20,-50])
			{
				translate([0,i*22.5,0])
				{
					cube([90,40,70]);
				}
			}
		}
	}
	
	//the extruder gantry
	translate([-nema17_side/2,mounting_bracket_wall_thickness/2,-extruder_gantry_depth])
	{
		%Nema17();
		translate([nema17_side/2,-9,nema17_side/2])
		{
			rotate([90,0,0])
			{
				difference()
				{
					cylinder(r=12/2, h=11);
					translate([0,0,6])
					{
						difference()
						{
							cylinder(r=12, h=3);
							cylinder(r=10/2, h=3);
						}
					}
				}
			}
		}
		
		//motor and hotend mount
		difference()
		{
			//mounting bracket
			translate([-(mounting_bracket_lengthY-nema17_side)/2,0,-(mounting_bracket_lengthZ-nema17_side)])
			{
				rotate([0,0,-90])
				{
					l_bracket(mounting_bracket_wall_thickness,mounting_bracket_lengthX,mounting_bracket_lengthY,mounting_bracket_lengthZ);
				}
			}
			//motor axle
			translate( [nema17_side/2,0,nema17_side/2])
			{
				rotate(90,[1,0,0]) 
				{
					cylinder(r = 11.5, h = 2, $fn = 40);
					cylinder(r = 5.2/2.0, h = 20, $fn = 20);
				}
			}
			//bolt holes for nema
			translate([nema17_side/2,0,nema17_side/2])
			{
				for(j=[1:4])
				{		
					rotate(90*j,[0,1,0]) 
					translate([31.04/2.0,0,31.04/2.0]) 
						rotate(-90,[1,0,0]) 
						{
							cylinder(r = 1.5, h = 30, $fn = 20,center=true);
						}
				}
			}
			//bolt holes for hotend
			translate([28.25,0,0])
			{
				for(i=[1,-1])
				{
					translate([i*21.75,-19.2,-18])
					{
						cylinder(r=3/2, h=20);
					}
				}
			}
			//nozzle holder seat
			rotate([0,0,-90])
			{
				translate([16.5,27.5,-(mounting_bracket_lengthZ-nema17_side)-0.1])
				{
					cylinder(r=6.5/2, h=10);
					cylinder(r = 8.05, h = 4.5+0.1);
				}
			}
		}
	}
}

module idler()
{	
	//625zz bearing has dia of 16, bore of 5, height of 5
	
	//base
	difference()
	{
		union()
		{
			cube([idler_width,idler_depth,idler_height/1.7]);
			rotate([0,-90,0])
			{
				translate([18,0,0]) cube([idler_width/2,idler_depth,idler_height/2]);
			}
			translate([-19.5,0,18])
			{
				cube([idler_width/1.5,idler_depth,idler_height/2.1]);
				translate([0,idler_depth,(idler_height/2.1)-6.5])
				{
					difference()
					{
						cube([idler_width/4,4,6.5]);
						translate([-2,0,1]) cube([idler_width,3,5]);
					}
				}
			
			}
			
			//bearing holder
			translate([idler_width/2,idler_depth,idler_height/2])
			{
				rotate([-90,0,0])
				{
					cylinder(r=4.9/2, h=5);
					
					//bearing
					%difference()
					{
						cylinder(r=16/2, h=5);
						translate([0,0,-0.5])
						{
							cylinder(r=5/2, h=6);
						}
					}
				}
			}
			
			//pivot shoulder
			translate([idler_width/2,idler_depth,5.1/2])
			{
				rotate([-90,0,0])
				{
					difference()
					{
						cylinder(r=5.1/2, h=2);
						translate([0,0,-0.05])
						{
							cylinder(r=1.5, h=5.1);
							
						}
					}
					
					//a bunch of washers for illustration
					%for(i=[1:6])
					{
						translate([0,0,-2-(i*1.2)])
						{
							difference()
							{
								cylinder(r=5.1/2, h=1);
								translate([0,0,-0.05])
								{
									cylinder(r=1.5, h=1.1);
									
								}
							}
						}
					}
				}
			}
			
			//fixed thingy to screw into
			translate([-7,0,30])
			{
				difference()
				{
					cube([15,7,7]);
					translate([12,9,3.5])
					{
						rotate([90,0,0])
						{
							cylinder(r=1.5, h=10);
						}
					}
				}
			}
		}
		
		rotate([0,-90,0])
		{
			translate([33.5,3.5,0])
			{
				cylinder(r=1.5, h=30);
			}
		}
	}
	
	
	
	//a bunch of washers for illustration
	%translate([5,2,33.5])
	{
		rotate([-90,0,0])
		{
			for(i=[1:6])
			{
				translate([0,0,-2-(i*1.2)])
				{
					difference()
					{
						cylinder(r=5.1/2, h=1);
						translate([0,0,-0.05])
						{
							cylinder(r=1.5, h=1.1);
							
						}
					}
				}
			}
		}
	}
}

module shroud()
{
	
}

module filament()
{
	cylinder(r=3.0/2, h=400);
}

module display()
{
	translate([-6.5,14,-93])
	{
		%filament();
		translate([0,0,-15])
		{
			%difference()
			{
				union()
				{
					translate([29.75,-14.5,30.75])
					{
						rotate([0,0,90])
						{
							%groove_mount();
						}
					}
					jhead_nozzle_holder();
					translate([-4,-6.5,-8.2])
					{
						jhead_nozzle();
					}
				}
			}
		}
	}

	translate([tube_dia*0.66+tube_radius*0.4,-baseplate_width/2,-z_carriage_depth_from_clamp])
	{
		%baseplate();
	}
	%clamp();
	translate([0,0,-(tube_height-collar_height-clamp_height)])
	{
		tubing();
	}
	translate([0,0,-(tube_height-collar_height-clamp_height)])
	{
		rotate([0,0,180])
		{
			extruder();
		}
		
	}
	translate([-20.5,10,-57])
	{
		idler();
	}
}

display();
