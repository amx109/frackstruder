/* derived from http://reprap.org/mediawiki/images/8/8c/Jhn_nozzle_holder_v5_metric.jpg
 * not an accurate representation - for visual purposes only
 * 
 * NOTE: collar *is* accurately modelled
 */

outer_dia = 16;
groove_mount_dia = 12;
groove_mount_height = 4.6;
groove_mount_offset = 4.8;
length = 40;
nozzle_holder_end_dia = 10;
nozzle_holder_end_height = 1.73;

module jhead_nozzle_holder()
{
	translate([0,0,length])
	{
		rotate([180,0,0])
		{
			difference()
			{
				union()
				{
					cylinder(r=outer_dia/2, h=length-nozzle_holder_end_height);
					translate([0,0,length-nozzle_holder_end_height])
					{
						cylinder(r1=outer_dia/2, r2=nozzle_holder_end_dia/2, h=nozzle_holder_end_height);
					}
				}
				translate([0,0,groove_mount_offset])
				{
					difference()
					{
						cylinder(r=groove_mount_dia,h=groove_mount_height);
						translate([0,0,-0.5])
						{
							cylinder(r=groove_mount_dia/2,h=groove_mount_height+1);
						}
					}
				}
				translate([0,0,-1])
				{
					cylinder(r=6.5/2, h=50);
				}
			}
		}
	}
}

jhead_nozzle_holder();
