package com.mindscriptact.logmaster {

/**
 * All core and optional LogMaster functionality can be trigered from here.
 * @author Deril
 */ // FIXME : rename
public class DebugMan {
	
	// as3 levels
	public static const LEVEL_DEBUG:int	= 0;
	
	public static const LEVEL_INFO:int	= 1;
	
	public static const LEVEL_WARN:int	= 2;
	
	public static const LEVEL_ERROR:int	= 3;
	
	public static const LEVEL_FATAL:int	= 4;

	// text styles
	static public const TEXT_STYLE_NORMAL:int = 1;

	static public const TEXT_STYLE_BOLD:int = 2;

	static public const TEXT_STYLE_ITALIC:int = 3;

	static public const TEXT_STYLE_UNDERLINE:int = 5;

	static public const TEXT_STYLE_BOLD_ITALIC:int = TEXT_STYLE_BOLD * TEXT_STYLE_ITALIC;

	static public const TEXT_STYLE_BOLD_UNDERLINE:int = TEXT_STYLE_BOLD * TEXT_STYLE_UNDERLINE;

	static public const TEXT_STYLE_ITALIC_UNDERLINE:int = TEXT_STYLE_BOLD_ITALIC * TEXT_STYLE_UNDERLINE;

	static public const TEXT_STYLE_BOLD_ITALIC_UNDERLINE:int = TEXT_STYLE_BOLD * TEXT_STYLE_ITALIC * TEXT_STYLE_UNDERLINE;

	
	//////////////////////
	//	Debug to default tab.
	//////////////////////
	
	static public function debug(... args:Array):void {
		//trace("DebugMan.debug > args : " + args);
		var data:String = String(args[0]);

		for (var i:int = 1; i < args.length; i++){
			data = data + " " + String(args[i]);
		}
		RawMan.sendRowData("<msg type='debug'>" + data + "</msg>");
	}

	static public function info(... args:Array):void {
		//trace("DebugMan.info >  args : " +  args);
		var data:String = String(args[0]);

		for (var i:int = 1; i < args.length; i++){
			data = data + " " + String(args[i]);
		}
		RawMan.sendRowData("<msg type='info'>" + data + "</msg>");
	}

	static public function warn(... args:Array):void {
		//trace("DebugMan.warn >  args : " +  args);
		var data:String = String(args[0]);

		for (var i:int = 1; i < args.length; i++){
			data = data + " " + String(args[i]);
		}
		RawMan.sendRowData("<msg type='warn'>" + data + "</msg>");
	}

	static public function error(... args:Array):void {
		//trace("DebugMan.error >  args : " +  args);
		var data:String = String(args[0]);

		for (var i:int = 1; i < args.length; i++){
			data = data + " " + String(args[i]);
		}
		RawMan.sendRowData("<msg type='error'>" + data + "</msg>");
	}

	static public function fatal(... args:Array):void {
		//trace("DebugMan.fatal >  args : " +  args);
		var data:String = String(args[0]);

		for (var i:int = 1; i < args.length; i++){
			data = data + " " + String(args[i]);
		}
		RawMan.sendRowData("<msg type='fatal'>" + data + "</msg>");
	}

	//////////////////////
	//	Debug to targeted tab.
	//////////////////////
	
	static public function debugTo(tabId:int, ... args:Array):void {
		//trace("DebugMan.debug > args : " + args);
		var data:String = String(args[0]);

		for (var i:int = 1; i < args.length; i++){
			data = data + " " + String(args[i]);
		}
		RawMan.sendRowData("<msg type='debug' tabid='"+tabId+"'>" + data + "</msg>");
	}

	static public function infoTo(tabId:int, ... args:Array):void {
		//trace("DebugMan.info >  args : " +  args);
		var data:String = String(args[0]);

		for (var i:int = 1; i < args.length; i++){
			data = data + " " + String(args[i]);
		}
		RawMan.sendRowData("<msg type='info' tabid='"+tabId+"'>" + data + "</msg>");
	}

	static public function warnTo(tabId:int, ... args:Array):void {
		//trace("DebugMan.warn >  args : " +  args);
		var data:String = String(args[0]);

		for (var i:int = 1; i < args.length; i++){
			data = data + " " + String(args[i]);
		}
		RawMan.sendRowData("<msg type='warn' tabid='"+tabId+"'>" + data + "</msg>");
	}

	static public function errorTo(tabId:int, ... args:Array):void {
		//trace("DebugMan.error >  args : " +  args);
		var data:String = String(args[0]);

		for (var i:int = 1; i < args.length; i++){
			data = data + " " + String(args[i]);
		}
		RawMan.sendRowData("<msg type='error' tabid='"+tabId+"'>" + data + "</msg>");
	}

	static public function fatalTo(tabId:int, ... args:Array):void {
		//trace("DebugMan.fatal >  args : " +  args);
		var data:String = String(args[0]);

		for (var i:int = 1; i < args.length; i++){
			data = data + " " + String(args[i]);
		}
		RawMan.sendRowData("<msg type='fatal' tabid='"+tabId+"'>" + data + "</msg>");
	}
	
	
	
	//////////////////////
	//	Debug ALL IN ONE.
	//////////////////////	
	
	// TODO : change data to any data, not only string
	static public function log(data:String, level:int = 0, tabId:int = -1, textStyle:int = -1, textColor:int = -1, bgColor:Array = null):void {
		RawMan.sendRowData("<msg" 
							+" level='" + level + "'"
							+ ((textStyle >= 0)	?	(	  " bold='" + int(!(textStyle % TEXT_STYLE_BOLD)) + "'"
														+ " italic='" + int(!(textStyle % TEXT_STYLE_ITALIC)) + "'"
														+ " underline='" + int(!(textStyle % TEXT_STYLE_UNDERLINE)) + "'"
													) 
												: "" 
							  )
							+((textColor >= 0) ? (" color='" + textColor + "'") : "" )
							+((bgColor) ? (" bgcolor='" + String(bgColor) + "'") : "" )
							+((tabId>=0) ? (" tabid='" + tabId + "'") : "" )
							+">" + data + "</msg>");
	}
	
	//////////////////////
	//	General functionalyty.
	//////////////////////
	
	/**
	 * Sets default tabId for all generic messages.
	 * @param	tabId	- TabId to use as default, if specific is not provided.
	 * @param	name	- optionaly tab can be named.
	 */
	//static public function setTargetTab(tabId:int, name:String = ""):void {
		//RawMan.sendRowData("<cmd tabId='" + int(tabId) + "' name='" + escape(name) + "'>setTargetTab</cmd>");
	//}
	
	/**
	 * Renames targeted tab.
	 * @param	tabId	- id of the tab to rename.
	 * @param	name	- new name for the tab.
	 */
	static public function renameTab(tabId:int, name:String):void {
		//trace("DebugMan.changeTab > tabId : " + tabId + ", name : " + name);
		RawMan.sendRowData("<cmd tabId='" + int(tabId) + "' name='" + escape(name) + "'>renameTab</cmd>");
	}	
	
	
	static public function enableTabs(tabs:Array):void {
		RawMan.sendRowData("<cmd tabIds='" + tabs + "' >enableTabs</cmd>");

	}
	
	static public function disableTabs(tabs:Array):void {
		RawMan.sendRowData("<cmd tabIds='" + tabs + "'>disableTabs</cmd>");

	}
}
}
