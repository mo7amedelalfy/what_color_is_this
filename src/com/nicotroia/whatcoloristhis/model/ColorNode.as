package com.nicotroia.whatcoloristhis.model
{
	public class ColorNode
	{
		public var data:String;
		public var next:ColorNode;
		public var prev:ColorNode;
		
		public function ColorNode(data:String)
		{
			this.data = data;
		}
	}
}