package com.modality.ui;

import openfl.display.BitmapData;
import com.haxepunk.graphics.Image;
import com.haxepunk.utils.Input;

class UIButton extends UIElement
{
  public var textEntity:TextBase;
  public var imageOff:Image;
  public var imageOn:Image;

  public var onClick:UIButton->Void;

  public function new(w:Int, h:Int, text:String, _onClick:UIButton->Void = null)
  {
    active = true;
    imageOff = new Image(new BitmapData(w, h, false, 0x444444));
    imageOn = new Image(new BitmapData(w, h, false, 0x888888));
    entity = new Base(0, 0, imageOff);
    entity.type = "UIButton";
    entity.updateHitbox();

    onClick = _onClick;

    textEntity = new TextBase(0, 0, w, h, text);
    textEntity.x = (width() - textEntity.textObj.textWidth)/2.;
    textEntity.y = (height() - textEntity.textObj.textHeight)/2.;

    entity.addChild(textEntity);
  }

  public override function width():Float
  {
    return entity.image.scaledWidth;
  }
  public override function height():Float
  {
    return entity.image.scaledHeight;
  }

  public override function updateText(text:String):Void
  {
    textEntity.text = text;
  }

  public override function updateGraphic():Void
  {
    if(active) {
      textEntity.color = 0xFFFFFF;
    } else {
      textEntity.color = 0xAAAAAA;
    }

    if(textEntity.scene != null) {
      textEntity.x = entity.x + (width() - textEntity.textObj.textWidth)/2.;
      textEntity.y = entity.y + (height() - textEntity.textObj.textHeight)/2.;
    } else {
      textEntity.x = (width() - textEntity.textObj.textWidth)/2.;
      textEntity.y = (height() - textEntity.textObj.textHeight)/2.;
    }
  }

  public override function update():Void
  {
    var base:Base = cast(entity.scene.collidePoint("UIButton", Input.mouseX, Input.mouseY), Base);

    if(base == entity && active) {
      if(Input.mouseReleased && onClick != null) {
        onClick(this);
      }
    }

    if(base == entity && active) {
      if(Input.mousePressed || Input.mouseDown) {
        entity.graphic = imageOff;
      } else {
        entity.graphic = imageOn;
      }
    } else {
      entity.graphic = imageOff;
    }
  }
}
