import 'package:every_month_account_books_fly/utils/LocalStorage.dart';
import 'package:every_month_account_books_fly/utils/ThisUtils.dart';
import 'package:every_month_account_books_fly/utils/ZhiShou.dart';
import 'package:flutter/material.dart';

import 'DatePickerBottomSheet.dart';
import 'NumberInputWidget.dart';

class AddPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ToggleButtonExample();
  }
}

class ToggleButtonExample extends StatefulWidget {
  @override
  _ToggleButtonExampleState createState() => _ToggleButtonExampleState();
}

class _ToggleButtonExampleState extends State<ToggleButtonExample> {
  bool isExpensesSelected = true;

  int selectedIndex = -1;

  String selectedDateText = "";

  @override
  void initState() {
    super.initState();
    selectedDateText = ThisUtils.getCurrentDateFormatted();
    print("selectedDateText===${selectedDateText}");
  }

  String getZhiOrShou() {
    if (isExpensesSelected) {
      return "zhi";
    } else {
      return "shou";
    }
  }

  void addAccountFun(String num) async {
    if (selectedIndex < 0) {
      ThisUtils.showToast("Please select a type!");
      return;
    }
    if (num.isEmpty) {
      ThisUtils.showToast("The amount is incorrect");
      return;
    }
    RegExp regExp = RegExp(r'^[0-9]+(\.[0-9]+)?$');
    if (!regExp.hasMatch(num)) {
      ThisUtils.showToast("Please enter a valid number");
      return;
    }
    double? amount = double.tryParse(num);

    // 从本地读取数据
    String? jsonStr = await LocalStorage().getValue(LocalStorage.accountJson);

    // 解析本地数据
    List<RecordBean> records = RecordBean.parseRecords(jsonStr);

    // 添加一条新数据
    if (records.isNotEmpty) {
      records[0].addDataByDate(selectedDateText, getZhiOrShou(),
          selectedIndex.toString(), amount.toString(), records);
    } else {
      // 如果本地没有记录，创建一个新的记录
      RecordBean newRecord = RecordBean(
        monthlyData: {},
        dateMonth: selectedDateText.substring(0, 7),
        yu: '50',
      );
      newRecord.addDataByDate(selectedDateText, getZhiOrShou(),
          selectedIndex.toString(), amount.toString(), records);
      records.add(newRecord);
    }
    String? datra = await LocalStorage().getValue(LocalStorage.accountJson);
    print("打印当前shuju ---${datra}");
    ThisUtils.showToast("Added successfully!");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFFF4E0),
      body: Padding(
        padding: const EdgeInsets.only(top: 45.0),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Center(
                child: Container(
                  padding: EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: Color(0xFFECE0C6), // 背景颜色 #ECE0C6
                    borderRadius: BorderRadius.circular(16), // 外层圆角16
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: _buildToggleButton(
                          text: 'Expenses',
                          isSelected: isExpensesSelected,
                          onTap: () {
                            selectedIndex = -1;
                            setState(() {
                              isExpensesSelected = true;
                            });
                          },
                        ),
                      ),
                      Expanded(
                        child: _buildToggleButton(
                          text: 'Income',
                          isSelected: !isExpensesSelected,
                          onTap: () {
                            selectedIndex = -1;
                            setState(() {
                              isExpensesSelected = false;
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20, right: 20, top: 4),
              child: GestureDetector(
                onTap: () async {
                  final selectedDate = await showDatePickerBottomSheet(context);

                  if (selectedDate != null) {
                    print('用户选择的日期: $selectedDate');
                    setState(() {
                      selectedDateText = selectedDate;
                    });
                  }
                },
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 8, horizontal: 8),
                      decoration: BoxDecoration(
                        color: const Color(0xFFECE0C6),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: 24,
                            height: 24,
                            child: Image.asset('assets/icon_date_fill.webp'),
                          ),
                          SizedBox(width: 8),
                          Text(
                            selectedDateText,
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(width: 16),
                          SizedBox(
                            width: 20,
                            height: 20,
                            child: Image.asset('assets/icon_direction.webp'),
                          ),
                        ],
                      ),
                    ),
                    Spacer(),
                    SizedBox(
                      width: 96,
                      height: 72,
                      child: Image.asset('assets/img_bee_add.webp'),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20.0, right: 20),
              child: Container(
                height: 1,
                width: double.infinity,
                color: Color(0xFFE6DDCA),
              ),
            ),
            Expanded(
              flex: 3,
              child: GridView.count(
                crossAxisCount: 5,
                mainAxisSpacing: 30,
                children: List.generate(
                  isExpensesSelected
                      ? ThisUtils.categories.length
                      : ThisUtils.categoriesIncome.length,
                  (index) {
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedIndex = index;
                        });
                      },
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(0),
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                  color: selectedIndex == index
                                      ? Color(0xFFF3AA20)
                                      : Colors.transparent,
                                  width: 1,
                                ),
                                color: Colors.white,
                              ),
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  SizedBox(
                                    width: 44,
                                    height: 44,
                                    child: Image.asset(isExpensesSelected
                                        ? ThisUtils.categoriesImage[index]
                                        : ThisUtils
                                            .categoriesImageIncome[index]),
                                  ),
                                  selectedIndex == index
                                      ? SizedBox(
                                          width: 28,
                                          height: 28,
                                          child: Image.asset(
                                              'assets/icon_status.webp'),
                                        )
                                      : SizedBox(),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(height: 4),
                          Expanded(
                            child: Center(
                              child: FittedBox(
                                fit: BoxFit.scaleDown,
                                child: Text(
                                    isExpensesSelected
                                        ? ThisUtils.categories[index].replaceAll(" ", "\n")
                                        : ThisUtils.categoriesIncome[index].replaceAll(" ", "\n"),
                                    style: TextStyle(
                                        fontSize:
                                            MediaQuery.of(context).size.width *
                                                0.03, // 根据屏幕宽度调整字体
                                        color: Colors.black),
                                    textAlign: TextAlign.center,
                                    maxLines: 2),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
            SizedBox(height: 15),
            Expanded(
              flex: 4,
              child: NumberInputWidget(
                onAdd: (value) {
                  addAccountFun(value);
                },
                stateImage: selectedIndex >= 0
                    ? isExpensesSelected
                        ? ThisUtils.categoriesImage[selectedIndex]
                        : ThisUtils.categoriesImageIncome[selectedIndex]
                    : "",
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildToggleButton({
    required String text,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        alignment: Alignment.center,
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? Colors.black : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          text,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.black,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
