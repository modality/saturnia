package com.modality.ui;

import com.modality.Base;

typedef UITuple = { element:UIElement, align:UIAlign }

class UIPanel extends UIElement
{
  public var w:Float;
  public var h:Float;
  public var children:Array<UITuple>;
  public var namedChildren:Map<String, UIElement>;

  public function new(_x:Float, _y:Float, _w:Float, _h:Float)
  {
    entity = new Base(_x, _y);
    w = _w;
    h = _h;
    children = [];
    namedChildren = new Map<String, UIElement>();
  }

  public override function width():Float { return w; }
  public override function height():Float { return h; }

  public function addNamedChild(name:String, child:UIElement, align:UIAlign):Void
  {
    namedChildren.set(name, child);
    addChild(child, align);
  }

  public function getChild(name:String):UIElement
  {
    return namedChildren.get(name);
  }

  public function addChild(child:UIElement, align:UIAlign):Void
  {
    var tuple:UITuple = { element: child, align: align };
    children.push(tuple);
    entity.addChild(child.entity);
    updateGraphic();
  }

  public function removeChild(child:UIElement):Void
  {
    var i = children.length-1;
    while(i >= 0) {
      if(children[i].element == child) {
        children.splice(i, 1);
      }
      i--;
    }
    entity.removeChild(child.entity);
    updateGraphic();
  }

  public override function updateGraphic():Void
  {
    var x_offset = 0.;
    var y_offset = 0.;

    for(tuple in children) {
      tuple.element.entity.y = y_offset;
      switch(tuple.align) {
        case Left, FloatLeft:
          tuple.element.entity.x = x_offset;
        case Right, FloatRight:
          tuple.element.entity.x = x_offset + width() - tuple.element.width();
        case Center:
          tuple.element.entity.x = x_offset + (width() - tuple.element.width())/2;
      }
      tuple.element.updateGraphic();
      switch(tuple.align) {
        case Left, Center, Right:
          y_offset += tuple.element.height();
        case FloatLeft, FloatRight:
      }
    }
    h = y_offset;
  }

  public override function update():Void
  {
    for(tuple in children) {
      tuple.element.update();
    }
  }
}
