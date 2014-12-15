//////// ****** --- begin globals --- ****** ////////

// These need to stay consistent as the rest of the interface changes, and they may
// need adjusted to assure that. They move around in the codebase as I'm refactoring,
// so this will allow me to adjust the entire grid in one place
const int GAMEBOARD_X=0; const int GAMEBOARD_Y=0; const int GAMEBOARD_W=3; const int GAMEBOARD_H=3;
const int MOVE_A_X=0; const int MOVE_A_Y=3; const int MOVE_A_W=1; const int MOVE_A_H=1;
const int MOVE_B_X=1; const int MOVE_B_Y=3; const int MOVE_B_W=1; const int MOVE_B_H=1;
const int MOVE_C_X=2; const int MOVE_C_Y=3; const int MOVE_C_W=1; const int MOVE_C_H=1;
const int MOVE_D_X=3; const int MOVE_D_Y=3; const int MOVE_D_W=1; const int MOVE_D_H=1;

// Even though I'm only using on/off for now, I'm favoring enum over bool
// because enum will allow me to easily add intermediate states later
enum State {ON,OFF;}




//////// ****** --- begin class declarations --- ****** ////////

/****\
|  -- Pattern class --
|       Breaking down the rows allows me to refer to a
|       Pattern's 9 blocks with Row.column syntax
\****/
class PatternRow
{
	public State a;
	public State b;
	public State c;
	
	public PatternRow(State initial_a,State initial_b,State initial_c)
	{
		a=initial_a;
		b=initial_b;
		c=initial_c;
	}
}

/****\
|  -- Pattern class --
|		A pattern is a list of state flags that represent
|		the on/off states of the 9 pieces that make up a move
\****/
class Pattern 				// this had to be changed to a class because structs
{							// can't be used with generic types
	public PatternRow A;
	public PatternRow B;
	public PatternRow C;
	
	public Pattern(State Aa,State Ab,State Ac,
					State Ba,State Bb,State Bc,
					State Ca,State Cb,State Cc)
	{
		A=new PatternRow(Aa,Ab,Ac);
		B=new PatternRow(Ba,Bb,Bc);
		C=new PatternRow(Ca,Cb,Cc);
	}

	public bool Compare(Pattern pattern) // vala doesn't support operator overloading
	{									  // so value have to be compared manually
		if ( A.a==pattern.A.a &&
			A.b==pattern.A.b &&
			A.c==pattern.A.c &&
			B.a==pattern.B.a &&
			B.b==pattern.B.b &&
			B.c==pattern.B.c &&
			C.a==pattern.C.a &&
			C.b==pattern.C.b &&
			C.c==pattern.C.c )
		{
			return true;
		}
		else
		{
			return false;
		}
	}
}

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
		Update();
	}
	
	public void Toggle() // switch state and recolor
	{
		if (state==State.ON)
			state=State.OFF;
		else
			state=State.ON;
			
		Update();
	}
	
	private void Update() // color the background according to the state
	{
		if (state==State.ON)
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
	Stack<Pattern> stack; // the stack of moves on the game board
						  // TODO: shouldn't this eventually be static
						  // once I fix peek() in Stack class?

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
		
		// push the first pattern onto the stack
		stack=new Stack<Pattern>();
		stack.Push(initial_pattern); // TODO: this will need to test for an empty stack
									 // before doing this once I make stack static
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
	
	public void Merge(Pattern new_pattern)
	{
		if (new_pattern.A.a==State.ON) {Aa->Toggle();} // TODO: this block should be in the pattern class
		if (new_pattern.A.b==State.ON) {Ab->Toggle();} // as a Toggle() member, not here
		if (new_pattern.A.c==State.ON) {Ac->Toggle();}
		if (new_pattern.B.a==State.ON) {Ba->Toggle();}
		if (new_pattern.B.b==State.ON) {Bb->Toggle();}
		if (new_pattern.B.c==State.ON) {Bc->Toggle();}
		if (new_pattern.C.a==State.ON) {Ca->Toggle();}
		if (new_pattern.C.b==State.ON) {Cb->Toggle();}
		if (new_pattern.C.c==State.ON) {Cc->Toggle();}
		
		// decide whether we're adding or removing a game piece
		// and change stack accordingly
		stdout.printf(stack.Peek().Compare(new_pattern).to_string()+"\n");
		if (stack.Peek().Compare(new_pattern))
		{
			stack.Pop();
			stdout.printf ("Stack popped.\n");
		}
		else
		{
			stack.Push(new_pattern);
			stdout.printf ("Stack pushed.\n");
		}
	}
}

