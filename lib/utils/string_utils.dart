class StringUtils {
  /// Returns [true] if [s] is either null, empty or is solely made of whitespace
  /// characters (as defined by [String.trim]).
  static bool isBlank(String s) => s == null || s.trim().isEmpty;

  /// Returns [true] if [s] is neither null, empty nor is solely made of whitespace
  /// characters.
  ///
  /// See also:
  ///
  ///  * [isBlank]
  static bool isNotBlank(String s) => s != null && s.trim().isNotEmpty;

  /// Returns [true] if [s] is either null or empty.
  static bool isEmpty(String s) => s == null || s.isEmpty;

  /// Returns [true] if [s] is a not empty string.
  static bool isNotEmpty(String s) => s != null && s.isNotEmpty;

  /// Returns a string with characters from the given [s] in reverse order.
  ///
  /// NOTE: without full support for unicode composed character sequences,
  /// sequences including zero-width joiners, etc. this function is unsafe to
  /// use. No replacement is provided.
  static String _reverse(String s) {
    if (s == null || s == '') return s;
    StringBuffer sb = new StringBuffer();
    var runes = s.runes.iterator..reset(s.length);
    while (runes.movePrevious()) {
      sb.writeCharCode(runes.current);
    }
    return sb.toString();
  }

  /// Loops over [s] and returns traversed characters. Takes arbitrary [from] and
  /// [to] indices. Works as a substitute for [String.substring], except it never
  /// throws [RangeError]. Supports negative indices. Think of an index as a
  /// coordinate in an infinite in both directions vector filled with repeating
  /// string [s], whose 0-th coordinate coincides with the 0-th character in [s].
  /// Then [loop] returns the sub-vector defined by the interval ([from], [to]).
  /// [from] is inclusive. [to] is exclusive.
  ///
  /// This method throws exceptions on [null] and empty strings.
  ///
  /// If [to] is omitted or is [null] the traversing ends at the end of the loop.
  ///
  /// If [to] < [from], traverses [s] in the opposite direction.
  ///
  /// For example:
  ///
  /// loop('Hello, World!', 7) == 'World!'
  /// loop('ab', 0, 6) == 'ababab'
  /// loop('test.txt', -3) == 'txt'
  /// loop('ldwor', -3, 2) == 'world'
  static String loop(String s, int from, [int to]) {
    if (s == null || s == '') {
      throw new ArgumentError('Input string cannot be null or empty');
    }
    if (to != null && to < from) {
      // TODO(cbracken): throw ArgumentError in this case.
      return loop(_reverse(s), -from, -to);
    }
    int len = s.length;
    int leftFrag = from >= 0 ? from ~/ len : ((from - len) ~/ len);
    if (to == null) {
      to = (leftFrag + 1) * len;
    }
    int rightFrag = to - 1 >= 0 ? to ~/ len : ((to - len) ~/ len);
    int fragOffset = rightFrag - leftFrag - 1;
    if (fragOffset == -1) {
      return s.substring(from - leftFrag * len, to - rightFrag * len);
    }
    StringBuffer sink = new StringBuffer(s.substring(from - leftFrag * len));
    _repeat(sink, s, fragOffset);
    sink.write(s.substring(0, to - rightFrag * len));
    return sink.toString();
  }

  static void _repeat(StringBuffer sink, String s, int times) {
    for (int i = 0; i < times; i++) {
      sink.write(s);
    }
  }

  /// Returns `true` if [rune] represents a digit.
  ///
  /// The definition of digit matches the Unicode `0x3?` range of Western
  /// European digits.
  static bool isDigit(int rune) => rune ^ 0x30 <= 9;

  /// Returns `true` if [rune] represents a whitespace character.
  ///
  /// The definition of whitespace matches that used in [String.trim] which is
  /// based on Unicode 6.2. This maybe be a different set of characters than the
  /// environment's [RegExp] definition for whitespace, which is given by the
  /// ECMAScript standard: http://ecma-international.org/ecma-262/5.1/#sec-15.10
  static bool isWhitespace(int rune) => ((rune >= 0x0009 && rune <= 0x000D) || rune == 0x0020 || rune == 0x0085 || rune == 0x00A0 || rune == 0x1680 || rune == 0x180E || (rune >= 0x2000 && rune <= 0x200A) || rune == 0x2028 || rune == 0x2029 || rune == 0x202F || rune == 0x205F || rune == 0x3000 || rune == 0xFEFF);

  /// Returns a [String] of length [width] padded with the same number of
  /// characters on the left and right from [fill].  On the right, characters are
  /// selected from [fill] starting at the end so that the last character in
  /// [fill] is the last character in the result. [fill] is repeated if
  /// neccessary to pad.
  ///
  /// Returns [input] if `input.length` is equal to or greater than width.
  /// [input] can be `null` and is treated as an empty string.
  ///
  /// If there are an odd number of characters to pad, then the right will be
  /// padded with one more than the left.
  static String center(String input, int width, String fill) {
    if (fill == null || fill.length == 0) {
      throw new ArgumentError('fill cannot be null or empty');
    }
    if (input == null) input = '';
    if (input.length >= width) return input;

    var padding = width - input.length;
    if (padding ~/ 2 > 0) {
      input = loop(fill, 0, padding ~/ 2) + input;
    }
    return input + loop(fill, input.length - width, 0);
  }

  /// Returns `true` if [a] and [b] are equal after being converted to lower
  /// case, or are both null.
  static bool equalsIgnoreCase(String a, String b) => (a == null && b == null) || (a != null && b != null && a.toLowerCase() == b.toLowerCase());

  /// Compares [a] and [b] after converting to lower case.
  ///
  /// Both [a] and [b] must not be null.
  static int compareIgnoreCase(String a, String b) => a.toLowerCase().compareTo(b.toLowerCase());

  /// 每隔 x位 加 pattern
  static String formatDigitPattern(String text, {int digit = 4, String pattern = ' '}) {
    text = text?.replaceAllMapped(new RegExp("(.{$digit})"), (Match match) {
      return "${match.group(0)}$pattern";
    });
    if (text != null && text.endsWith(pattern)) {
      text = text.substring(0, text.length - 1);
    }
    return text;
  }

  /// 每隔 x位 加 pattern, 从末尾开始
  static String formatDigitPatternEnd(String text, {int digit = 4, String pattern = ' '}) {
    String temp = reverse(text);
    temp = formatDigitPattern(temp, digit: 3, pattern: ',');
    temp = reverse(temp);
    return temp;
  }

  /// 每隔4位加空格
  static String formatSpace4(String text) {
    return formatDigitPattern(text);
  }

  /// 每隔3三位加逗号
  /// num 数字或数字字符串。int型。
  static String formatComma3(Object num) {
    return formatDigitPatternEnd(num?.toString(), digit: 3, pattern: ',');
  }

  /// hideNumber
  static String hideNumber(String phoneNo, {int start = 3, int end = 7, String replacement = '****'}) {
    return phoneNo?.replaceRange(start, end, replacement);
  }

  /// replace
  static String replace(String text, Pattern from, String replace) {
    return text?.replaceAll(from, replace);
  }

  /// split
  static List<String> split(String text, Pattern pattern, {List<String> defValue = const []}) {
    List<String> list = text?.split(pattern);
    return list ?? defValue;
  }

  /// reverse
  static String reverse(String text) {
    if (isEmpty(text)) return '';
    StringBuffer sb = StringBuffer();
    for (int i = text.length - 1; i >= 0; i--) {
      sb.writeCharCode(text.codeUnitAt(i));
    }
    return sb.toString();
  }

  /// Remove illegal XML characters from a string.
  static String sanitizeXmlString(String xml) {
    if (xml == null) {
      throw ArgumentError.notNull("xml");
    }

    var buffer = StringBuffer();
    for (String c in xml.split("")) {
      if (isLegalXmlChar(c.codeUnitAt(0))) {
        buffer.writeCharCode(c.codeUnitAt(0));
      }
    }
    return buffer.toString();
  }

  /// Whether a given character is allowed by XML 1.0.
  static bool isLegalXmlChar(int asciiCode) {
    // == '\t' == 9
    // == '\n' == 10
    // == '\r' == 13
    return (asciiCode == 9 || asciiCode == 10 || asciiCode == 13 || (asciiCode >= 32 && asciiCode <= 55295) || (asciiCode >= 57344 && asciiCode <= 65533) || (asciiCode >= 65536 && asciiCode <= 1114111));
  }

  static String trimAll(String text) {
    if (text == null) {
      return text;
    }
    if (text.isEmpty) {
      return text;
    }
    var result = text.trim();
    if (result.isEmpty) {
      return result;
    }
    if (result.startsWith("\n")) {
      return trimAll(result.substring(1));
    }
    if (result.startsWith("\t")) {
      return trimAll(result.substring(1));
    }
    if (result.endsWith("\n")) {
      return trimAll(result.substring(0, result.length - 1));
    }
    if (result.endsWith("\t")) {
      return trimAll(result.substring(0, result.length - 1));
    }
    return result;
  }

  static String trimStart(String text, int charCode) {
    if (text == null) return text;
    if (charCode == null) return text;
    var char = String.fromCharCode(charCode);
    while (text.startsWith(char)) {
      text = text.substring(1);
    }
    return text;
  }

  static String trimEnd(String text, int charCode) {
    if (text == null) return text;
    if (charCode == null) return text;
    var char = String.fromCharCode(charCode);
    while (text.endsWith(char)) {
      text = text.substring(0, text.length - 1);
    }
    return text;
  }

  static bool isNumeric(String s) {
    if (s == null) {
      return false;
    }

    // TODO according to DartDoc num.parse() includes both (double.parse and int.parse)
    return double.parse(s, (e) => null) != null || int.parse(s, onError: (e) => null) != null;
  }
}
