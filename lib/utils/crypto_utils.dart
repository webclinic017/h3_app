import 'dart:convert';
import 'dart:typed_data';

import 'package:convert/convert.dart' as convert;
import 'package:crypto/crypto.dart' as crypto;

class Md5Utils {
  /// md5加密
  static String md5(String data) {
    var content = utf8.encode(data);
    var digest = crypto.md5.convert(content);
    // 这里其实就是 digest.toString()
    return convert.hex.encode(digest.bytes);
  }
}

class Sha1Utils {
  /// sha1加密
  static String sha1(String data) {
    var content = utf8.encode(data);
    var digest = crypto.sha1.convert(content);

    return convert.hex.encode(digest.bytes);
  }
}

class Base64Utils {
  /// base64加密字符串
  String base64EncodeString(String data) => base64Encode(utf8.encode(data));

  /// base64加密二进制
  String base64Encode(List<int> input) => base64.encode(input);

  /// base64解密字符串
  String base64DecodeString(String data) =>
      String.fromCharCodes(base64Decode(data));

  /// base64解密字符串
  Uint8List base64Decode(String encoded) => base64.decode(encoded);
}
