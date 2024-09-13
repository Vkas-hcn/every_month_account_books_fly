import 'package:every_month_account_books_fly/utils/ThisUtils.dart' show ThisUtils;
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/material.dart';


class Setting extends StatelessWidget {
  const Setting({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: WillPopScope(
        onWillPop: () async {
          print("object--------");
          Navigator.pop(context);
          return false;
        },
        child: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/img_bg_start.webp'),
              fit: BoxFit.cover,
            ),
          ),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 60.0, left: 20, right: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    GestureDetector(
                      onTap: () {
                        print("object11111111111");
                        Navigator.pop(context);
                      },
                      child: SizedBox(
                        width: 24,
                        height: 24,
                        child: Image.asset('assets/icon_title_back.webp'),
                      ),
                    ),
                    Spacer(),
                    const Text(
                      'Settings',
                      style: TextStyle(
                        color: Color(0xFF222222),
                        fontSize: 18,
                      ),
                    ),
                    Spacer(),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 32.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 56,
                      height: 56,
                      child: Image.asset('assets/logo_setting_image.webp'),
                    ),
                    SizedBox(height: 16),
                    const Text(
                      'App Name',
                      style: TextStyle(
                        color: Color(0xFF222222),
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                    left: 16, right: 16, top: 48, bottom: 12),
                child: GestureDetector(
                  onTap: () {
                    Share.share(
                        "https://book.flutterchina.club/chapter6/keepalive.html#_6-8-1-automatickeepalive");
                  },
                  child: Container(
                    height: 50,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(15),
                      child: Row(
                        children: [
                          Image.asset(
                              width: 20, height: 20, 'assets/icon_share.webp'),
                          const SizedBox(width: 12),
                          const Text(
                            'Share',
                            style: TextStyle(
                              color: Color(0xFF222222),
                              fontSize: 14,
                            ),
                          ),
                          const Spacer(),
                          Image.asset(
                              width: 20, height: 20, 'assets/icon_right.webp')
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 16, right: 16, bottom: 12),
                child: GestureDetector(
                  onTap: () {
                    launchUserAgreement();
                  },
                  child: Container(
                    height: 50,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(15),
                      child: Row(
                        children: [
                          Image.asset(
                              width: 20, height: 20, 'assets/icon_user.webp'),
                          const SizedBox(width: 12),
                          const Text(
                            'User Terms',
                            style: TextStyle(
                              color: Color(0xFF222222),
                              fontSize: 14,
                            ),
                          ),
                          const Spacer(),
                          Image.asset(
                              width: 20, height: 20, 'assets/icon_right.webp')
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 16, right: 16, bottom: 12),
                child: GestureDetector(
                  onTap: () {
                    launchURL();
                  },
                  child: Container(
                    height: 50,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(15),
                      child: Row(
                        children: [
                          Image.asset(
                              width: 20,
                              height: 20,
                              'assets/icon_privacy.webp'),
                          const SizedBox(width: 12),
                          const Text(
                            'Privacy Policy',
                            style: TextStyle(
                              color: Color(0xFF222222),
                              fontSize: 14,
                            ),
                          ),
                          const Spacer(),
                          Image.asset(
                              width: 20, height: 20, 'assets/icon_right.webp')
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void launchURL() async {
    const url =
        'https://play.google.com/store/apps/details?id=com.blooming.unlimited.fast';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      ThisUtils.showToast('Cant open web page $url');
    }
  }

  void launchComment() async {
    const url =
        'https://play.google.com/store/apps/details?id=com.blooming.unlimited.fast';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      ThisUtils.showToast('Cant open web page $url');
    }
  }

  void launchUserAgreement() async {
    const url =
        'https://play.google.com/store/apps/details?id=com.blooming.unlimited.fast';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      ThisUtils.showToast('Cant open web page $url');
    }
  }

  void restartApp(BuildContext context) {
    Navigator.of(context).removeRoute(ModalRoute.of(context) as Route);
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const Setting()),
            (route) => route == null);
  }
}

class CustomProgressIndicator extends StatelessWidget {
  final AnimationController controller;

  CustomProgressIndicator({required this.controller});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        return Stack(
          alignment: Alignment.centerLeft,
          children: [
            Container(
              width: 300,
              height: 12,
              decoration: BoxDecoration(
                color: Color(0x33000000), // Background color #33000000
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            Container(
              width: 300 * controller.value,
              height: 12,
              decoration: BoxDecoration(
                color: Color(0xFF262626), // Progress color #262626
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            Positioned(
              left: 300 * controller.value - 10,
              child: Container(
                width: 12,
                height: 12,
                decoration: BoxDecoration(
                  color: Color(0xFF47B96D),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Color(0xFF24753F), // Circle border color #262626
                    width: 2,
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
