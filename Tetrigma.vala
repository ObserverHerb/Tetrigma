// Even though I'm only using on/off for now, I'm favoring enum over bool
// because enum will allow me to easily add intermediate states later
enum State {ON,OFF;}




//////// ****** --- begin class declarations --- ****** ////////

/****\
|  -- GamePiece class --
|		An EventBox that has a state flag and a Swap function
|		that will toggle it's color and track whether it is on/off
\****/
class GamePiece : Gtk.EventBox
{
	private State state;

	private static Gdk.RGBA ON_COLOR=Gdk.RGBA(){red=0.0,green=0.0,blue=0.0,alpha=1.0};
	private static Gdk.RGBA OFF_COLOR=(Gdk.RGBA(){red=1.0,green=1.0,blue=1.0,alpha=1.0});

	public GamePiece(State initial_state)
	{
		state=initial_state;
		
		if (initial_state==State.ON)
			this.override_background_color(Gtk.StateFlags.NORMAL,ON_COLOR);
		else
			this.override_background_color(Gtk.StateFlags.NORMAL,OFF_COLOR);
	}
}

/****\
|  -- GameBoard class --
|		A grid of 9 GamePieces that make up main playing field
|		and can be used as labels on the buttons to show the
|		configuration the button will trigger
\****/
class GameBoard : Gtk.Grid
{
	public GamePiece* Aa; // TODO: oh c'mon, there has to be some way to get
	public GamePiece* Ab; // all of this on one line
	public GamePiece* Ac;
	public GamePiece* Ba; // per #vala on GIMPnet IRC
	public GamePiece* Bb; // <nemequ> it is too easy to accidentally expose stuff, so we don't allow it
	public GamePiece* Bc;
	public GamePiece* Ca;
	public GamePiece* Cb;
	public GamePiece* Cc;

	public GameBoard(State iAa,State iAb,State iAc, // i stands for 'initial'
		State iBa,State iBb,State iBc,
		State iCa,State iCb,State iCc) 
	{
		// create game pieces with an initial state
		Aa=new GamePiece(iAa);
		Ab=new GamePiece(iAb);
		Ac=new GamePiece(iAc);
		Ba=new GamePiece(iBa);
		Bb=new GamePiece(iBb);
		Bc=new GamePiece(iBc);
		Ca=new GamePiece(iCa);
		Cb=new GamePiece(iCb);
		Cc=new GamePiece(iCc);
		
		// attach them to the grid
		this.attach(Aa,0,0,1,1);
		this.attach(Ab,1,0,1,1);
		this.attach(Ac,2,0,1,1);
		this.attach(Ba,0,1,1,1);
		this.attach(Bb,1,1,1,1);
		this.attach(Bc,2,1,1,1);
		this.attach(Ca,0,2,1,1);
		this.attach(Cb,1,2,1,1);
		this.attach(Cc,2,2,1,1);
		
		// make sure all nine squares are equal size
		this.set_row_homogeneous(true);
		this.set_column_homogeneous(true);
	}
	
	~GameBoard() // call me anal, but I want to do my own deletes
	{
		delete Aa;
		delete Ab;
		delete Ac;
		delete Ba;
		delete Bb;
		delete Bc;
		delete Ca;
		delete Cb;
		delete Cc;
	}
}



//////// ****** --- begin functions --- ****** ////////

/****\
|  -- MAIN --
|		APPLICATION ENTRY POINT
\****/
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

	// Create game board and set initial states of game pieces	
	var game_board=new GameBoard(State.ON,State.OFF,State.OFF,
		State.OFF,State.OFF,State.OFF,
		State.OFF,State.ON,State.OFF);
	grid.attach(game_board,0,0,3,3);
	
	// Create buttons that represent moves	
	var move_a=new Gtk.Button();
	var move_a_pattern=new GameBoard(State.ON,State.ON,State.ON,
		State.OFF,State.OFF,State.OFF,
		State.ON,State.ON,State.ON);
	move_a.add(move_a_pattern);
	grid.attach(move_a,0,3,1,1);
	

	/** -- Gtk stuff ending -- **/
	grid.show();
	window.add(grid);
	//window.add(Aa);
	window.show_all();
	Gtk.main(); // TODO: actually I think this is the main event/message loop
	return 0; //
}