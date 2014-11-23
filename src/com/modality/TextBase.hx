package com.modality;

import com.haxepunk.graphics.Text;

class TextBase extends Base
{
  public var textObj(get, null):Text;
  public var color(get, set):Int;
  public var size(get, set):Int;
  public var text(get, set):String;
  public var richText(get, set):String;

  private var _text:Text;

  public function new(_x:Int = 0, _y:Int = 0, _w:Int = 0, _h:Int = 0, _str:String = "")
  {
    super(_x, _y);
    _text = new Text(_str, 0, 0, _w, _h, {
      size: 16,
      color: 0xFFFFFF,
      font: Assets.get("font"),
      richText: true
    });
    this.graphic = _text;
    updateHitbox();
  }
  
  public function get_color()
  {
    return _text.color;
  }

  public function set_color(value)
  {
    _text.color = value;
    return _text.color;
  }

  public function get_size()
  {
    return _text.size;
  }

  public function set_size(value)
  {
    _text.size = value;
    updateHitbox();
    return _text.size;
  }

  public function get_text()
  {
    return _text.text;
  }

  public function set_text(value)
  {
    _text.text = value;
    updateHitbox();
    return _text.text;
  }

  public function get_richText()
  {
    return _text.richText;
  }

  public function set_richText(value)
  {
    _text.richText = value;
    updateHitbox();
    return _text.richText;
  }

  public function get_textObj()
  {
    return _text;
  }
}
