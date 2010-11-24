package mockdown.utils
{
import mockdown.components.VisualNode;

import org.flexunit.Assert;

/**
 * 	This class contains helper test methods for node classes.
 */		
public class NodeTestUtil
{
	//--------------------------------------------------------------------------
	//
	//	Static Methods
	//
	//--------------------------------------------------------------------------

	/**
	 *	Creates a visual node with given properties. This method allows for
	 *	nested chaining to create trees.
	 */
	static public function create(nodes:Object, id:String, clazz:Class, properties:Object, children:Array):*
	{
		// Create visual node
		var node:VisualNode = new clazz();

		// Set properties
		for(var name:String in properties) {
			node[name] = properties[name];
		}
		
		// Add children
		for each(var child:VisualNode in children) {
			node.addChild(child);
		}
		
		// Save node reference
		if(id != null) {
			nodes[id] = node;
		}
		
		return node;
	}
	
	/**
	 *	Asserts that a visual node has certain width and height.	
	 */
	static public function assertSize(nodes:Object, id:String, w:uint, h:uint):void
	{
		var node:VisualNode = nodes[id] as VisualNode;
		Assert.assertEquals(id + ".pixelWidth", w, node.pixelWidth);
		Assert.assertEquals(id + ".pixelHeight", h, node.pixelHeight);
	}

	/**
	 *	Asserts that a visual node certain x, y and width and height.	
	 */
	static public function assertDimension(nodes:Object, id:String, x:int, y:int, w:uint, h:uint):void
	{
		var node:VisualNode = nodes[id] as VisualNode;
		Assert.assertEquals(id + ".x", x, node.x);
		Assert.assertEquals(id + ".y", y, node.y);
		assertSize(nodes, id, w, h);
	}
}
}