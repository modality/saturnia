package com.modality;

import flash.events.Event;
import flash.events.EventDispatcher;
import flash.events.IEventDispatcher;

import com.haxepunk.Scene;

class Controller extends Scene implements IEventDispatcher
{
  private var _dispatcher:EventDispatcher;

  public function new()
  {
    super();
    _dispatcher = new EventDispatcher(this);
  }

  public function addEventListener(type:String, listener:Dynamic->Void, useCapture:Bool=false, priority:Int=0, useWeakReference:Bool=false):Void 
  {
    _dispatcher.addEventListener(type, listener, useCapture, priority, useWeakReference);
  }

  public function dispatchEvent(event:Event):Bool 
  {
    return _dispatcher.dispatchEvent(event);
  }

  public function hasEventListener(type:String):Bool 
  {
    return _dispatcher.hasEventListener(type);
  }

  public function removeEventListener(type:String, listener:Dynamic->Void, useCapture:Bool = false):Void
  {
    _dispatcher.removeEventListener(type, listener, useCapture);
  }

  public function willTrigger(type:String):Bool
  { 
    return _dispatcher.willTrigger(type);
  }
}


