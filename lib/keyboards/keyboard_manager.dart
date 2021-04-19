part of keyboard;

typedef KeyboardBuilder = Widget Function(BuildContext context, KeyboardController controller);

class KeyboardManager {
  static JSONMethodCodec _codec = const JSONMethodCodec();
  static KeyboardBloc _bloc;
  static KeyboardGenerate _keyboard;
  static Map<SecurityTextInputType, KeyboardGenerate> _keyboards = {};
  static KeyboardController _controller;

  static bool isInterceptor = false;

  static init(BuildContext context, KeyboardBloc bloc) {
    _bloc = bloc;
    _interceptorInput();
  }

  static _interceptorInput() {
    if (isInterceptor) return;
    isInterceptor = true;
    ServicesBinding.instance.defaultBinaryMessenger.setMockMessageHandler(SystemChannels.textInput.name, (ByteData data) async {
      var methodCall = _codec.decodeMethodCall(data);
//      print("键盘拦截器>>>method>>>${methodCall.method}");
//      print("键盘拦截器>>>arguments>>>${methodCall.arguments}");
      switch (methodCall.method) {
        case 'TextInput.show':
          if (_keyboard != null) {
            openKeyboard();
            return _codec.encodeSuccessEnvelope(null);
          } else {
            return await _sendPlatformMessage(SystemChannels.textInput.name, data);
          }
          break;
        case 'TextInput.hide':
          if (_keyboard != null) {
            hideKeyboard();
            return _codec.encodeSuccessEnvelope(null);
          } else {
            return await _sendPlatformMessage(SystemChannels.textInput.name, data);
          }
          break;
        case 'TextInput.setEditingState':
          TextEditingValue editingState = TextEditingValue.fromJSON(methodCall.arguments);
          if (editingState != null && _controller != null) {
            _controller.value = editingState;
            return _codec.encodeSuccessEnvelope(null);
          }
          break;
        case 'TextInput.clearClient':
          hideKeyboard(animation: true);
          clearKeyboard();
          break;
        case 'TextInput.setClient':
          var setInputType = methodCall.arguments[1]['inputType'];
          KeyboardInputClient client;
          _keyboards.forEach((inputType, keyboardConfig) {
            if (inputType.name == setInputType['name']) {
              client = KeyboardInputClient.fromJSON(methodCall.arguments);
              clearKeyboard();
              _keyboard = keyboardConfig;

              _controller = KeyboardController(client: client)
                ..addListener(() {
                  var callbackMethodCall = MethodCall("TextInputClient.updateEditingState", [_controller.client.connectionId, _controller.value.toJSON()]);
                  ServicesBinding.instance.defaultBinaryMessenger.handlePlatformMessage(SystemChannels.textInput.name, _codec.encodeMethodCall(callbackMethodCall), (data) {});
                });
            }
          });
          if (client != null) {
            await _sendPlatformMessage(SystemChannels.textInput.name, _codec.encodeMethodCall(MethodCall('TextInput.hide')));
            return _codec.encodeSuccessEnvelope(null);
          } else {
            hideKeyboard(animation: false);
            clearKeyboard();
          }
          break;
      }
      ByteData response = await _sendPlatformMessage(SystemChannels.textInput.name, data);
      return response;
    });
  }

  static _unInterceptorInput() {
    ServicesBinding.instance.defaultBinaryMessenger.setMockMessageHandler(SystemChannels.textInput.name, null);

    isInterceptor = false;
  }

  static Future<ByteData> _sendPlatformMessage(String channel, ByteData message) {
    final Completer<ByteData> completer = Completer<ByteData>();
    ui.window.sendPlatformMessage(channel, message, (ByteData reply) {
      try {
        completer.complete(reply);
      } catch (exception, stack) {
        FlutterError.reportError(FlutterErrorDetails(
          exception: exception,
          stack: stack,
          library: 'services library',
          context: ErrorDescription('during a platform message response callback'),
        ));
      }
    });
    return completer.future;
  }

  static addKeyboard(SecurityTextInputType inputType, KeyboardGenerate config) {
    _keyboards[inputType] = config;
  }

  static openKeyboard() {
    _bloc.add(BindKeyboardEvent(keyboard: _keyboard, controller: _controller));

    BackButtonInterceptor.add((bool stopDefaultButtonEvent, RouteInfo info) {
      KeyboardManager.sendPerformAction(TextInputAction.done);
      return true;
    }, zIndex: 1, name: 'CustomKeyboard');
  }

  static hideKeyboard({bool animation = true}) {
    BackButtonInterceptor.removeByName('CustomKeyboard');
  }

  static clearKeyboard() {
    _keyboard = null;
    if (_controller != null) {
      _controller.dispose();
      _controller = null;
    }
  }

