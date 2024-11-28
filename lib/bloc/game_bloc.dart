import 'package:bloc/bloc.dart';
import 'package:othello/models/cell_model.dart';

import '../core/client_base.dart';
import '../core/dto/data_type.dart';
import '../models/chat_message_model.dart';
import '../models/destination_model.dart';
import '../utils/utils.dart';
import 'game_events.dart';
import 'game_state.dart';

class GameBloc extends Bloc<GameEvent, GameState> {
  final ClientBase _client;

  GameBloc(
    this._client,
    bool myTurn,
    int myValue,
    String firstPlayer,
    String secondPlayer,
  ) : super(GameState.initial(myTurn, myValue, firstPlayer, secondPlayer)) {
    on<NewGameEvent>(_onNewGame);
    on<FindDestinations>(_onFindDestinations);
    on<CellTappedEvent>(_onCellTapped);
    on<OpenChatEvent>(_onOpenChat);
    on<SendMessageEvent>(_sendMessage);
    on<WhiteFlagEvent>(_onWhiteFlag);
    on<SocketDataEvent>(_onSocketData);
  }

  void _onNewGame(NewGameEvent event, Emitter emit) {
    emit(GameState.initial(
      event.start,
      event.myValue,
      event.firstPlayer,
      event.secondPlayer,
    ).copyWith(
      messages: state.messages,
      unreadMessagesCount: state.unreadMessagesCount,
      soundEnable: state.soundEnable,
    ));
  }

  void _onFindDestinations(FindDestinations event, Emitter emit) {
    List<DestinationModel> destinations = findValidMoves(
      state.myValue,
      state.board,
    );

    emit(state.copyWith(availableDestinations: destinations));
  }

  void _onCellTapped(CellTappedEvent event, Emitter emit) {
    if (!state.myTurn || state.gameOver) {
      return;
    }

    final cell = event.cell;
    List<CellModel> board = state.board;
    board[cell.index].value = state.myValue;

    board = updateBoardAfterMove(cell.index, state.myValue, board);

    _client.movement(value: state.myValue, destinationIndex: cell.index);

    emit(
      state.copyWith(board: board, myTurn: false, availableDestinations: []),
    );
  }

  void _onOpenChat(OpenChatEvent event, Emitter emit) {
    if (state.unreadMessagesCount > 0) {
      emit(state.copyWith(unreadMessagesCount: 0));
    }
  }

  void _sendMessage(SendMessageEvent event, Emitter emit) {
    _client.chat(event.message.text);
    emit(state.copyWith(messages: state.messages..add(event.message)));
  }

  void _onWhiteFlag(WhiteFlagEvent event, Emitter emit) {
    _client.whiteFlag();
    emit(state.copyWith(gameOver: true, whiteFlag: false));
  }

  void _onSocketData(SocketDataEvent event, Emitter emit) {
    if (event.data.type.equals(DataType.chat)) {
      final message = ChatMessageModel(
        text: event.data.message,
        isMine: false,
      );

      emit(state.copyWith(
        messages: state.messages..add(message),
        unreadMessagesCount: event.chatOpen ? 0 : state.unreadMessagesCount + 1,
      ));
    }

    if (event.data.type.equals(DataType.movement)) {
      emit(_makeMovement(
        event.data.value,
        event.data.destinationIndex,
      ));
    }

    if (event.data.type.equals(DataType.whiteFlag)) {
      emit(state.copyWith(gameOver: true, whiteFlag: true));
    }
  }

  GameState _makeMovement(int value, int destinationIndex) {
    bool myTurn = true;

    bool gameOver = isGameOver(state.board);

    List<CellModel> board = state.board;
    board[destinationIndex].value = value;

    board = updateBoardAfterMove(destinationIndex, value, board);

    return GameState(
      selectedIndex: -1,
      soundEnable: state.soundEnable,
      board: board,
      availableDestinations: [],
      messages: state.messages,
      unreadMessagesCount: state.unreadMessagesCount,
      myTurn: myTurn,
      myValue: state.myValue,
      gameOver: gameOver,
      whiteFlag: state.whiteFlag,
      firstPlayer: state.firstPlayer,
      secondPlayer: state.secondPlayer,
    );
  }
}
