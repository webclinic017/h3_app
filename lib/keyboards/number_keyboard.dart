part of keyboard;

class NumberKeyboard extends StatelessWidget {
  static const SecurityTextInputType inputType = const SecurityTextInputType(name: 'NumberKeyboard');

  final KeyboardController controller;
  final KeyboardBarBuilder keyboardBarBuilder;

  final double buttonWidth;
  final double buttonHeight;
  final double buttonSpace;
  const NumberKeyboard({Key key, this.controller, this.keyboardBarBuilder, this.buttonWidth, this.buttonHeight, this.buttonSpace}) : super(key: key);

  static register({KeyboardBarBuilder keyboardBar, double buttonWidth = 100, double buttonHeight = 100, double buttonSpace = 10}) {
    KeyboardManager.addKeyboard(
      NumberKeyboard.inputType,
      KeyboardGenerate(builder: (context, controller) {
        return NumberKeyboard(
          controller: controller,
          keyboardBarBuilder: keyboardBar,
          buttonWidth: buttonWidth,
          buttonHeight: buttonHeight,
          buttonSpace: buttonSpace,
        );
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    var maxHeight = this.buttonHeight * 4 + this.buttonSpace * 3;
    var maxWidth = this.buttonWidth * 4 + this.buttonSpace * 3;
    return ConstrainedBox(
      constraints: BoxConstraints(
        maxHeight: Constants.getAdapterHeight(maxHeight),
        maxWidth: Constants.getAdapterWidth(maxWidth),
      ),
      child: Column(
        children: <Widget>[
          Expanded(
            flex: 1,
            child: Row(
              children: <Widget>[
                buildButton("7"),
                Space(width: Constants.getAdapterWidth(this.buttonSpace)),
                buildButton("8"),
                Space(width: Constants.getAdapterWidth(this.buttonSpace)),
                buildButton("9"),
                Space(width: Constants.getAdapterWidth(this.buttonSpace)),
                buildBackspace(""),
              ],
            ),
          ),
          Space(height: Constants.getAdapterHeight(this.buttonSpace)),
          Expanded(
            flex: 1,
            child: Row(
              children: <Widget>[
                buildButton("4"),
                Space(width: Constants.getAdapterWidth(this.buttonSpace)),
                buildButton("5"),
                Space(width: Constants.getAdapterWidth(this.buttonSpace)),
                buildButton("6"),
                Space(width: Constants.getAdapterWidth(this.buttonSpace)),
                buildClearAll("清空"),
              ],
            ),
          ),
          Space(
            height: Constants.getAdapterWidth(this.buttonSpace),
          ),
          Expanded(
            flex: 2,
            child: Row(
              children: <Widget>[
                Column(
                  children: <Widget>[
                    Expanded(
                      child: Row(
                        children: <Widget>[
                          buildButton("1"),
                          Space(width: Constants.getAdapterWidth(this.buttonSpace)),
                          buildButton("2"),
                          Space(width: Constants.getAdapterWidth(this.buttonSpace)),
                          buildButton("3"),
                          Space(width: Constants.getAdapterWidth(this.buttonSpace)),
                        ],
                      ),
                    ),
                    Space(
                      height: Constants.getAdapterHeight(this.buttonSpace),
                    ),
                    Expanded(
                      child: Row(
                        children: <Widget>[
                          buildButton("0"),
                          Space(width: Constants.getAdapterWidth(this.buttonSpace)),
                          buildButton("."),
                          Space(width: Constants.getAdapterWidth(this.buttonSpace)),
                          buildButton("00"),
                          Space(width: Constants.getAdapterWidth(this.buttonSpace)),
                        ],
                      ),
                    ),
                  ],
                ),
                Container(
                  width: Constants.getAdapterWidth(this.buttonWidth),
                  child: buildAcceptButton("确定"),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildButton(String title, {String value}) {
    if (value == null) {
      value = title;
    }
    return Container(
      padding: Constants.paddingAll(0),
      height: Constants.getAdapterHeight(this.buttonHeight),
      width: Constants.getAdapterWidth(this.buttonWidth),
      child: RaisedButton(
        padding: Constants.paddingAll(0),
        color: Color(0xFFFFFFFF),
        elevation: 0.0,
        highlightColor: Color(0xFFD0D0D0),
        child: Text(title, style: TextStyles.getTextStyle(fontSize: 42, color: Constants.hexStringToColor("#444444"))),
        onPressed: () {
          if (controller != null) {
            controller.addText(value);
          }
        },
        shape: RoundedRectangleBorder(side: BorderSide(color: Color(0xFFD0D0D0), style: BorderStyle.solid), borderRadius: BorderRadius.all(Radius.circular(4))),
      ),
    );
  }

  Widget buildAcceptButton(String title, {String value}) {
    if (value == null) {
      value = title;
    }
    return Container(
      padding: Constants.paddingAll(0),
      height: Constants.getAdapterHeight(this.buttonHeight * 2 + this.buttonSpace),
      width: Constants.getAdapterWidth(this.buttonWidth),
      child: RaisedButton(
        padding: Constants.paddingAll(0),
        color: Color(0xFF7A73C7),
        elevation: 0.0,
        highlightColor: Color(0xFFD0D0D0),
        child: Text(title, style: TextStyles.getTextStyle(fontSize: 38, color: Color(0xFFFFFFFF))),
        onPressed: () {
          if (controller != null) {
            controller.nextAction();
          }
        },
        shape: RoundedRectangleBorder(side: BorderSide(color: Color(0xFF7A73C7), style: BorderStyle.solid), borderRadius: BorderRadius.all(Radius.circular(4))),
      ),
    );
  }

  Widget buildBackspace(String title, {String value}) {
    if (value == null) {
      value = title;
    }
    return Container(
      padding: Constants.paddingAll(0),
      height: Constants.getAdapterHeight(this.buttonHeight),
      width: Constants.getAdapterWidth(this.buttonWidth),
      child: RaisedButton(
        padding: Constants.paddingAll(0),
        color: Color(0xFFFFFFFF),
        elevation: 0.0,
        highlightColor: Color(0xFFD0D0D0),
        child: Icon(Icons.backspace, size: Constants.getAdapterWidth(42)),
        onPressed: () {
          if (controller != null) {
            controller.deleteOne();
          }
        },
        shape: RoundedRectangleBorder(side: BorderSide(color: Color(0xFFD0D0D0), style: BorderStyle.solid), borderRadius: BorderRadius.all(Radius.circular(4))),
      ),
    );
  }

  Widget buildClearAll(String title) {
    return Container(
      padding: Constants.paddingAll(0),
      height: Constants.getAdapterHeight(this.buttonHeight),
      width: Constants.getAdapterWidth(this.buttonWidth),
      child: RaisedButton(
        padding: Constants.paddingAll(0),
        color: Color(0xFFFFFFFF),
        elevation: 0.0,
        highlightColor: Color(0xFFD0D0D0),
        child: Text(title, style: TextStyles.getTextStyle(fontSize: 38)),
        onPressed: () {
          if (controller != null) {
            controller.clear();
          }
        },
        shape: RoundedRectangleBorder(
          side: BorderSide(color: Color(0xFFD0D0D0), style: BorderStyle.solid),
          borderRadius: BorderRadius.all(Radius.circular(4)),
        ),
      ),
    );
  }
}
