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
	

	// *

	

	/** -- Gtk stuff ending -- **/
	window.show_all();
	Gtk.main(); // TODO: actually I think this is the main event/message loop
	return 0;
}