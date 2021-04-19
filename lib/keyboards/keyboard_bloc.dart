part of keyboard;

class KeyboardBloc extends Bloc<KeyboardEvent, KeyboardState> {
  KeyboardBloc() : super(KeyboardState.init());

  @override
  Stream<KeyboardState> mapEventToState(KeyboardEvent event) async* {
    if (event is BindKeyboardEvent) {
      yield state.copyWith(
        keyboard: event.keyboard,
        controller: event.controller,
      );
    }
  }
}

@immutable
abstract class KeyboardEvent {}

///通知事件
class BindKeyboardEvent extends KeyboardEvent {
  final KeyboardGenerate keyboard;
  final KeyboardController controller;
  BindKeyboardEvent({
    @required this.keyboard,
    @required this.controller,
  });
}

@immutable
class KeyboardState extends Equatable {
  final KeyboardGenerate keyboard;
  final KeyboardController controller;

  const KeyboardState({
     this.keyboard,
     this.controller,
  });

  ///表单初始化
  factory KeyboardState.init() {
    return KeyboardState();
  }

  KeyboardState copyWith({
    KeyboardGenerate keyboard,
    KeyboardController controller,
  }) {
    return KeyboardState(
      keyboard: keyboard ?? this.keyboard,
      controller: controller ?? this.controller,
    );
  }

  @override
  List<Object> get props => [keyboard, controller];

  @override
  String toString() {
    return '''KeyboardState {
      keyboard: $keyboard,
      controller: $controller,
    }''';
  }
}
