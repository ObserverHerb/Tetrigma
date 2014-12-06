// Even though I'm only using on/off for now, I'm favoring enum over bool
// because enum will allow me to easily add intermediate states later
enum State {ON,OFF;}

// abstraction of a pattern, the fundamental data type that
// game pieces and moves are made of
struct PatternRow
{
	public State a;
	public State b;
	public State c;
}

struct Pattern
{
	public PatternRow A;
	public PatternRow B;
	public PatternRow C;
}


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

	public GameBoard(Pattern initial_pattern) 
	{
		// create game pieces with an initial state
		Aa=new GamePiece(initial_pattern.A.a);
		Ab=new GamePiece(initial_pattern.A.b);
		Ac=new GamePiece(initial_pattern.A.c);
		Ba=new GamePiece(initial_pattern.B.a);
		Bb=new GamePiece(initial_pattern.B.b);
		Bc=new GamePiece(initial_pattern.B.c);
		Ca=new GamePiece(initial_pattern.C.a);
		Cb=new GamePiece(initial_pattern.C.b);
		Cc=new GamePiece(initial_pattern.C.c);
		
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

/****\
|  -- MoveButton class --
|		A button that sets itself up with a picture of a pattern.
\****/
class MoveButton : Gtk.Button
{
	private GameBoard* move_pattern;
	
	public MoveButton(Pattern pattern)
	{
		move_pattern=new GameBoard(pattern);
		this.add(move_pattern);
	}
	
	~MoveButton()
	{
		delete move_pattern;
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


	// * Create initial patterns
	// TODO: load these from external sources
	var pattern_blank=Pattern()
	{
		A=PatternRow(){a=State.OFF,b=State.OFF,c=State.OFF},
		B=PatternRow(){a=State.OFF,b=State.OFF,c=State.OFF},
		C=PatternRow(){a=State.OFF,b=State.OFF,c=State.OFF}
	};
	var pattern_a=Pattern()
	{
		A=PatternRow(){a=State.ON,b=State.ON,c=State.ON},
		B=PatternRow(){a=State.OFF,b=State.OFF,c=State.OFF},
		C=PatternRow(){a=State.ON,b=State.ON,c=State.ON}
	};
	var pattern_b=Pattern()
	{
		A=PatternRow(){a=State.ON,b=State.OFF,c=State.ON},
		B=PatternRow(){a=State.ON,b=State.OFF,c=State.ON},
		C=PatternRow(){a=State.ON,b=State.OFF,c=State.ON}
	};
	var pattern_c=Pattern()
	{
		A=PatternRow(){a=State.ON,b=State.OFF,c=State.ON},
		B=PatternRow(){a=State.OFF,b=State.ON,c=State.OFF},
		C=PatternRow(){a=State.ON,b=State.OFF,c=State.ON}
	};
	var pattern_d=Pattern()
	{
		A=PatternRow(){a=State.OFF,b=State.ON,c=State.OFF},
		B=PatternRow(){a=State.ON,b=State.ON,c=State.ON},
		C=PatternRow(){a=State.OFF,b=State.ON,c=State.OFF}
	};

		
	// * Create window
	var window=new Gtk.Window();
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
	var game_board=new GameBoard(pattern_blank);
	grid.attach(game_board,0,0,3,3);
	
	// Create buttons that represent moves	
	var move_a=new MoveButton(pattern_a);
	grid.attach(move_a,0,3,1,1);
	var move_b=new MoveButton(pattern_b);
	grid.attach(move_b,1,3,1,1);
	var move_c=new MoveButton(pattern_c);
	grid.attach(move_c,2,3,1,1);
	var move_d=new MoveButton(pattern_d);
	grid.attach(move_d,3,3,1,1);


	/** -- Gtk stuff ending -- **/
	grid.show();
	window.add(grid);
	window.show_all();
	Gtk.main(); // TODO: actually I think this is the main event/message loop
	return 0; //
}