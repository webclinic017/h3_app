part of logger;

class LoggerServer {
  final HttpClient _httpClient = new HttpClient();
  LoggerConfig _config;
  LoggerServer._();

  static final LoggerServer _singleton = LoggerServer._();

  static LoggerServer getInstance(LoggerConfig config) {
    _singleton._config = config;
    return _singleton;
  }

  void upload(Log log) async {
    String url = _config.serverUrl;
    if (url != null && url.isNotEmpty) {
      try {
        PackageInfo packageInfo = await PackageInfo.fromPlatform();

        String appName = packageInfo.appName;
        String packageName = packageInfo.packageName;
        String version = packageInfo.version;
        String buildNumber = packageInfo.buildNumber;

        _httpClient.postUrl(Uri.parse(url)).then((HttpClientRequest request) {
          request.headers.removeAll(HttpHeaders.acceptEncodingHeader);

          request.headers.set(HttpHeaders.contentTypeHeader, 'text/plain');

          var auth = new QiniuAuth("ngDPUPRb5JHDxjseTaHLW_1d-upse3xqbAIlRqOd", "3oGAeNCPreLoUGrh06sDAgMSOi_i53Lx8R39eFk2");
          var headers = new Map<String, String>();
          headers[QiniuAuth.ContentType] = "text/plain";
          var token = auth.SignRequest(url, "POST", headers);

          request.headers.set(HttpHeaders.authorizationHeader, token);

          // request.add(utf8.encode("tenantId=${Global.instance.authc?.tenantId ?? ''}\t"));
          // request.add(utf8.encode("storeNo=${Global.instance.authc?.storeNo ?? ''}\t"));
          // request.add(utf8.encode("storeName=${Global.instance.authc?.storeName ?? ''}\t"));
          // request.add(utf8.encode("posNo=${Global.instance.authc?.posNo ?? ''}\t"));
          request.add(utf8.encode("appSign=${Constants.APP_SIGN}\t"));
          request.add(utf8.encode("message=${log.message}\t"));
          request.add(utf8.encode("version=$version\t"));

          return request.close();
        }).then((HttpClientResponse response) {});

//        var request = await _httpClient.postUrl(Uri.parse(url));
//
//        request.headers.set('Content-Type', 'text/plain');
//        var auth = new QiniuAuth("ngDPUPRb5JHDxjseTaHLW_1d-upse3xqbAIlRqOd", "3oGAeNCPreLoUGrh06sDAgMSOi_i53Lx8R39eFk2");
//        var headers = new Map<String, String>();
//        headers[QiniuAuth.ContentType] = "text/plain";
//        var token = auth.SignRequest(url, "POST", headers);
//
//        request.headers.set('Authorization', token);
//
//        print(token);
//        //request.add(utf8.encode("message=${json.encode(log.toJson())}\t"));
//
//        request.add(utf8.encode("message=${log.message}\t"));
//
//        var response = await request.close();
//        if (response.statusCode == HttpStatus.ok) {
//          var json = await response.transform(utf8.decoder).join();
//          var data = jsonDecode(json);
//          print(data);
//        } else {
//          print('Error getting IP address:\nHttp status ${response.statusCode}');
//        }
      } catch (ex) {
        print(ex.toString());
        print('Failed getting IP address');
      } finally {
        //_httpClient.close();
      }
    }
  }
}

class QiniuAuth {
  static const String ContentType = "Content-Type";
  static const String ContentMD5 = "Content-MD5";
  static const String Date = "Date";
  static const String Authorization = "Authorization";

  final String accessKey;

  final String secretKey;

  QiniuAuth(this.accessKey, this.secretKey);

  String SignRequest(String url, String method, Map<String, String> headers) {
    Map<String, dynamic> tokenDesc = new Map<String, dynamic>();
    //filter the qiniu heades
    List<String> qiniuHeaderKeys = new List<String>();
    for (String key in headers.keys) {
      if (key.startsWith("X-Qiniu-")) {
        qiniuHeaderKeys.add(key);
      }
    }
    qiniuHeaderKeys.sort();
    String canHeadersStr;
    if (qiniuHeaderKeys.length > 0) {
      List<String> canHeaders = new List<String>();
      for (String key in qiniuHeaderKeys) {
        canHeaders.add("${key.toLowerCase()}:${headers[key]}");
      }
      canHeadersStr = canHeaders.join("\n");
    }
    if (canHeadersStr != null && canHeadersStr.isNotEmpty) {
      tokenDesc["headers"] = canHeadersStr;
    }

    //check other headers
    if (headers.containsKey(ContentType)) {
      tokenDesc["contentType"] = headers[ContentType];
    }
    if (headers.containsKey(ContentMD5)) {
      tokenDesc["contentMD5"] = headers[ContentMD5];
    }
    Uri reqURI = Uri.parse(url);
    tokenDesc["resource"] = reqURI.path;
    tokenDesc["method"] = method;
    tokenDesc["expires"] = DateTime.now().millisecondsSinceEpoch + 24 * 60 * 60 * 7;
    String tokenDescData = json.encode(tokenDesc);

    var encodedData = safeBase64Encode(tokenDescData);

    var sign = encodedSign(encodedData);

    return "Pandora ${this.accessKey}:$sign:$encodedData";
  }

  String encodedSign(String str) {
    List<int> hmacSha1 = hmacsha1(str, this.secretKey);
    return base64.encode(hmacSha1).replaceAll('+', '-').replaceAll('/', '_');
  }

  String safeBase64Encode(String text) {
    var data = utf8.encode(text);
    var base64String = base64.encode(data);
    return base64String.replaceAll('+', '-').replaceAll('/', '_');
  }

  List<int> hmacsha1(String data, String key) {
    var vkey = utf8.encode(key);
    var vdata = utf8.encode(data);

    var hmacSha1 = new Hmac(sha1, vkey);
    var digest = hmacSha1.convert(vdata);
    return digest.bytes;
  }
}
