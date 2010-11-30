package mockdown.display
{
import mockdown.components.VisualNode;

/**
 *	This class recursively renders a tree of nodes onto a view.
 *
 *	@see IRenderObject
 */
public class Renderer
{
	//--------------------------------------------------------------------------
	//
	//	Constructor
	//
	//--------------------------------------------------------------------------
	
	/**
	 *	Constructor.
	 */
	public function Renderer()
	{
		super();
	}


	//--------------------------------------------------------------------------
	//
	//	Properties
	//
	//--------------------------------------------------------------------------
	
	/**
	 *	The class to instantiate for each node when performing a render.
	 */
	public var renderObjectClass:Class;


	//--------------------------------------------------------------------------
	//
	//	Methods
	//
	//--------------------------------------------------------------------------
	
	/**
	 *	Renders a tree of nodes to a render object.
	 *
	 *	@return  The output of the rendering.
	 */
	public function render(node:VisualNode):IRenderObject
	{
		// Throw error if render object class is missing.
		if(renderObjectClass == null) {
			throw new ArgumentError("Render object class must be defined before rendering");
		}

		// If no node is provided then return no output
		if(node == null) {
			return null;
		}
		
		// Render the node
		var object:IRenderObject = new renderObjectClass();
		node.render(object);
		
		// Render children
		for each(var child:VisualNode in node.visualChildren) {
			object.addChild(render(child));
		}
		
		return object;
	}
}
}
