package com.modality;

import flash.events.Event;
import flash.events.EventDispatcher;
import flash.events.IEventDispatcher;

import com.haxepunk.Entity;
import com.haxepunk.Graphic;
import com.haxepunk.Mask;

import com.haxepunk.graphics.Image;

class Base extends Entity implements IEventDispatcher
{
  private var _dispatcher:EventDispatcher;

  public var children:Array<Base>;
  public var dead:Bool;
  public var alpha(get, set):Float;

  public function new(x:Float = 0, y:Float = 0, graphic:Graphic = null, mask:Mask = null)
  {
    super(x, y, graphic, mask);
    dead = false;
    _dispatcher = new EventDispatcher(this);
    children = [];
  }

  public function addChild(child:Base):Void
  {
    children.remove(child);
    children.push(child);
    if(scene != null) {
      child.x = child.x + this.x;
      child.y = child.y + this.y;
      scene.add(child);
      child.layer = this.layer;
    }
  }

  public function removeChild(child:Base):Void
  {
    children.remove(child);
    if(scene != null) {
      scene.remove(child);
    }
  }

  public function eachChild(fn:Base->Void):Void
  {
    for(child in children) {
      fn(child);
    }
  }

  public override function added():Void
  {
    for(child in children) {
      child.x = child.x + this.x;
      child.y = child.y + this.y;
      scene.add(child);
      child.layer = this.layer;
    }
  }

  public override function removed():Void
  {
    for(child in children) {
      scene.remove(child);
    }
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

  public function updateHitbox()
  {
    setHitboxTo(graphic);
  }

  public function get_alpha():Float
  {
    return cast(this.graphic, Image).alpha;
  }

  public function set_alpha(alpha:Float):Float
  {
    cast(this.graphic, Image).alpha = alpha;
    return alpha;
  }
}

