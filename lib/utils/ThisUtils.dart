import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart'; // 需要先引入 intl 包

class ThisUtils {
  static int selectedIndex = 1;
  static void onItemTapped(int index, BuildContext context) {
    selectedIndex = index;
    // 刷新 MainPage 的状态
    (context as Element).markNeedsBuild();
  }
  static void showToast(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.black,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }

  static String getCurrentDateFormatted() {
    DateTime now = DateTime.now();
    // 格式化日期为 yyyy-MM-dd
    String formattedDate = DateFormat('yyyy-MM-dd').format(now);
    return formattedDate;
  }

  // 类别名称列表
  static final List<String> categories = [
    'Others',
    'Dining',
    'Transportation',
    'Alcoholic Drinks',
    'Fruits',
    'Snacks',
    'Vegetables',
    'Clothing',
    'emotion',
    'Travel',
    'Electronic Devices',
    'Medical',
    'Entertainment',
    'Daily Necessities',
    'Pets',
  ];

  static final List<String> categoriesImage = [
    'assets/icon_expenses_01.webp',
    'assets/icon_expenses_02.webp',
    'assets/icon_expenses_03.webp',
    'assets/icon_expenses_04.webp',
    'assets/icon_expenses_05.webp',
    'assets/icon_expenses_06.webp',
    'assets/icon_expenses_07.webp',
    'assets/icon_expenses_08.webp',
    'assets/icon_expenses_09.webp',
    'assets/icon_expenses_10.webp',
    'assets/icon_expenses_11.webp',
    'assets/icon_expenses_12.webp',
    'assets/icon_expenses_13.webp',
    'assets/icon_expenses_14.webp',
    'assets/icon_expenses_15.webp',
  ];

  static final List<String> categoriesIncome = [
    'Others',
    'Salary',
    'Refund',
    'Part-time Job',
    'Investment',
    'Bonus',
    'Pocket Money',
  ];

  static final List<String> categoriesImageIncome = [
    'assets/icon_expenses_01.webp',
    'assets/icon_income_01.webp',
    'assets/icon_income_02.webp',
    'assets/icon_income_03.webp',
    'assets/icon_income_04.webp',
    'assets/icon_income_05.webp',
    'assets/icon_income_06.webp',
  ];
 static String convertMonthToEnglish(String month) {
    switch (month) {
      case "01":
        return 'January';
      case "02":
        return 'February';
      case "03":
        return 'March';
      case "04":
        return 'April';
      case "05":
        return 'May';
      case "06":
        return 'June';
      case "07":
        return 'July';
      case "08":
        return 'August';
      case "09":
        return 'September';
      case "10":
        return 'October';
      case "11":
        return 'November';
      case "12":
        return 'December';
      default:
        return 'Invalid month';
    }
  }
}
