import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';

class HTTPClient {
  Future<List> makeRequest() async {
    HttpClient client = HttpClient();
    HttpClientRequest request = await client.getUrl(
        Uri.parse('https://604a08bd9251e100177cdbcb.mockapi.io/test/users'));
    HttpClientResponse response = await request.close();
    final completer = Completer<String>();
    StringBuffer content = StringBuffer();
    response.transform(Utf8Decoder()).listen((event) {
      content.write(event);
    }).onDone(() {
      completer.complete(content.toString());
    });
    String resp = await completer.future.then((value) => value);
    // debugPrint("resp=> ${json.decode(resp)}");
    return json.decode(resp);
  }
}
