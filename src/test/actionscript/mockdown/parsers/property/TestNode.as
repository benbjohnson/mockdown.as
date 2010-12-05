package mockdown.parsers.property
{
import mockdown.components.Node;

public class TestNode extends Node
{
	[DataType(type="string")]
	public var stringProperty:String;

	[DataType(type="integer")]
	public var integerProperty:Number;

	[DataType(type="decimal")]
	public var decimalProperty:Number;

	[DataType(type="integer")]
	public var implicitNegativeProperty:Number;

	[DataType(type="integer", allowNegative="true")]
	public var explicitNegativeProperty:Number;

	[DataType(type="integer", allowNegative="false")]
	public var explicitPositiveProperty:Number;

	[DataType(type="integer", percentField="toPercentageProperty")]
	public var fromPercentageProperty:Number;

	[DataType(type="integer")]
	public var toPercentageProperty:Number;

	[DataType(type="boolean")]
	public var booleanProperty:Boolean;
}
}
