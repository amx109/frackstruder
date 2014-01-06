/* groovemount for jhead nozzle holder v5
 * http://reprap.org/mediawiki/images/8/8c/Jhn_nozzle_holder_v5_metric.jpg
 * 
 * based on http://reprap.org/wiki/Mounting_plate
 */
$fn=50;

groovemount_radius = 6.1;
groovemount_height = 4.4;
groovemount_width = 69.85;
groovemount_depth = 29.85;

jhead_displacement_x = 14.605;
jhead_displacement_y = 29.718;

screw_slot_depth = 5.1562;
screw_slot_width = 12.7;

module screw_slot()
{
	union()
	{
		translate([screw_slot_depth/2,screw_slot_depth/2,0])
		{
			cylinder(r=screw_slot_depth/2, h=groovemount_height+1);
		}
		translate([0,screw_slot_depth/2,0])
		{
			cube([screw_slot_depth,screw_slot_width-screw_slot_depth,groovemount_height+1]);
		}
		translate([screw_slot_depth/2,(screw_slot_depth/2)+screw_slot_width-screw_slot_depth,0])
		{
			cylinder(r=screw_slot_depth/2, h=groovemount_height+1);
		}
	}
}
module groove_mount()
{
	difference()
	{
		cube([groovemount_depth,groovemount_width,groovemount_height]);
		
		translate([jhead_displacement_x,jhead_displacement_y-groovemount_radius,-0.5])
		{
			cube([groovemount_radius*3,groovemount_radius*2,groovemount_height+1]);
		}
		translate([jhead_displacement_x,jhead_displacement_y,-0.5])
		{
			cylinder(r = groovemount_radius, h = groovemount_height+1);
		}
		
		translate([14.6,-1.27,-0.5])
		{
			screw_slot();
		}
		
		translate([14.6,49.53,-0.5])
		{
			screw_slot();
		}
	}
}
