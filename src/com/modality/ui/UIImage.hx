package com.modality.ui; 

class UIImage extends UIElement
{
  public function new(asset:String)
  {
    entity = new Base(0, 0, Assets.getImage(asset));
  }

  public override function width():Float
  {
    return entity.image.scaledWidth;
  }

  public override function height():Float
  {
    return entity.image.scaledHeight;
  }
}
