import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:uuid/uuid.dart';

import '../utils/LocalStorage.dart';
import 'package:http/http.dart' as http;

class CCCllok with ChangeNotifier {
  static const String BLACK_URL =
      "https://apologia.dailybudget.link/saw/almighty/oedipal";
  static String fqaId = "";

  static String getUUID() {
    var uuid = Uuid();
    return uuid.v4();
  }

  static void initializeFqaId() {
    if (fqaId.isEmpty) {
      fqaId = getUUID();
    }
  }

  Future<void> getBlackList(BuildContext context) async {
    String? data =await LocalStorage().getValue(LocalStorage.clockData);
    print("Blacklist data=${data}");

    if (data != null) {
      return;
    }
    final mapData = await cloakMapData(context);
    try {
      final response = await getMapData(BLACK_URL, mapData);
      LocalStorage().setValue(LocalStorage.clockData,response);
      notifyListeners();
    } catch (error) {
      print("请求出错---》$error");
    }
  }


  Future<Map<String, dynamic>> cloakMapData(BuildContext context) async {
    return {
      "bolton": "com.dailybudget.honey.expensetrack",
      "rwanda": "sick",
      "showmen": await getAppVersion(context),
      "enrico": fqaId,
      "dialup": DateTime.now().millisecondsSinceEpoch,
    };
  }

  Future<String> getAppVersion(BuildContext context) async {
    final packageInfo = await PackageInfo.fromPlatform();
    return packageInfo.version;
  }

  Future<String> getMapData(String url, Map<String, dynamic> map) async {
    print("开始请求---${map}");
    final queryParameters = map.entries
        .map((entry) =>
    '${Uri.encodeComponent(entry.key)}=${Uri.encodeComponent(entry.value.toString())}')
        .join('&');

    final urlString =
    url.contains("?") ? "$url&$queryParameters" : "$url?$queryParameters";
    print("object-urlString=${urlString}");
    final response = await http.get(Uri.parse(urlString));

    if (response.statusCode == 200) {
      print("请求结果：${response.body}");
      return response.body;
    } else {
      print("请求出错：HTTP error: ${response.statusCode}");

      throw HttpException('HTTP error: ${response.statusCode}');
    }
  }
  // Future<void> sendPostRequest(Map<String, dynamic> jsonData) async {
  //   // The API endpoint URL
  //   final url = Uri.parse('https://example.com/api/post');
  //
  //   // Headers (optional)
  //   final headers = {
  //     'Content-Type': 'application/json',
  //     'Accept': 'application/json',
  //   };
  //
  //   try {
  //     // Sending POST request
  //     final response = await http.post(
  //       url,
  //       headers: headers,
  //       body: jsonEncode(jsonData), // Encode the JSON data
  //     );
  //
  //     // Check if the request was successful
  //     if (response.statusCode == 200) {
  //       // Handle success
  //       print('Response: ${response.body}');
  //     } else {
  //       // Handle error
  //       print('Error: ${response.statusCode}');
  //     }
  //   } catch (e) {
  //     print('Exception occurred: $e');
  //   }
  // }

  void retry(BuildContext context) async {
    await Future.delayed(Duration(seconds: 10));
    await getBlackList(context);
  }
}
