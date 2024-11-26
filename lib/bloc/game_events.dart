import 'package:othello/models/cell_model.dart';

import '../core/dto/dto.dart';
import '../models/chat_message_model.dart';

abstract class GameEvent {}

class CellTappedEvent extends GameEvent {
  final CellModel cell;

  CellTappedEvent(this.cell);
}

class CellDroppedEvent extends GameEvent {
  final CellModel droppedCell;
  final CellModel destinationCell;

  CellDroppedEvent(this.droppedCell, this.destinationCell);
}

class ToogleSoundEvent extends GameEvent {}

class SendMessageEvent extends GameEvent {
  final ChatMessageModel message;

  SendMessageEvent(this.message);
}

class SocketDataEvent extends GameEvent {
  final Dto data;
  final bool chatOpen;

  SocketDataEvent({
    required this.data,
    required this.chatOpen,
  });
}

class OpenChatEvent extends GameEvent {}

class WhiteFlagEvent extends GameEvent {}

class NewGameEvent extends GameEvent {
  final bool start;
  final String firstPlayer;
  final String secondPlayer;

  NewGameEvent(this.start, this.firstPlayer, this.secondPlayer);
}
