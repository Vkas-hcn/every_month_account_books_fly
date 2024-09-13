import 'package:every_month_account_books_fly/Setting.dart';
import 'package:every_month_account_books_fly/utils/ThisUtils.dart';
import 'package:every_month_account_books_fly/utils/ZhiShou.dart';
import 'package:flutter/material.dart';

import 'DatePickerBottomSheet.dart';
import 'MainAccount.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return  HomePageShow();
  }
}

class HomePageShow extends StatefulWidget {
  @override
  _HomePageShowState createState() => _HomePageShowState();
}

class _HomePageShowState extends State<HomePageShow> {
  String selectedDateText = "";
  String totalExpenditure = "";
  String totalRevenue = "";
  String budget = "500";
  RecordBean? septemberRecord = null;

  @override
  void initState() {
    super.initState();
    selectedDateText = ThisUtils.getCurrentDateFormatted();
    getListAccData(null);
  }

  void getTotalExpenditure() {
    if (septemberRecord != null) {
      Map<String, double> totals = septemberRecord!.calculateMonthlyTotals();
      setState(() {
        totalExpenditure = "\$${totals['totalZhi']}";
        totalRevenue = "\$${totals['totalShou']}";
        budget = "\$${septemberRecord!.yu}";
      });
      print("支出总额: ${totals['totalZhi']}");
      print("收入总额: ${totals['totalShou']}");
    } else {
      setState(() {
        totalExpenditure = "0";
        totalRevenue = "0";
        budget = "0";
      });
    }
  }

  void getListAccData(String? date) async {
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
  }

