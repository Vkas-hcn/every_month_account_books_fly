import 'package:every_month_account_books_fly/MainAccount.dart';
import 'package:every_month_account_books_fly/utils/LocalStorage.dart';
import 'package:flutter/material.dart';

void main() async{
  runApp(const Start());
}

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
  @override
  void initState() {
    super.initState();
    jumpToNextPaper();
  }

  void jumpToNextPaper() async {
    await Future.delayed(const Duration(seconds: 2));
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) =>  MainAccount()),
        (route) => route == null);
  }

  @override
  Widget build(BuildContext context) {
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
                  child: CircularProgressIndicator(color: Color(0xFFF3AA20)),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
