import 'package:every_month_account_books_fly/utils/LocalStorage.dart';
import 'package:every_month_account_books_fly/utils/ZhiShou.dart';
import 'package:flutter/material.dart';
import 'DatePickerBottomSheet.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const text());
}

class text extends StatelessWidget {
  const text({super.key});

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
    testData();
  }

  void testData() async {
    // 从本地读取数据
    String? jsonStr = await LocalStorage().getValue(LocalStorage.accountJson);

    // 解析本地数据
    List<RecordBean> records = RecordBean.parseRecords(jsonStr);

    // 添加一条新数据
    if (records.isNotEmpty) {
      records[0].addDataByDate("2024-10-12", "zhi", "11", "1200", records);
      records[0].addDataByDate("2024-10-12", "shou", "12", "1120", records);

    } else {
      // 如果本地没有记录，创建一个新的记录
      RecordBean newRecord = RecordBean(
        monthlyData: {},
        dateMonth: '2024-10',
        yu: '0',
      );
      newRecord.addDataByDate("2024-10-12", "zhi", "3", "500", records);
      newRecord.addDataByDate("2024-10-12", "shou", "1", "100", records);

      records.add(newRecord);
    }
    String? datra = await LocalStorage().getValue(LocalStorage.accountJson);
    print("打印当前shuju ---${datra}");

    // 打印当前 records
    for (var record in records) {
      print(record.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    String inputNumber = '';

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
            child: ElevatedButton(
              onPressed: () {
                showDatePickerBottomSheet(context);
              },
              child: Text('显示日期选择器'),
            ),
          ),
        ),
      ),
    );
  }
}
