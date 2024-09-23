import 'package:every_month_account_books_fly/Start.dart';
import 'package:every_month_account_books_fly/ad/CCCllok.dart';
import 'package:every_month_account_books_fly/ad/ShowAdFun.dart';
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
      CCCllok.initializeFqaId();
      pageToHome();
    });
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
