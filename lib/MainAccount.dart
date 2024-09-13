import 'package:every_month_account_books_fly/Setting.dart';
import 'package:every_month_account_books_fly/utils/ThisUtils.dart';
import 'package:flutter/material.dart';
import 'AddPage.dart';
import 'HomePage.dart';
import 'BillPage.dart';



class MainAccount extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MainPage(),
    );
  }
}

class MainPage extends StatefulWidget {
  static final GlobalKey<_MainPageState> mainPageKey = GlobalKey<_MainPageState>();
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {

  final List<Widget> _pages = [AddPage(), const HomePage(), BillPage()];

  void _onItemTapped(int index) {
    setState(() {
      ThisUtils.selectedIndex = index;
    });
  }
  void refresh() {
    print("refresh");
    setState(() {});
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[ThisUtils.selectedIndex],
      bottomNavigationBar: ThisUtils.selectedIndex<=2?BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Image.asset(
              ThisUtils.selectedIndex == 0
                  ? 'assets/icon_add_on.webp'
                  : 'assets/icon_add_off.webp',
              width: 32,
              height: 32,
              fit: BoxFit.contain,
            ),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Image.asset(
              ThisUtils.selectedIndex == 1
                  ? 'assets/icon_home_on.webp'
                  : 'assets/icon_home_off.webp',
              width: 32,
              height: 32,
              fit: BoxFit.contain,
            ),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Image.asset(
              ThisUtils.selectedIndex == 2
                  ? 'assets/icon_data_on.webp'
                  : 'assets/icon_data_off.webp',
              width: 32,
              height: 32,
              fit: BoxFit.contain,
            ),
            label: '',
          ),
        ],
        currentIndex: ThisUtils.selectedIndex, // 当前选中的索引
        onTap: (index) => ThisUtils.onItemTapped(index, context), // 调用静态方法
        selectedItemColor: Colors.white,
        unselectedItemColor: const Color(0x80FFFFFF),
        showUnselectedLabels: true, // 隐藏未选中按钮的标签
      ):null,
    );
  }
}
