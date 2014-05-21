package com.saturnia;

import com.modality.cards.Message;
import com.modality.cards.Receiver;

class CardGameReceiver implements Receiver {
  public function new() { }

  public function eval(message:Message):Message
  {
    return message;
  }
}
