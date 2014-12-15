/****\
|  -- Stack class --
|		Quick implementation of a basic LIFO stack
|		with simple push, pop, and peek functionality
|		using generics
\****/
public class Stack<G> // G stands for "Generic"
{
	// create a data type that is aware of the previous guy in line
	private class Node<G>		// made this a class because valac complains when I try
	{							// to use the new operator on it as a struct
		public Node<G> next;
		public G item;
	}
	
	// pointer to the top item on the stack
	private Node<G> top;

	public void Push(G item)
	{
		Node<G> tmp=new Node<G>();
		tmp.next=top;
		tmp.item=item;
		top=tmp;
	}
	
	public G Pop()
	{	
		G item=top.item;
		top=top.next;
		return item;
	}
	
	public G Peek()
	{
		return top.item; // TODO: this is a problem if the stack is empty, isn't it?
	}
}