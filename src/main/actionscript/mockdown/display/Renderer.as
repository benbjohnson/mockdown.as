package mockdown.display
{
import mockdown.components.BaseComponent;

/**
 *	This class recursively renders a tree of components onto a view.
 *
 *	@see RenderObject
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
	 *	The class to instantiate for each component when performing a render.
	 */
	public var renderObjectClass:Class;


	//--------------------------------------------------------------------------
	//
	//	Methods
	//
	//--------------------------------------------------------------------------
	
	/**
	 *	Renders a tree of components to a render object.
	 *
	 *	@return  The output of the rendering.
	 */
	public function render(component:BaseComponent):RenderObject
	{
		// Throw error if render object class is missing.
		if(renderObjectClass == null) {
			throw new ArgumentError("Render object class must be defined before rendering");
		}

		// If no component is provided then return no output
		if(component == null) {
			return null;
		}
		
		// Measure and layout component
		component.measure();
		component.layout();
		
		return renderComponent(component);
	}

	/**
	 *	Recursively performs a render on a component tree.
	 */
	protected function renderComponent(component:BaseComponent):RenderObject
	{
		// If no component is provided then return no output
		if(component == null) {
			return null;
		}
		
		// Render the component
		var object:RenderObject = new renderObjectClass();
		component.render(object);
		
		// Render children
		for each(var child:BaseComponent in component.children) {
			object.addRenderChild(renderComponent(child));
		}
		
		return object;
	}
}
}
