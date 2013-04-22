package com.nicotroia.whatcoloristhis.model
{
	public class ColorLinkedList
	{
		public var head:ColorNode;
		public var tail:ColorNode;
		public var length:int;
		
		public function push( node:ColorNode ):void
		{
			if( ! head )
			{
				head = tail = node;
			}
			else
			{
				tail.next = node;
				node.prev = tail;
				tail = node;
			}
			
			length++;
		}
		
		public function pop():String
		{
			if (this.tail)
			{
				var data:String = this.tail.data;
				
				this.tail = this.tail.prev;
				this.tail.next = null; //right, jackson dunstan?
				
				length--;
				
				return data;
			}
			else
			{
				return undefined;
			}
		}
		
		public function addBefore( node:ColorNode, winner:ColorNode ):void
		{
			var oldPrev:ColorNode = node.prev;
			
			if( oldPrev ) { 
				oldPrev.next = winner; 
			}
			
			node.prev = winner;
			winner.prev = oldPrev;
			winner.next = node;
			
			length++;
		}
		
		public function remove( node:ColorNode ):ColorNode
		{
			if ( head == node)
			{
				head = head.next;
			}
			if ( tail == node)
			{
				tail = tail.prev;
			}
			
			if (node.prev)
			{
				node.prev.next = node.next;
			}
			
			if (node.next)
			{
				node.next.prev = node.prev;
			}
			
			node.prev = node.next = null;
			
			length--;
			
			return node;
		}
		
		public function unshift( node:ColorNode ):void
		{
			if (this.head)
			{
				this.head.prev = node;
				this.head.prev.next = this.head;
				this.head = this.head.prev;
			}
			else
			{
				this.head = this.tail = node;
			}
			
			length++;
		}
		
		public function iterate():void
		{
			var index:uint = 0;
			var current:ColorNode = this.head;
			
			while( current ) { 
				trace(index++ + ": " + current.data);
				current = current.next;
			}
		}
	}
}