import 'package:every_month_account_books_fly/utils/LocalStorage.dart';
import 'package:every_month_account_books_fly/utils/ThisUtils.dart';
import 'package:every_month_account_books_fly/utils/ZhiShou.dart';
import 'package:flutter/material.dart';

import 'DatePickerBottomSheet.dart';
import 'NumberInputWidget.dart';

class BillPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BillPageExample();
  }
}

class BillPageExample extends StatefulWidget {
  @override
  _BillPageState createState() => _BillPageState();
}

class _BillPageState extends State<BillPageExample> {
  bool isExpensesSelected = true;
  String selectedDateText = "";
  RecordBean? septemberRecord;
  List<Map<String, dynamic>>? stateList;
  String totalExpenditure = "0.00";
  String totalRevenue = "0.00";
  @override
  void initState() {
    super.initState();
    selectedDateText = ThisUtils.getCurrentDateFormatted();
    print("selectedDateText===${selectedDateText}");
    getListAccData(selectedDateText, "zhi");
  }

  void getListAccData(String? date, String type) async {
    String nowDate;
    if (date == null) {
      nowDate = ThisUtils.getCurrentDateFormatted().substring(0, 7);
    } else {
      nowDate = date.substring(0, 7);
    }
    List<RecordBean> records = await RecordBean.loadRecords();
    setState(() {
      septemberRecord = RecordBean.getDataByMonth(nowDate, records);
    });
    print("object----------${septemberRecord.toString()}");
    getTotalExpenditure();
    if (septemberRecord != null) {
      stateList = await septemberRecord!.getStateTotalList(selectedDateText.substring(0, 7),type);
    } else {
      stateList = null;
    }
  }

  getZhiOrShou() {
    if (isExpensesSelected) {
      getListAccData(selectedDateText, "zhi");
    } else {
      getListAccData(selectedDateText, "shou");
    }
  }
  void getTotalExpenditure() {
    if (septemberRecord != null) {
      Map<String, double> totals = septemberRecord!.calculateMonthlyTotals();
      setState(() {
        totalExpenditure = "\$${totals['totalZhi']}";
        totalRevenue = "\$${totals['totalShou']}";
      });
      print("支出总额: ${totals['totalZhi']}");
      print("收入总额: ${totals['totalShou']}");
    } else {
      setState(() {
        totalExpenditure = "0";
        totalRevenue = "0";
      });
    }
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
                            setState(() {
                              isExpensesSelected = true;
                            });
                            getZhiOrShou();
                          },
                        ),
                      ),
                      Expanded(
                        child: _buildToggleButton(
                          text: 'Income',
                          isSelected: !isExpensesSelected,
                          onTap: () {
                            setState(() {
                              isExpensesSelected = false;
                            });
                            getZhiOrShou();
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20, right: 20, top: 24),
              child: GestureDetector(
                onTap: () async {
                  final selectedDate =
                  await showDatePickerBottomSheet(context);
                  if (selectedDate != null) {
                    print('用户选择的日期: $selectedDate');
                    setState(() {
                      selectedDateText = selectedDate;
                    });
                    getZhiOrShou();
                  }
                },
                child: Row(
                  children: [
                    Spacer(),
                    Container(
                      padding:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                      decoration: BoxDecoration(
                        color: const Color(0xFFECE0C6),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child:  Row(
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
                              "${ThisUtils.convertMonthToEnglish(selectedDateText.substring(5, 7))}",
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
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    width: 160,
                    height: 160,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        colors: [
                          Color(0xFFF4C878),
                          Color(0xFFFFEECE),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                  ),
                  Column(
                    children: [
                      const Text(
                        'Total  spent',
                        style: TextStyle(
                          fontSize: 16,
                          color: Color(0xFF222222),
                        ),
                      ),
                      Text(
                        isExpensesSelected?totalExpenditure:totalRevenue,
                        style: const TextStyle(
                          fontSize: 28,
                          color: Color(0xFF222222),
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
            if (stateList != null && stateList!.length>0)
              Expanded(
                child: ListView.builder(
                  itemCount: stateList!.length,
                  itemBuilder: (context, index) {
                    stateList!.sort((a, b) => b['total'].compareTo(a['total']));
                    final stateData = stateList![index];
                    final String state = stateData['state'];
                    final double total = stateData['total'];
                    final double percentage = stateData['percentage'];

                    return ListTile(
                      leading: SizedBox(
                        width: 40,
                        height: 40,
                        child: Image.asset(isExpensesSelected
                            ? ThisUtils.categoriesImage[index]
                            : ThisUtils.categoriesImageIncome[index]),
                      ),
                      title: Text(
                        "${(isExpensesSelected
                            ? ThisUtils.categories[index]
                            : ThisUtils.categoriesIncome[index])} | ${percentage
                            .toStringAsFixed(2)}%",
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      trailing: Text(
                        '\$${total.toStringAsFixed(2)}',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    );
                  },
                ),
              )
            else
              Expanded(
                  child: Center(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 68.0),
                        child: Column(
                          children: [
                            SizedBox(
                              width: 100,
                              height: 117,
                              child: Image.asset('assets/icon_em.webp'),
                            ),
                            SizedBox(height: 16),
                            const Text(
                              'This month is empty. Start recording now!',
                              style: TextStyle(
                                fontSize: 14,
                                color: Color(0xFF222222),
                              ),
                            ),
                          ],
                        ),
                      ))),
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
