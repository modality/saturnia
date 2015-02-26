package com.modality.ui;

class UIElement
{
  public var entity:Base;
  public var active:Bool;
  public function width():Float { return 0; }
  public function height():Float { return 0; }
  public function updateText(text:String):Void { }
  public function updateGraphic():Void { }
  public function update():Void { }
}
