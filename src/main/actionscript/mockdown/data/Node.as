package mockdown.data
{
import mockdown.parsers.Block;

import flash.events.EventDispatcher;

/**
 *	This class represents a node within the document object model.
 */
public class Node extends EventDispatcher
{
	//--------------------------------------------------------------------------
	//
	//	Constructor
	//
	//--------------------------------------------------------------------------
	
	/**
	 *	Constructor.
	 */
	public function Node()
	{
		super();
	}


	//--------------------------------------------------------------------------
	//
	//	Properties
	//
	//--------------------------------------------------------------------------
	
	/**
	 *	The parent node in the document object model.
	 */
	public var parent:Node;
	
	/**
	 *	The identifier for the node. This can be used only within a document
	 *	context.
	 */
	public var id:String;
	
	/**
	 *	The block the node was parsed from.
	 */
	public var block:Block;
	
	
	//---------------------------------
	//	Children
	//---------------------------------
	
	private var _children:Array = [];
	
	/**
	 *	The child nodes attached to this node.
	 */
	public function get children():Array
	{
		return _children.slice();
	}


	//---------------------------------
	//	Document
	//---------------------------------
	
	private var _document:Document;
	
	/**
	 *	The document node that this node was parsed from. If this is not set
	 *	explicitly, it is searched for through the parent hierarchy.
	 */
	public function get document():Document
	{
		if(_document) {
			return _document;
		}
		else if(parent) {
			return parent.document;
		}
		else {
			return null;
		}
	}
	
	/** @private */
	public function set document(value:Document):void
	{
		_document = value;
	}


	//--------------------------------------------------------------------------
	//
	//	Methods
	//
	//--------------------------------------------------------------------------
	
	//---------------------------------
	//	Children
	//---------------------------------
	
	/**
	 *	Appends a node to the list of children.
	 *	
	 *	@param child  The node to append.
	 */
	public function addChild(child:Node):void
	{
		if(child != null) {
			child.parent = this;
			_children.push(child);
		}
	}
	
	/**
	 *	Removes a node from the list of children.
	 *	
	 *	@param child  The node to remove.
	 */
	public function removeChild(child:Node):void
	{
		if(child != null && children.indexOf(child) != -1) {
			child.parent = null;
			_children.splice(children.indexOf(child), 1);
		}
	}


	//---------------------------------
	//	Document
	//---------------------------------

	/**
	 *	Returns a flag stating if the node is a root document node.
	 */
	public function isRoot():Boolean
	{
		return (_document != null);
	}
}
}
