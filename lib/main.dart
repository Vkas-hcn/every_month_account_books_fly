import 'package:every_month_account_books_fly/Start.dart';
import 'package:every_month_account_books_fly/ad/CCCllok.dart';
import 'package:every_month_account_books_fly/ad/ShowAdFun.dart';
import 'package:every_month_account_books_fly/tba/NetworkService.dart';
import 'package:every_month_account_books_fly/tba/Result.dart';
import 'package:every_month_account_books_fly/tba/TbaUtils.dart';
import 'package:every_month_account_books_fly/utils/LocalStorage.dart';
import 'package:every_month_account_books_fly/utils/ThisUtils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  MobileAds.instance.initialize();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) {
    runApp(MultiProvider(providers: [
      Provider<ShowAdFun>(
        create: (_) => ShowAdFun(),
      ),
      ChangeNotifierProvider(create: (_) => CCCllok()),
    ], child: const MyApp()));
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: ThisUtils.navigatorKey, // 设置全局 navigatorKey
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    super.initState();
    print("object=================main");
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final adUtils = Provider.of<CCCllok>(context, listen: false);
      CCCllok.initializeFqaId();
      adUtils.getBlackList(context);
      pageToHome();
      sendRequest();
    });
  }

// 调用 upPointJson 方法准备请求体
  Future<void> sendRequest() async {
    try {
      await CCCllok.generateRandomFourDigitNumber();
      String? id = await LocalStorage().getValue(LocalStorage.userID);
      // 准备请求体数据
      final requestBody = await TbaUtils.upPointJson(
        name: "a_p_op",
        key1: "kd",
        keyValue1: id,
      );
      print("object-id-$id");
      print("入参--：${requestBody}");

      // 使用 postNetwork 方法发送请求
      final result = await NetworkService.postNetwork(requestBody);

      // 处理请求结果
      if (result.isSuccess) {
        print("请求成功，响应数据：${result.data}");
      } else {
        print("请求失败，错误信息：${result.error}");
      }
    } catch (e) {
      print("请求过程中发生异常：$e");
    }
  }

  void pageToHome() {
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const Start()),
        (route) => route == null);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: WillPopScope(
        onWillPop: () async => false,
        child: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/img_bg_start.webp'),
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
    );
  }
}
