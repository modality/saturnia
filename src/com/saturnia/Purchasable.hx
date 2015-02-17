package com.saturnia;

interface Purchasable
{
  public var infinite:Bool;
  public var amount:Int;
  public var cargoCost:Int;
  public var scienceCost:Int;

  public function displayName():String;
  public function displayDescription():String;
  public function canPurchase(player:PlayerResources):Bool;
  public function onPurchase(event:PurchaseEvent):Void;
}
