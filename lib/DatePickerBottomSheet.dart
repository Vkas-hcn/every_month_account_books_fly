import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DatePickerBottomSheet extends StatefulWidget {
  @override
  _DatePickerBottomSheetState createState() => _DatePickerBottomSheetState();
}

class _DatePickerBottomSheetState extends State<DatePickerBottomSheet> {
  int selectedYear = DateTime.now().year;
  int selectedMonth = DateTime.now().month;
  int selectedDay = DateTime.now().day;

  // 生成年份列表
  List<int> _getYears() {
    return List.generate(
        101, (index) => DateTime.now().year - 50 + index); // 过去50年到未来50年
  }

  // 生成月份列表
  List<int> _getMonths() {
    return List.generate(12, (index) => index + 1);
  }

  // 生成日期列表
  List<int> _getDays(int year, int month) {
    int daysInMonth = DateTime(year, month + 1, 0).day;
    return List.generate(daysInMonth, (index) => index + 1);
  }

  // 构建滚轮选择器
  Widget _buildPicker(
      List<int> items, int selectedValue, int type, Function(int) onSelectedItemChanged) {
    return Expanded(
      child: Column(
        children: [
          Text(
            type == 1 ? 'Year' : type == 2 ? 'Month' : 'Day',
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: Container(
              height: 1,
              width: double.infinity,
              color: Color(0xFFEEEEEE),
            ),
          ),
          Expanded(
            child: CupertinoPicker(
              scrollController: FixedExtentScrollController(
                  initialItem: items.indexOf(selectedValue)),
              itemExtent: 40,
              onSelectedItemChanged: (index) {
                onSelectedItemChanged(items[index]);
              },
              children: items.map((item) {
                bool isSelected = selectedValue == item;
                return Container(
                  alignment: Alignment.center,
                  decoration: isSelected
                      ? BoxDecoration(
                    color: Colors.yellow.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(8),
                  )
                      : null,
                  child: Text(
                    '$item',
                    style: TextStyle(
                      fontSize: 20,
                      color: isSelected ? Colors.orange : Colors.black,
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 400,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(
                  width: 20,
                  height: 20,
                  child: Image.asset('assets/icon_date.webp'),
                ),
                SizedBox(width: 8),
                const Text(
                  'Set time',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
            Expanded(
              child: Row(
                children: [
                  _buildPicker(_getYears(), selectedYear, 1, (value) {
                    setState(() {
                      selectedYear = value;
                      // 检查选中的日期在新月份是否有效
                      int maxDays = DateTime(selectedYear, selectedMonth + 1, 0).day;
                      if (selectedDay > maxDays) {
                        selectedDay = maxDays; // 调整为该月的最大日期
                      }
                    });
                  }),
                  _buildPicker(_getMonths(), selectedMonth, 2, (value) {
                    setState(() {
                      selectedMonth = value;
                      // 检查选中的日期在新月份是否有效
                      int maxDays = DateTime(selectedYear, selectedMonth + 1, 0).day;
                      if (selectedDay > maxDays) {
                        selectedDay = maxDays; // 调整为该月的最大日期
                      }
                    });
                  }),
                  _buildPicker(_getDays(selectedYear, selectedMonth), selectedDay, 3,
                          (value) {
                        setState(() {
                          selectedDay = value;
                        });
                      }),
                ],
              ),
            ),
            Container(
              height: 1,
              width: double.infinity,
              color: Color(0xFFEEEEEE),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              mainAxisSize: MainAxisSize.max,
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                    ),
                    child: const Text(
                      'Cancel',
                      style: TextStyle(
                        fontSize: 14,
                        color: Color(0xFFF3AA1F),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      String formattedDate =
                      formatDate(selectedYear, selectedMonth, selectedDay);
                      Navigator.pop(context, formattedDate);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFFF3AA1F),
                    ),
                    child: const Text(
                      'Confirm',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

Future<String?> showDatePickerBottomSheet(BuildContext context) async {
  final selectedDate = await showModalBottomSheet<String>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (BuildContext context) {
      return Container(
        height: 400,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: DatePickerBottomSheet(),
      );
    },
  );

    print('最终选择的日期为: $selectedDate');
    return selectedDate;
}
String formatDate(int year, int month, int day) {
  // 将月份和日期转换为两位数
  String formattedMonth = month.toString().padLeft(2, '0');
  String formattedDay = day.toString().padLeft(2, '0');

  // 返回格式化后的日期
  return '$year-$formattedMonth-$formattedDay';
}


