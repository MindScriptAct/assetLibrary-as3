package com.mindscriptact.logmaster {


/**
 * This class is dedicated to bind
 * @author Derilas
 */
public class LogMan {
	/**  */
	private var category:String;

	private var classTabId:int = -1;

	public function LogMan(category:String = "", classTabId:int = -1){
		this.category = category;
		this.classTabId = classTabId;

	}

	//////////////////////
	//	Debug to default tab.
	//////////////////////

	// TODO : investigate what is faster, function.apply or pasing argument using for loop and pasing.. somehow.
	
	public function debug(... args:Array):void {
		args.unshift(-1);
		this.debugTo.apply(this, args);
	}

	public function info(... args:Array):void {
		args.unshift(-1);
		this.infoTo.apply(this, args);
	}

	public function warn(... args:Array):void {
		args.unshift(-1);
		this.warnTo.apply(this, args);
	}

	public function error(... args:Array):void {
		args.unshift(-1);
		this.errorTo.apply(this, args);
	}

	public function fatal(... args:Array):void {
		args.unshift(-1);
		this.fatalTo.apply(this, args);
	}

	//////////////////////
	//	Debug to targeted tab.
	//////////////////////

	public function debugTo(tabId:int = -1, ... args:Array):void {
		//trace("Debuger.debug > args : " + args);
		var data:String = "";
		var tabIdData:String = "";


		if (tabId > -1){
			tabIdData = " tabid='" + tabId + "'";
		} else if (classTabId > -1){
			tabIdData = " tabid='" + classTabId + "'";
		}

		if (category){
			data = category + " : ";
		}

		for (var i:int = 0; i < args.length; i++){
			data = data + " " + String(args[i]);
		}
		RawMan.sendRowData("<msg type='debug'" + tabIdData + ">" + data + "</msg>");
	}

	public function infoTo(tabId:int = -1, ... args:Array):void {
		//trace("Debuger.info >  args : " +  args);
		var data:String = "";
		var tabIdData:String = "";

		if (tabId > -1){
			tabIdData = " tabid='" + tabId + "'";
		} else if (classTabId > -1){
			tabIdData = " tabid='" + classTabId + "'";
		}

		if (category){
			data = category + " : ";
		}

		for (var i:int = 1; i < args.length; i++){
			data = data + " " + String(args[i]);
		}
		RawMan.sendRowData("<msg type='info'" + tabIdData + ">" + data + "</msg>");
	}

	public function warnTo(tabId:int = -1, ... args:Array):void {
		//trace("Debuger.warn >  args : " +  args);
		var data:String = "";
		var tabIdData:String = "";

		if (tabId > -1){
			tabIdData = " tabid='" + tabId + "'";
		} else if (classTabId > -1){
			tabIdData = " tabid='" + classTabId + "'";
		}

		if (category){
			data = category + " : ";
		}

		for (var i:int = 0; i < args.length; i++){
			data = data + " " + String(args[i]);
		}
		RawMan.sendRowData("<msg type='warn'" + tabIdData + ">" + data + "</msg>");
	}

	public function errorTo(tabId:int = -1, ... args:Array):void {
		//trace("Debuger.error >  args : " +  args);
		var data:String = "";
		var tabIdData:String = "";

		if (tabId > -1){
			tabIdData = " tabid='" + tabId + "'";
		} else if (classTabId > -1){
			tabIdData = " tabid='" + classTabId + "'";
		}

		if (category){
			data = category + " : ";
		}

		for (var i:int = 0; i < args.length; i++){
			data = data + " " + String(args[i]);
		}
		RawMan.sendRowData("<msg type='error'" + tabIdData + ">" + data + "</msg>");
	}

	public function fatalTo(tabId:int = -1, ... args:Array):void {
		//trace("Debuger.fatal >  args : " +  args);
		var data:String = "";
		var tabIdData:String = "";

		if (tabId > -1){
			tabIdData = " tabid='" + tabId + "'";
		} else if (classTabId > -1){
			tabIdData = " tabid='" + classTabId + "'";
		}

		if (category){
			data = category + " : ";
		}

		for (var i:int = 0; i < args.length; i++){
			data = data + " " + String(args[i]);
		}
		RawMan.sendRowData("<msg type='fatal'" + tabIdData + ">" + data + "</msg>");
	}

}
}