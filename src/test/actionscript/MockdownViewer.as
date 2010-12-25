package
{
import mockdown.components.Component;
import mockdown.components.loaders.ComponentLoader;
import mockdown.components.loaders.FileComponentLoader;
import mockdown.components.loaders.SystemComponentLoader;
import mockdown.display.flash.FlashRenderer;
import mockdown.display.flash.FlashRenderObject;
import mockdown.filesystem.LocalFile;

import flash.desktop.NativeApplication;
import flash.display.StageAlign;
import flash.display.StageScaleMode;
import flash.display.Sprite;
import flash.events.InvokeEvent;
import flash.events.MouseEvent;
import flash.filesystem.File;

/**
 *	This class represents a simple application for viewing Mockdown files.
 */
public class MockdownViewer extends Sprite
{
	//--------------------------------------------------------------------------
	//
	//	Constructor
	//
	//--------------------------------------------------------------------------
	
	/**
	 *	Constructor.
	 */
	public function MockdownViewer()
	{
		super();

		// Setup stage
		stage.scaleMode = StageScaleMode.NO_SCALE
		stage.align = StageAlign.TOP_LEFT;
		
		// Setup system loader
		systemLoader = new SystemComponentLoader();

		// Render on invocation
		NativeApplication.nativeApplication.addEventListener(InvokeEvent.INVOKE,
			function(event:InvokeEvent):void{
				// Read command line arguments at startup
				filename = event.arguments[0];
				render();
			}
		);
		
		addEventListener(MouseEvent.CLICK, onClick);
	}
	

	//--------------------------------------------------------------------------
	//
	//	Properties
	//
	//--------------------------------------------------------------------------

	/**
	 *	The name of the file to parse.
	 */
	public var filename:String;

	/**
	 *	The sprite used to display the output.
	 */
	private var output:FlashRenderObject;

	/**
	 *	The system loader.
	 */
	private var systemLoader:ComponentLoader;


	//--------------------------------------------------------------------------
	//
	//	Methods
	//
	//--------------------------------------------------------------------------

	/**
	 *	Parses and renders the file.
	 */
	public function render():void
	{
		var t0:Date = new Date();
		
		// Remove previous output
		if(output && contains(output)) {
			removeChild(output);
		}
		
		// Exit if missing the file
		graphics.clear();
		if(!filename) {
			trace("Missing filename");
			graphics.lineStyle(0x000000, 1);
			graphics.moveTo(0, 0);
			graphics.lineTo(width, height);
			graphics.moveTo(0, height);
			graphics.lineTo(width, 0);
			return;
		}
		
		// Parse
		var loader:FileComponentLoader = new FileComponentLoader(systemLoader);
		loader.paths = [new LocalFile(File.applicationDirectory)];

		var component:Component = loader.newInstance(filename);
		if(!component) {
			trace("No component found: " + filename);
			return;
		}
		
		// Render
		var renderer:FlashRenderer = new FlashRenderer();
		output = renderer.render(component) as FlashRenderObject;
		addChild(output);
		
		// Center output
		output.x = 10;
		output.y = 10;
		stage.nativeWindow.width = output.width + 20;
		stage.nativeWindow.height = output.height + 40;
		
		// Set title
		stage.nativeWindow.title = filename;

		trace("time: " + ((new Date()).valueOf()-t0.valueOf()));
	}


	//--------------------------------------------------------------------------
	//
	//	Events
	//
	//--------------------------------------------------------------------------
	
	private function onClick(event:MouseEvent):void
	{
		// render();
	}
}
}
