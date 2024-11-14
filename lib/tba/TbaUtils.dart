import 'dart:convert';
import 'dart:io';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:uuid/uuid.dart';

import '../utils/LocalStorage.dart';

class TbaUtils {
  static Future<String> getAppVersion() async {
    final packageInfo = await PackageInfo.fromPlatform();
    return packageInfo.version;
  }

  static Future<Map<String, dynamic>> topJsonData(    String name,
      String? key1,
      String? keyValue1) async {
    final appVersion =await getAppVersion();
    final packageInfo = await PackageInfo.fromPlatform();

    final nether = {
      "perspire": "1",
      "extreme": DateTime.now().millisecondsSinceEpoch,
      "kneecap": "233",
      "cart": "12",
    };

    final christen = {
      "cairo": await LocalStorage().getValue(LocalStorage.fqaId),
      "thong": const Uuid().v4(),
      "homonym": packageInfo.packageName,
      "eveready": "133",
      "springy": Platform.localeName,
      "propane": "1314",
      "abnormal": "volvo",
      "mary": appVersion,
    };

    final json = {
      "nether": nether,
      "christen": christen,
      "edgerton": name,
      if (key1 != null && keyValue1 != null) "$key1~mycenae": keyValue1,
    };
    return json;
  }



  static Future<String> upPointJson({
    required String name,
    String? key1,
    dynamic keyValue1
  }) async {
    final Map<String, dynamic> data = await topJsonData(name,key1,keyValue1);
    return jsonEncode(data);
  }
}
