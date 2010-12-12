package mockdown.display
{
import mockdown.components.Node;

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
	public function render(node:Node):IRenderObject
	{
		// Throw error if render object class is missing.
		if(renderObjectClass == null) {
			throw new ArgumentError("Render object class must be defined before rendering");
		}

		// If no node is provided then return no output
		if(node == null) {
			return null;
		}
		
		// Measure and layout node
		node.measure();
		node.layout();
		
		// Render the node
		var object:IRenderObject = new renderObjectClass();
		node.render(object);
		
		// Render children
		for each(var child:Node in node.children) {
			object.addRenderChild(render(child));
		}
		
		return object;
	}
}
}
