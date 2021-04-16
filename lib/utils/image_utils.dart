import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as client;
import 'package:image/image.dart' as img;

import '../constants.dart';

class ImageUtils {
  static ImageProvider getAssetImage(String name, {String format: 'png'}) {
    return AssetImage(getImgPath(name, format: format));
  }

  static String getImgPath(String name, {String format: 'png'}) {
    return 'assets/images/$name.$format';
  }

  static String getImageBase64(File image) {
    var bytes = image.readAsBytesSync();
    var base64 = base64Encode(bytes);
    return base64;
  }

  static File getImageFile(String base64) {
    var bytes = base64Decode(base64);
    return File.fromRawPath(bytes);
  }

  static Uint8List getImageByte(String base64) {
    return base64Decode(base64);
  }

  static const RollupSize_Units = ["GB", "MB", "KB", "B"];

  static String getRollupSize(int size) {
    int idx = 3;
    int r1 = 0;
    String result = "";
    while (idx >= 0) {
      int s1 = size % 1024;
      size = size >> 10;
      if (size == 0 || idx == 0) {
        r1 = (r1 * 100) ~/ 1024;
        if (r1 > 0) {
          if (r1 >= 10)
            result = "$s1.$r1${RollupSize_Units[idx]}";
          else
            result = "$s1.0$r1${RollupSize_Units[idx]}";
        } else
          result = s1.toString() + RollupSize_Units[idx];
        break;
      }
      r1 = s1;
      idx--;
    }
    return result;
  }

  static Future<void> downloadFiles(String url,
      {String dir = Constants.IMAGE_PATH}) async {
    assert(url != null && url.isNotEmpty);

    File _file = File("$dir/${getNameOnly(url)}");
    var isExists = await _file.exists();

    if (!isExists) {
      final httpClient = client.Client();
      final response = await httpClient.get(url);
      if (response.statusCode == 200) {
        print("success");
        //扩展名
        final extension = _filterUrlGetExtension(url);
        //store download image in local storage
        _storeImageInLocalStorage(dir,
            extension: extension,
            bytesFile: response.bodyBytes,
            fileNameUrl: url);
      } else {
        print("failure");
      }
    } else {
      print("文件已经下载，忽略本次下载");
    }
  }

  static void _storeImageInLocalStorage(String dir,
      {File file,
      List<int> bytesFile,
      String extension,
      String fileNameUrl}) async {
    //
    if (file != null) {
      try {
        //covert file into bytes
        final bytes = await file.readAsBytes();
        //bytes into image format
        final image = img.decodeImage(bytes);
        //save image
        File("$dir/${getNameOnly(file.path)}")
          ..writeAsBytesSync(img.encodeJpg(image, quality: 95));
        //notify message optional
        print("file store byte Lenth is ${bytes.length}");
      } catch (e) {
        print("errorImage is : ${e.toString()}");
      }
    } else {
      final image = img.decodeImage(bytesFile);
      File("$dir/${getNameOnly(fileNameUrl)}")
        ..writeAsBytesSync(img.encodeJpg(image, quality: 95));
      print("file store byte Lenth is ${bytesFile.length}");
    }
  }

  //filter Url get extension of eg : pdf or png
  static String _filterUrlGetExtension(String path) {
    return path.split('/').last.split('.').last;
  }

  //get file name eg : xyz.png or xyz.pdf
  static String getNameOnly(String path) {
    return path.split('/').last;
  }
}
