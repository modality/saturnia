package com.modality;

class ElasticGrid<T:(Block)>
{
  public var x:Int;
  public var y:Int;
  public var blocks:Array<T>;

  public function new(_x:Int, _y:Int)
  {
    x = _x;
    y = _y;
  }

  public function get(i:Int, j:Int):T
  {
    for(block in blocks) {
      if(block.x_index == i && block.y_index == j) {
        return block;
      }
    }
    return null;
  }

  public function each(fn:T->Int->Int->Void):Void
  {
    for(block in blocks) {
      fn(block, block.x_index, block.y_index);
    }
  }
}
