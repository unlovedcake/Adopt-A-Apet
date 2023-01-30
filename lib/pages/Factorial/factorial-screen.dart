import 'package:flutter/material.dart';

class FactorialScreen extends StatefulWidget {
  const FactorialScreen({Key? key}) : super(key: key);

  @override
  State<FactorialScreen> createState() => _FactorialScreenState();
}

class _FactorialScreenState extends State<FactorialScreen> {
  TextEditingController value = TextEditingController();
  int? _inputValue;

  int factorial(int num) {
    // int result = 1;
    // for (var i = 1; i <= num; i++) {
    //   result *= i;
    // }
    // _inputValue = result;
    // return result;

    return num == 1 ? 1 : num * factorial(num - 1);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Factorial"),
      ),
      body: Container(
        padding: EdgeInsets.all(10),
        child: Column(
          children: [
            TextField(
              controller: value,
              keyboardType: TextInputType.number,
            ),
            OutlinedButton(
              onPressed: () {
                setState(() {
                  factorial(int.parse(value.text));
                });
              },
              child: Text('Calculate'),
            ),
            Text(
              'The factorial of 100 is: ${factorial(int.parse(value.text))}',
              style: TextStyle(fontSize: 20),
            ),
          ],
        ),
      ),
    );
  }
}
