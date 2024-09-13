import 'package:flutter/material.dart';

class NumberInputWidget extends StatefulWidget {
  final void Function(String) onAdd;
  final String stateImage;

  const NumberInputWidget({Key? key, required this.onAdd,required this.stateImage}) : super(key: key);

  @override
  _NumberInputWidgetState createState() => _NumberInputWidgetState();
}

class _NumberInputWidgetState extends State<NumberInputWidget> {
  String _input = '';
  // 构建数字键盘
  Widget _buildNumberButton(String value) {
    return GestureDetector(
      onTap: () {
        setState(() {
          if(_input.length>5)return;
          _input += value;
        });
      },
      child: Container(
        alignment: Alignment.topCenter,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          value,
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }

  // 删除最后一个字符
  void _deleteLastCharacter() {
    if (_input.isNotEmpty) {
      setState(() {
        _input = _input.substring(0, _input.length - 1);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(12),
                alignment: Alignment.topLeft,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  _input.isEmpty ? '0' : _input ,
                  style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold),
                ),
              ),
              Spacer(),
              widget.stateImage.isNotEmpty?SizedBox(
                width: 48,
                height: 48,
                child: Image.asset(widget.stateImage),
              ):SizedBox(),
            ],
          ),
          Container(
            height: 1,
            width: double.infinity,
            color: Color(0xFFE6DDCA),
          ),
          // 数字键盘和操作按钮
          Expanded(
            child: Row(
              children: [
                // 左侧的数字键盘
                Expanded(
                  flex: 3,
                  child: GridView.count(
                    crossAxisCount: 3,
                    children: [
                      _buildNumberButton('1'),
                      _buildNumberButton('2'),
                      _buildNumberButton('3'),
                      _buildNumberButton('4'),
                      _buildNumberButton('5'),
                      _buildNumberButton('6'),
                      _buildNumberButton('7'),
                      _buildNumberButton('8'),
                      _buildNumberButton('9'),
                      _buildNumberButton('.'),
                      _buildNumberButton('0'),
                    ],
                  ),
                ),
                // 右侧的退格键和Add按钮
                Expanded(
                  flex: 1,
                  child: Column(
                    children: [
                      // 退格键
                      Expanded(
                        flex: 1,
                        child: GestureDetector(
                          onTap: _deleteLastCharacter,
                          child: Container(
                            margin: EdgeInsets.all(5),
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Icon(Icons.backspace, size: 32),
                          ),
                        ),
                      ),
                      // Add 按钮
                      Expanded(
                        flex: 3,
                        child: GestureDetector(
                          onTap: () {
                            widget.onAdd(_input); // 将输入数字传递给外部
                            setState(() {
                              _input = ''; // 清空输入
                            });
                          },
                          child: Container(
                            margin: EdgeInsets.all(5),
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: Color(0xFFF3AA20),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              'Add',
                              style:
                                  TextStyle(fontSize: 24, color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
