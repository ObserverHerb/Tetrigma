int main(string[] args)
{
	Gtk.init(ref args);
	/** -- Gtk stuff begun -- **/

		
	// * Create window
	var window=new Gtk.Window(); // TODO: Does this need deleted later?
	window.title="Tetrigma";
	window.set_border_width(12);
	window.set_position(Gtk.WindowPosition.CENTER);
	window.set_default_size(350,350);
	window.destroy.connect(Gtk.main_quit); // TODO: what is this?


	// * Set aspect ratio (window needs to stay square)
	Gdk.Geometry geometry=Gdk.Geometry()
	{
		min_aspect=1.0,
		max_aspect=1.0
	};

	window.set_geometry_hints((Gtk.Widget)null,geometry,Gdk.WindowHints.ASPECT);
	

	// * Create main layout layout
	var grid=new Gtk.Grid();
	grid.set_row_homogeneous(true);
	grid.set_column_homogeneous(true);

	// Create game pieces
	var Aa=new Gtk.EventBox(); // TODO: There has to be some way to do this without
	var Ab=new Gtk.EventBox(); // specifying each one individually
	var Ac=new Gtk.EventBox();
	var Ba=new Gtk.EventBox();
	var Bb=new Gtk.EventBox();
	var Bc=new Gtk.EventBox();
	var Ca=new Gtk.EventBox();
	var Cb=new Gtk.EventBox();
	var Cc=new Gtk.EventBox();

	Aa.override_background_color(Gtk.StateFlags.NORMAL,Gdk.RGBA(){red=1.0,green=1.0,blue=1.0,alpha=1.0});
	grid.attach(Aa,0,0,1,1);
	Ab.override_background_color(Gtk.StateFlags.NORMAL,Gdk.RGBA(){red=0.0,green=0.0,blue=0.0,alpha=1.0});
	grid.attach(Ab,1,0,1,1);
	Ac.override_background_color(Gtk.StateFlags.NORMAL,Gdk.RGBA(){red=1.0,green=1.0,blue=1.0,alpha=1.0});
	grid.attach(Ac,2,0,1,1);
	Ba.override_background_color(Gtk.StateFlags.NORMAL,Gdk.RGBA(){red=0.0,green=0.0,blue=0.0,alpha=1.0});
	grid.attach(Ba,0,1,1,1);
	Bb.override_background_color(Gtk.StateFlags.NORMAL,Gdk.RGBA(){red=1.0,green=1.0,blue=1.0,alpha=1.0});
	grid.attach(Bb,1,1,1,1);
	Bc.override_background_color(Gtk.StateFlags.NORMAL,Gdk.RGBA(){red=0.0,green=0.0,blue=0.0,alpha=1.0});
	grid.attach(Bc,2,1,1,1);
	Ca.override_background_color(Gtk.StateFlags.NORMAL,Gdk.RGBA(){red=1.0,green=1.0,blue=1.0,alpha=1.0});
	grid.attach(Ca,0,2,1,1);
	Cb.override_background_color(Gtk.StateFlags.NORMAL,Gdk.RGBA(){red=0.0,green=0.0,blue=0.0,alpha=1.0});
	grid.attach(Cb,1,2,1,1);
	Cc.override_background_color(Gtk.StateFlags.NORMAL,Gdk.RGBA(){red=1.0,green=1.0,blue=1.0,alpha=1.0});
	grid.attach(Cc,2,2,1,1);
	
	
	var button=new Gtk.Button();
	var test=new Gtk.EventBox();
	test.override_background_color(Gtk.StateFlags.NORMAL,Gdk.RGBA(){red=1.0,green=1.0,blue=1.0,alpha=1.0});
	button.add(test);
	grid.attach(button,0,3,1,1);
	

	/** -- Gtk stuff ending -- **/
	grid.show();
	window.add(grid);
	//window.add(Aa);
	window.show_all();
	Gtk.main(); // TODO: actually I think this is the main event/message loop
	return 0; //
}