import 'dart:async';

import 'package:every_month_account_books_fly/MainAccount.dart';
import 'package:every_month_account_books_fly/ad/ShowAdFun.dart';
import 'package:every_month_account_books_fly/tba/NetworkService.dart';
import 'package:every_month_account_books_fly/tba/TbaUtils.dart';
import 'package:every_month_account_books_fly/utils/LocalStorage.dart';
import 'package:every_month_account_books_fly/utils/ThisUtils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'ad/CCCllok.dart';
import 'ad/LTFDW.dart';

class Start extends StatelessWidget {
  const Start({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late LTFDW Ltfdw;
  bool restartState = false;
  DateTime? _pausedTime;
  late ShowAdFun adManager;

  @override
  void initState() {
    super.initState();
    adManager = ThisUtils.getMobUtils(context);
    Ltfdw = LTFDW(
      onAppResumed: _handleAppResumed,
      onAppPaused: _handleAppPaused,
    );
    WidgetsBinding.instance.addObserver(Ltfdw);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      initAdData();
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
  void initAdData() async {
    final adUtils = Provider.of<CCCllok>(context, listen: false);
    adUtils.getBlackList(context);
    sendRequest();
    adManager.loadAd(AdWhere.OPENINT);
    adManager.loadAd(AdWhere.SAVE);
    Future.delayed(const Duration(seconds: 1), () {
      showOpenAd();
    });
  }

  void showOpenAd() async {
    int elapsed = 0;
    const int timeout = 10000;
    const int interval = 500;
    print("准备展示open广告");
    bool colckState = await ShowAdFun.blacklistBlocking();
    if (colckState) {
      //等待2秒后执行
      Future.delayed(const Duration(seconds: 2), () {
        print("直接进入首页");
        jumpToNextPaper();
      });
      return;
    }
    Timer.periodic(const Duration(milliseconds: interval), (timer) {
      elapsed += interval;
      if (adManager.canShowAd(AdWhere.OPENINT)) {
        adManager.showAd(context, AdWhere.OPENINT, () {
          print("关闭广告-------");
          jumpToNextPaper();
        });
        timer.cancel();
      } else if (elapsed >= timeout) {
        print("超时，直接进入首页");
        jumpToNextPaper();
        timer.cancel();
      }
    });
  }

  void _handleAppResumed() {
    if (!LocalStorage.isInBack) {
      return;
    }
    LocalStorage.isInBack = false;
    print("应用恢复前台");
    if (_pausedTime != null) {
      final timeInBackground =
          DateTime.now().difference(_pausedTime!).inSeconds;
      if (LocalStorage.clone_ad == true) {
        return;
      }

      print("应用恢复前台---${timeInBackground}===${LocalStorage.int_ad_show}");
      if (timeInBackground > 3 && LocalStorage.int_ad_show == false) {
        print("热启动");
        restartState = true;
        restartApp();
      }
    }
  }

  void _handleAppPaused() {
    LocalStorage.isInBack = true;
    print("应用进入后台");
    LocalStorage.clone_ad = false;
    _pausedTime = DateTime.now();
  }

  void jumpToNextPaper() async {
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => MainAccount()),
        (route) => route == null);
  }

  void restartApp() {
    ThisUtils.navigatorKey.currentState?.pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => const Start()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Provider<ShowAdFun>(
      create: (_) => ThisUtils.getMobUtils(context),
      builder: (newContext, child) {
        adManager = newContext.watch<ShowAdFun>();
        //...其他代码
        return WillPopScope(
          onWillPop: () async {
            return false;
          },
          child: Scaffold(
            body: Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/img_bg_start.webp'),
                  fit: BoxFit.cover,
                ),
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(
                      width: 120,
                      height: 120,
                      child: Image.asset('assets/start_logo.webp'),
                    ),
                    const Text(
                      'App Name',
                      style: TextStyle(
                        fontSize: 24,
                        color: Colors.black,
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.only(top: 129),
                      child:
                          CircularProgressIndicator(color: Color(0xFFF3AA20)),
                    )
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