  void refData() {
    getListAccData(selectedDateText);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFFF4E0),
      body: Padding(
        padding: const EdgeInsets.only(top: 50.0),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 20, right: 20),
              child: Row(
                children: [
                  Container(
                    padding:
                        const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                    decoration: BoxDecoration(
                      color: const Color(0xFFECE0C6),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: GestureDetector(
                      onTap: () async {
                        final selectedDate =
                            await showDatePickerBottomSheet(context);

                        if (selectedDate != null) {
                          setState(() {
                            selectedDateText = selectedDate;
                          });
                          getListAccData(selectedDateText);
                        }
                      },
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
                            "${ThisUtils.convertMonthToEnglish(selectedDateText.substring(5, 7))}${selectedDateText.substring(7, 10)}",
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
                  ),
                  Spacer(),
                  GestureDetector(
                    onTap: () {
                      ThisUtils.selectedIndex = 3;
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => Setting()),
                      ).then((value) {
                        print("object-Setting");
                      });
                    },
                    child: SizedBox(
                      width: 24,
                      height: 24,
                      child: Image.asset('assets/icon_settings.webp'),
                    ),
                  ),
                ],
              ),
            ),
            Stack(
              alignment: Alignment.topCenter,
              children: [
                Stack(
                  alignment: Alignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Container(
                        height: 1,
                        width: double.infinity,
                        color: const Color(0xFFE6DDCA),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 0),
                      child: SizedBox(
                        width: 67,
                        height: 80,
                        child: Image.asset('assets/img_bee_home.webp'),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding:
                      const EdgeInsets.only(left: 20.0, right: 20, top: 50),
                  child: Container(
                    width: double.infinity,
                    height: 153,
                    decoration: BoxDecoration(
                      color: Color(0xFFF3AA20),
                      borderRadius: BorderRadius.circular(16),
                      image: const DecorationImage(
                        image: AssetImage('assets/img_home_top.webp'),
                        fit: BoxFit.cover,
                      ),
                      border: Border.all(
                        color: Colors.black,
                        width: 1,
                      ),
                    ),
                    child: Column(
                      children: [
                        Text(
                          "${ThisUtils.convertMonthToEnglish(selectedDateText.substring(5, 7))} Budget",
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.black,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (context) => NumberModifyDialog(
                                onCancel: () {
                                  Navigator.pop(context);
                                },
                                onConfirm: (number) async {
                                  await RecordBean.updateYuByMonth(
                                      selectedDateText, number.toString());
                                  refData();
                                },
                                isBudget: true,
                              ),
                            );
                          },
                          child: Text(
                            budget,
                            style: const TextStyle(
                              fontSize: 28,
                              color: Colors.black,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 12),
                          child: Container(
                            height: 1,
                            width: double.infinity,
                            color: Color(0x1A000000),
                          ),
                        ),
                        Row(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            const Spacer(),
                            Container(
                              width: 124,
                              decoration: BoxDecoration(
                                color: const Color(0xFF2EBE16),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(14.0),
                                child: Text(
                                  totalRevenue,
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: Colors.white,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                            Spacer(),
                            Container(
                              width: 124,
                              decoration: BoxDecoration(
                                color: const Color(0xFFE52C2C),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(14.0),
                                child: Text(
                                  totalExpenditure,
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: Colors.white,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                            Spacer(),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            septemberRecord != null
                ? Expanded(
                    child: BillList(
                    monthRecord: septemberRecord!,
                    callback: refData,
                  ))
                : Expanded(
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
}

class BillList extends StatefulWidget {
  final RecordBean monthRecord;
  final VoidCallback callback;

  const BillList({
    Key? key,
    required this.monthRecord,
    required this.callback,
  }) : super(key: key);

  @override
  _BillListState createState() => _BillListState();
}

class _BillListState extends State<BillList> {
  // 当数据发生变化时重新计算支出和收入
  String getDayZhi(MonthData dailyData, String dayKey) {
    Map<String, double> totals =
        RecordBean.calculateDailyTotals(dailyData, dayKey);
    print("支出总额: ${totals['totalZhi']}, 收入总额: ${totals['totalShou']}");
    return "\$${totals['totalZhi']}";
  }

  String getDayShou(MonthData dailyData, String dayKey) {
    Map<String, double> totals =
        RecordBean.calculateDailyTotals(dailyData, dayKey);
    print("支出总额: ${totals['totalZhi']}, 收入总额: ${totals['totalShou']}");
    return "\$${totals['totalShou']}";
  }

  List<Widget> _buildBillItemsWithPlaceholdersShou(MonthData dailyData) {
    List<Widget> billItems = [];
    int maxLength = dailyData.zhiShouList.length;

    for (int i = 0; i < maxLength; i++) {
      // 左边收入：有数据显示收入，没有数据用占位符
      if (dailyData.zhiShouList[i].type == "shou") {
        billItems.add(_buildBillItem("+", dailyData.zhiShouList[i].num,
            Colors.green, dailyData.zhiShouList[i].state));
      } else {
        billItems.add(_buildEmptyBillItem()); // 空白占位符
      }
    }
    return billItems;
  }

  List<Widget> _buildBillItemsWithPlaceholdersZhi(MonthData dailyData) {
    List<Widget> billItems = [];
    int maxLength = dailyData.zhiShouList.length;

    for (int i = 0; i < maxLength; i++) {
      // 右边支出：有数据显示支出，没有数据用占位符
      if (dailyData.zhiShouList[i].type == "zhi") {
        billItems.add(_buildBillItem("-", dailyData.zhiShouList[i].num,
            Colors.red, dailyData.zhiShouList[i].state));
      } else {
        billItems.add(_buildEmptyBillItem()); // 空白占位符
      }
    }

    return billItems;
  }

  List<Widget> _buildIconWithAllData(
      BuildContext context, MonthData dailyData, String dayKey) {
    List<Widget> icons = [];
    int maxLength = dailyData.zhiShouList.length;
    for (int i = 0; i < maxLength; i++) {
      // 显示收入类型的图标
      if (dailyData.zhiShouList[i].type == "shou") {
        icons.add(_buildIcon(context, dailyData.zhiShouList[i], dayKey, 1));
      }
      // 显示支出类型的图标
      if (dailyData.zhiShouList[i].type == "zhi") {
        icons.add(_buildIcon(context, dailyData.zhiShouList[i], dayKey, 2));
      }
    }

    return icons;
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: widget.monthRecord.monthlyData.length,
      itemBuilder: (context, index) {
        String dayKey = widget.monthRecord.monthlyData.keys.toList()[index];
        final dailyData = widget.monthRecord.monthlyData[dayKey]!;

        if (dailyData.zhiShouList.isNotEmpty) {
          return Stack(
            alignment: Alignment.topCenter,
            children: [
              Container(
                width: 2,
                color: Colors.grey, // 中轴线颜色
                height: _calculateDynamicHeight(dailyData),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 12.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // 左侧收入
                        Expanded(
                          child: Text(
                            getDayShou(dailyData, dayKey),
                            textAlign: TextAlign.right,
                            style: const TextStyle(
                              color: Color(0xFFBFAC8B),
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        // 中间日期图标
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                vertical: 8, horizontal: 12),
                            decoration: BoxDecoration(
                              color: const Color(0xFFECE0C6),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(
                                  width: 24,
                                  height: 24,
                                  child: Image.asset('assets/icon_date_line.webp'),
                                ),
                                SizedBox(width: 8),
                                Text(
                                  "${ThisUtils.convertMonthToEnglish(widget.monthRecord.dateMonth.substring(5, 7))} ${dayKey}",
                                  style: const TextStyle(
                                    color: Color(0xFFBFAC8B),
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        // 右侧支出
                        Expanded(
                          child: Text(
                            getDayZhi(dailyData, dayKey),
                            textAlign: TextAlign.left,
                            style: const TextStyle(
                              color: Color(0xFFBFAC8B),
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  // 下方详细信息
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // 左侧收入列
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: _buildBillItemsWithPlaceholdersShou(dailyData),
                        ),
                      ),
                      SizedBox(width: 5),
                      // 中间的图标列
                      Column(
                        children: _buildIconWithAllData(context, dailyData, dayKey),
                      ),
                      SizedBox(width: 5),
                      // 右侧支出列
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: _buildBillItemsWithPlaceholdersZhi(dailyData),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          );
        } else {
          return SizedBox();
        }
      },
    );
  }

  // 构建单条收入或支出的账单项，增加 category 参数显示类别
  Widget _buildBillItem(String type, String amount, Color color, String state) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment:
            type == "+" ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Text(
            type == "+"
                ? ThisUtils.categoriesIncome[int.parse(state)]
                : ThisUtils.categories[int.parse(state)], // 显示类别
            style: const TextStyle(
              color: Color(0xFF222222),
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
          Text(
            '$type \$$amount', // 显示类别
            style: TextStyle(
              color: color,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
            maxLines: 1, // 限制为单行

          ),
        ],
      ),
    );
  }

  // 构建空白的账单占位符
  Widget _buildEmptyBillItem() {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 10.0),
      child: Column(
        children: [
          Text(
            'EdgeInsets', // 显示类别
            style: TextStyle(
              color: Colors.transparent, // 隐藏文本
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
          Text(
            '+\$ 00000', // 空白文本
            style: TextStyle(
              color: Colors.transparent, // 隐藏文本
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  // 构建时间轴上的图标
  Widget _buildIcon(
      BuildContext context, ZhiShouData data, String dayKey, int type) {
    String iconData;
    if (type == 1) {
      iconData = ThisUtils.categoriesImageIncome[int.parse(data.state)];
    } else {
      iconData = ThisUtils.categoriesImage[int.parse(data.state)];
    }
    return GestureDetector(
      onTap: () {
        showDialog(
          context: context,
          builder: (context) => NumberModifyDialog(
            onCancel: () {
              Navigator.pop(context);
            },
            onConfirm: (number) async {
              print('确认输入的数字为: $number');
              data.num = number.toString();
              await RecordBean.updateRecord(data.id, data);
              print("callback--------");
              widget.callback();
            },
            isBudget: false,
          ),
        );
      },
      onLongPress: () {
        showDialog(
          context: context,
          builder: (context) => DeleteDialog(
            onCancel: () {
              Navigator.pop(context);
            },
            onConfirm: () async {
              Navigator.pop(context);
              await ZhiShouData.removeAndSaveRecord(
                  dayKey, data.type, data.state, data.num);
              print("callback--------");
              widget.callback();
            },
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.only(bottom: 21.0),
        child: SizedBox(
          width: 40,
          height: 40,
          child: Image.asset(iconData),
        ),
      ),
    );
  }

  // 计算中轴线的动态高度
  double _calculateDynamicHeight(MonthData dailyData) {
    int totalItems = dailyData.zhiShouList.length;
    return totalItems * 60.0;
  }
}

class DeleteDialog extends StatelessWidget {
  final VoidCallback onCancel;
  final VoidCallback onConfirm;

  const DeleteDialog({
    super.key,
    required this.onCancel,
    required this.onConfirm,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Confirm deletion'),
      content: const Text('Are you sure you want to delete it?'),
      actions: [
        TextButton(
          onPressed: onCancel,
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: onConfirm,
          child: const Text('confirm'),
        ),
      ],
    );
  }
}

class NumberModifyDialog extends StatelessWidget {
  final VoidCallback onCancel;
  final Function(String) onConfirm;
  final bool isBudget;

  const NumberModifyDialog({
    super.key,
    required this.onCancel,
    required this.onConfirm,
    required this.isBudget,
  });

  @override
  Widget build(BuildContext context) {
    TextEditingController _controller = TextEditingController();

    void _validateAndConfirm() {
      String input = _controller.text.trim();

      // 正则表达式检查输入是否合法：允许正数，小数点可以出现在数字之间
      RegExp regExp = RegExp(r'^[0-9]+(\.[0-9]+)?$');

      // 检查是否匹配正则表达式
      if (!regExp.hasMatch(input)) {
        ThisUtils.showToast("Please enter a valid number");
        return;
      }

      double? value = double.tryParse(input);

      // 验证输入的范围和其他条件
      if (value != null && value > 0 && value <= 100000) {
        if (isBudget && (value > 100000 || value < 50)) {
          ThisUtils.showToast("The input range is from 50 to 100,000");
          return;
        }
        onConfirm(value.toString());
        Navigator.pop(context);
      } else {
        ThisUtils.showToast("Please enter a legal value");
      }
    }



    return AlertDialog(
      title: const Text('Modify records'),
      content: TextField(
        controller: _controller,
        keyboardType: TextInputType.number,
        decoration:
            const InputDecoration(hintText: 'Please enter modified value'),
      ),
      actions: [
        TextButton(
          onPressed: onCancel,
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: _validateAndConfirm,
          child: const Text('Confirm'),
        ),
      ],
    );
  }
}