  static addText(String text) {
    if (_controller != null) {
      _controller.addText(text);
    }
  }

  static sendPerformAction(TextInputAction action) {
    var callbackMethodCall = MethodCall("TextInputClient.performAction", [_controller.client.connectionId, action.toString()]);
    ServicesBinding.instance.defaultBinaryMessenger.handlePlatformMessage(SystemChannels.textInput.name, _codec.encodeMethodCall(callbackMethodCall), (data) {});
  }
}

class KeyboardGenerate {
  final KeyboardBuilder builder;
  const KeyboardGenerate({this.builder});
}

class KeyboardInputClient {
  final int connectionId;
  final TextInputConfiguration configuration;
  const KeyboardInputClient({this.connectionId, this.configuration});

  factory KeyboardInputClient.fromJSON(List<dynamic> encoded) {
    return KeyboardInputClient(connectionId: encoded[0], configuration: TextInputConfiguration(inputType: SecurityTextInputType.fromJSON(encoded[1]['inputType']), obscureText: encoded[1]['obscureText'], autocorrect: encoded[1]['autocorrect'], actionLabel: encoded[1]['actionLabel'], inputAction: _toTextInputAction(encoded[1]['inputAction']), textCapitalization: _toTextCapitalization(encoded[1]['textCapitalization']), keyboardAppearance: _toBrightness(encoded[1]['keyboardAppearance'])));
  }

  static TextInputAction _toTextInputAction(String action) {
    switch (action) {
      case 'TextInputAction.none':
        return TextInputAction.none;
      case 'TextInputAction.unspecified':
        return TextInputAction.unspecified;
      case 'TextInputAction.go':
        return TextInputAction.go;
      case 'TextInputAction.search':
        return TextInputAction.search;
      case 'TextInputAction.send':
        return TextInputAction.send;
      case 'TextInputAction.next':
        return TextInputAction.next;
      case 'TextInputAction.previuos':
        return TextInputAction.previous;
      case 'TextInputAction.continue_action':
        return TextInputAction.continueAction;
      case 'TextInputAction.join':
        return TextInputAction.join;
      case 'TextInputAction.route':
        return TextInputAction.route;
      case 'TextInputAction.emergencyCall':
        return TextInputAction.emergencyCall;
      case 'TextInputAction.done':
        return TextInputAction.done;
      case 'TextInputAction.newline':
        return TextInputAction.newline;
    }
    throw FlutterError('Unknown text input action: $action');
  }

  static TextCapitalization _toTextCapitalization(String capitalization) {
    switch (capitalization) {
      case 'TextCapitalization.none':
        return TextCapitalization.none;
      case 'TextCapitalization.characters':
        return TextCapitalization.characters;
      case 'TextCapitalization.sentences':
        return TextCapitalization.sentences;
      case 'TextCapitalization.words':
        return TextCapitalization.words;
    }

    throw FlutterError('Unknown text capitalization: $capitalization');
  }

  static Brightness _toBrightness(String brightness) {
    switch (brightness) {
      case 'Brightness.dark':
        return Brightness.dark;
      case 'Brightness.light':
        return Brightness.light;
    }

    throw FlutterError('Unknown Brightness: $brightness');
  }
}

///自定义键盘输入类型
class SecurityTextInputType extends TextInputType {
  final String name;

  const SecurityTextInputType({this.name, bool signed, bool decimal}) : super.numberWithOptions(signed: signed, decimal: decimal);

  factory SecurityTextInputType.fromJSON(Map<String, dynamic> encoded) {
    return SecurityTextInputType(name: encoded['name'], signed: encoded['signed'], decimal: encoded['decimal']);
  }

  @override
  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'name': name,
      'signed': signed,
      'decimal': decimal,
    };
  }

  @override
  bool operator ==(Object target) {
    if (target is SecurityTextInputType) {
      if (this.toString() == target.toString()) {
        return true;
      }
    }
    return false;
  }

  @override
  int get hashCode => hashValues(this.name, this.toString());

  @override
  String toString() {
    return '$runtimeType('
        'name: $name, '
        'signed: $signed, '
        'decimal: $decimal)';
  }
}

class KeyboardBarBuilder {
  final Builder footWidget;
  final PreferredSizeWidget Function(BuildContext context, Widget expandWidget) builder;
  final Widget Function(bool isExpand) expandWidget;

  const KeyboardBarBuilder({this.builder, this.expandWidget, this.footWidget});

  Widget build(context, onTap, isExpand) {
    return builder(
        context,
        GestureDetector(
          child: expandWidget(isExpand),
          onTap: onTap,
        ));
  }
}

abstract class AbstractKeyboard<T extends StatefulWidget> extends State<T> {
  void resetKeyboard();
}
