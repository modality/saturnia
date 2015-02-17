package com.saturnia.ui;

import openfl.display.BitmapData;

class Identicon
{
  public var bmd:BitmapData;
  public var seed:String;

  public function new() {
    bmd = new BitmapData(5, 5, false, 0x000000);

    var base = " abcefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
    var input = "";
  
    for(i in 0...16) {
      var index = Std.random(base.length);
      input += base.charAt(index);
    }

    seed = input;

    genIcon(seed);
  }

  public function genIcon(input:String) {
    var sum = fletcher16(input + input);

    for(i in 0...15) {
      if(((sum >> i) & 1) == 1) {
        mirrorSquare(i%3, Math.floor(i/3));
      }
    }
  }

  public function mirrorSquare(x:Int, y:Int) {
    bmd.setPixel(x, y, 0x00FF99);
    if((4-x) != x) {
      bmd.setPixel(4-x, y, 0x00FF99);
    } 
  }

  public function fletcher16(data:String):Int {
    var sum1 = 0x67452301;
    var sum2 = 0xEFCDAB89;

    for(i in 0...data.length) {
      sum1 = (sum1 + data.charCodeAt(i)) % 255;
      sum2 = (sum2 + sum1) % 255;
    }
  
    return (sum2 << 8) | sum1;
  }

}
