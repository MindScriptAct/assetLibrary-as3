package com.mindscriptact.logmaster {
import flash.events.Event;
import flash.events.IOErrorEvent;
import flash.events.SecurityErrorEvent;
import flash.net.Socket;

/**
 * Makes connection with logger application.
 * Sends row data.
 * If you want you can write your own class, that will use RawMan to send any xml data you want.
 * @author Deril
 */ // FIXME : rename
public class RawMan {
	static public var enabled:Boolean = true;

	/** Message queue to store waiting messages for connection to be established. */
	static private var messageQueue:Array = []; /* of strings */

	/** Socket connection with LogMan server application */
	static private var socket:Socket;

	/**
	 * Sends data to debuger via socket.
	 * @param	data	String data to be send to dobuger application.
	 */
	static public function sendRowData(data:String):void {
		//trace("RawMan.sendData > data : " + data);
		if (enabled){
			// make sure socket connection is created.
			if (!socket){
				socket = new Socket();
				socket.addEventListener(Event.CONNECT, handleConnect);
				socket.addEventListener(IOErrorEvent.IO_ERROR, handleError);
				socket.addEventListener(SecurityErrorEvent.SECURITY_ERROR, handleError);
			}

			if (socket.connected){
				//trace("socket.send(data) : " + data);
				socket.writeUTFBytes(data);
				socket.flush();
			} else {
				try {
					// not intuitive 'connection in progress' check... needs better one.
					// (connect attempt made, but no responce jet..)
					if (!messageQueue.length){
						socket.connect("localhost", 4455);
					}
				} catch (error:SecurityError){
					trace("RowMan.as : connect to loger app error : " + error);
					return;
				}
				messageQueue.push(data);
			}
		}
	}

	static private function handleConnect(event:Event):void {
		//trace("RawMan.handleConnect > event : " + event);
		// connection established, send all queued messages.
		var sendData:String = ''

		while (messageQueue.length){
			socket.writeUTFBytes(messageQueue.shift());
		}
		socket.flush();
	}

	static private function handleError(event:Event):void {
		//trace("RawMan.handleError > event : " + event);
		// connection failed, cancel all queued messages.
		while (messageQueue.length){
			messageQueue.shift();
		}
	}
}
}