package com.saturnia;

import com.modality.Message;
import com.modality.IMessageContext;

class CardGameContext implements IMessageContext {
  public function new() { }

  public function eval(message:Message):Message
  {
    return message;
  }
}
