package com.modality;

class ElasticGrid<T:(Block)>
{
  public var blocks:Array<T>;
  public var minX:Int;
  public var maxX:Int;
  public var minY:Int;
  public var maxY:Int;

  public function new()
  {
    blocks = [];
    minX = 0;
    minY = 0;
    maxX = 0;
    maxY = 0;
  }

  public function add(i:Int, j:Int, block:T) {
    if(!exists(i, j)) {
      block.x_index = i;
      block.y_index = j;
      blocks.push(block);

      if(i > maxX) maxX = i;
      if(i < minX) minX = i;
      if(j > maxY) maxY = j;
      if(j < minY) minY = j;
    }
  }

  public function exists(i:Int, j:Int):Bool
  {
    if(i > maxX) return false;
    if(i < minX) return false;
    if(j > maxY) return false;
    if(j < minY) return false;

    for(block in blocks) {
      if(block.x_index == i && block.y_index == j) {
        return true;
      }
    }
    return false;
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
