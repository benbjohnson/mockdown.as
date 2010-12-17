package mockdown.parsers
{
import mockdown.errors.ParseError;

import flash.errors.IllegalOperationError;

/**
 *	This class tokenizes a string based on regular expression matches.
 */
public class Lexer
{
	//--------------------------------------------------------------------------
	//
	//	Constructor
	//
	//--------------------------------------------------------------------------
	
	/**
	 *	Constructor.
	 */
	public function Lexer(string:String)
	{
		// Validate string
		if(string == null) {
			throw new IllegalOperationError("Cannot lex a null string");
		}
		
		this.string = string;
	}


	//--------------------------------------------------------------------------
	//
	//	Properties
	//
	//--------------------------------------------------------------------------
	
	/**
	 *	The string to parse.
	 */
	private var string:String = "";
	
	/**
	 *	The last matching index to search from.
	 */
	private var lastIndex:int = 0;
	
	/**
	 *	A flag stating if the lexer has reached the end of the string.
	 */
	public function get eof():Boolean
	{
		return (string == null || lastIndex >= string.length);
	}
	
	
	//--------------------------------------------------------------------------
	//
	//	Methods
	//
	//--------------------------------------------------------------------------
	
	/**
	 *	Attempts to match a regular expression and return the match. If
	 *	successful, the last index is moved to the end of the full match. If
	 *	the match is unsuccessful, null is returned and the last index does
	 *	not change.
	 *
	 *	<p>The returned match is the last captured group in a regular
	 *	expression. If no capture groups are specified then it is the full
	 *	regular expression match.</p>
	 *
	 *	@param pattern  The regular expression pattern to match.
	 *	
	 *	@return         If successful, the string that matched the pattern.
	 */
	public function match(pattern:*):String
	{
		// Validate pattern
		if(pattern == null) {
			throw new IllegalOperationError("Lexical pattern cannot be null");
		}
		
		if(pattern is String) {
			return matchString(pattern as String);
		}
		else if(pattern is RegExp) {
			return matchRegExp(pattern as RegExp);
		}
		else {
			throw new IllegalOperationError("Pattern must be a String or RegExp.");
		}
	}
	
	
	/** @private */
	protected function matchString(pattern:String):String
	{
		var str:String = string.substr(lastIndex);
		var index:int = str.indexOf(pattern);
		
		// It's only a match if it occurs at the beginning.
		if(index == 0) {
			lastIndex += pattern.length
			return pattern;
		}
		// Otherwise return null and leave last index in place.
		else {
			return null;
		}
	}
	
	/** @private */
	protected function matchRegExp(pattern:RegExp):String
	{
		if(pattern.global) {
			throw new IllegalOperationError("Lexical pattern cannot have the global flag set");
		}
		
		// Add caret to pattern if missing
		if(pattern.source.indexOf("^") != 0) {
			pattern = new RegExp("^" + pattern.source, getFlags(pattern));
		}
		
		var str:String = string.substr(lastIndex);
		var match:Array = str.match(pattern);
		
		// If we successfully match, increment last index and return match
		if(match) {
			lastIndex += match[0].length;
			
			// If we received multiple one match, return the whole thing
			if(match.length == 1) {
				return match[0];
			}
			// If we have a single capture group then return it
			else if(match.length == 2) {
				return match[1];
			}
			// If we have multiple capture groups then throw an error
			else {
				throw new IllegalOperationError("Only one capture group is allowed for a lexical match");
			}
		}
		// If no match was found, do not leave last index and return null
		else {
			return null;
		}
	}
	
	/**
	 *	Retrieves a list of regular expression flags as a string.
	 */
	protected function getFlags(pattern:RegExp):String
	{
		return (pattern.global ? "g" : "") +
			   (pattern.ignoreCase ? "i" : "") +
			   (pattern.dotall ? "s" : "") +
			   (pattern.multiline ? "m" : "") +
			   (pattern.extended ? "x" : "");
	}
}
}