/****\
|  -- MoveButton class --
|		A button that sets itself up with a picture of a pattern.
\****/
class MoveButton : Gtk.Button
{
	private Pattern pattern;
	
	public MoveButton(Pattern load_pattern)
	{
		pattern=load_pattern;
		this.add(new GameBoard(pattern));
	}
	
	~MoveButton()
	{
	}
}

/****\
|  -- Game class --
|		Handles game logic and tracks game state
\****/
class Game
{

	Pattern pattern_blank;
	Pattern pattern_a;
	Pattern pattern_b;
	Pattern pattern_c;
	Pattern pattern_d;
	
	GameBoard board;
	
	MoveButton move_a;
	MoveButton move_b;
	MoveButton move_c;
	MoveButton move_d;
	
	public Game(Gtk.Grid grid)
	{
		// TODO: load these from external sources
		pattern_blank=new Pattern(State.OFF,State.OFF,State.OFF,
										State.OFF,State.OFF,State.OFF,
										State.OFF,State.OFF,State.OFF);
		pattern_a=new Pattern(State.ON,State.ON,State.ON,
									State.OFF,State.OFF,State.OFF,
									State.ON,State.ON,State.ON);
		pattern_b=new Pattern(State.ON,State.OFF,State.ON,
									State.ON,State.OFF,State.ON,
									State.ON,State.OFF,State.ON);
		pattern_c=new Pattern(State.ON,State.OFF,State.ON,
									State.OFF,State.ON,State.OFF,
									State.ON,State.OFF,State.ON);
		pattern_d=new Pattern(State.OFF,State.ON,State.OFF,
									State.ON,State.ON,State.ON,
									State.OFF,State.ON,State.OFF);

		// Create game board and set initial states of game pieces	
		board=new GameBoard(pattern_blank);
		grid.attach(board,GAMEBOARD_X,GAMEBOARD_Y,GAMEBOARD_W,GAMEBOARD_H);
		
		// Create buttons that represent moves	
		move_a=new MoveButton(pattern_a);
		move_a.clicked.connect(()=>{ board.Merge(pattern_a); });
		grid.attach(move_a,MOVE_A_X,MOVE_A_Y,MOVE_A_W,MOVE_A_H);
		move_b=new MoveButton(pattern_b);
		move_b.clicked.connect(()=>{ board.Merge(pattern_b); });
		grid.attach(move_b,MOVE_B_X,MOVE_B_Y,MOVE_B_W,MOVE_B_H);
		move_c=new MoveButton(pattern_c);
		move_c.clicked.connect(()=>{ board.Merge(pattern_c); });
		grid.attach(move_c,MOVE_C_X,MOVE_C_Y,MOVE_C_W,MOVE_C_H);
		move_d=new MoveButton(pattern_d);
		move_d.clicked.connect(()=>{ board.Merge(pattern_d); });
		grid.attach(move_d,MOVE_D_X,MOVE_D_Y,MOVE_D_W,MOVE_D_H);
	}
	
	public void New(int depth)
	{
		// TODO: add code that will use a unique pattern
		// so that we don't accidentally pop creating initial state
		
		// randomly create a stack of patterns
		for (int i=0; i<depth; i++)
		{
			switch (Random.int_range(0,3))
			{
				case 0: board.Merge(pattern_a); break;
				case 1: board.Merge(pattern_b); break;
				case 2: board.Merge(pattern_c); break;
				case 3: board.Merge(pattern_d); break;
			}
		}
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


	// * Create main game
	Game game=new Game(grid);
	game.New(2);

	
	//var label=new Gtk.Label("");
	//grid.attach(label,3,0,1,3);
	// test case to see if operator== works on classes
	//label.set_text(pattern_c.Compare(pattern_e).to_string());
	
	
	

	/** -- Gtk stuff ending -- **/
	grid.show();
	window.add(grid);
	window.show_all();
	Gtk.main(); // TODO: actually I think this is the main event/message loop
	return 0; //
}