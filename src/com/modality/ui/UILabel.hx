package com.modality.ui;

class UILabel extends UIElement
{
  public function new(text:String, size:Int = 16, color:Int = 0xFFFFFF)
  {
    entity = new TextBase(0, 0, 0, 0, text);
    textEntity().color = color;
    textEntity().size = size;
  }

  public function textEntity():TextBase
  {
    return cast(entity, TextBase);
  }

  public override function width():Float
  {
    return textEntity().textObj.textWidth;
  }
  public override function height():Float
  {
    return textEntity().textObj.textHeight;
  }

  public override function updateText(text:String):Void
  {
    textEntity().text = text;
  }
}
