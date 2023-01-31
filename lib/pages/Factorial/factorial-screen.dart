import 'package:adopt_a_pet/utilities/AssetStorageImage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';

import '../../widgets/Toast-Message.dart';

class FactorialScreen extends StatefulWidget {
  const FactorialScreen({Key? key}) : super(key: key);

  @override
  State<FactorialScreen> createState() => _FactorialScreenState();
}

class _FactorialScreenState extends State<FactorialScreen> {
  TextEditingController value = TextEditingController();

  final _inputValue = ValueNotifier<int>(0);

  ScrollController scrollController = ScrollController();
  double scrollPosition = 0.0;

  int factorial(int num) {
    int result = 1;
    for (int i = 1; i <= num; i++) {
      result *= i;
    }
    return _inputValue.value = result;
    // return _inputValue.value = num == 1 ? 1 : num * factorial(num - 1);
  }

  @override
  void initState() {
    scrollController.addListener(() {
      print(scrollController.offset);
    });
    super.initState();
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
        centerTitle: true,
        title: const Text("Factorial", style: TextStyle(color: Colors.black)),
      ),
      body: SingleChildScrollView(
        controller: scrollController,
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Image.asset(
                AssetStorageImage.factorial,
                height: size.height * .30,
              ),
              SizedBox(
                height: size.height * .04,
              ),
              ValueListenableBuilder(
                  valueListenable: _inputValue,
                  builder: (parentContext, _, widget1) {
                    return Wrap(
                      children: [
                        const Text(
                          "Result is : ",
                          style: TextStyle(
                            fontSize: 25,
                          ),
                        ),
                        FittedBox(
                          fit: BoxFit.cover,
                          child: Text(
                            _inputValue.value.toString(),
                            style: const TextStyle(
                                fontSize: 25, fontWeight: FontWeight.bold, color: Colors.blue),
                          ),
                        ),
                      ],
                    );
                    // return RichText(
                    //   text: TextSpan(
                    //     text: 'Result is: ',
                    //     style: const TextStyle(fontSize: 22, color: Colors.black),
                    //     children: <TextSpan>[
                    //       TextSpan(
                    //           text: _inputValue.value.toString(),
                    //           style:
                    //               const TextStyle(fontWeight: FontWeight.bold, color: Colors.blue)),
                    //     ],
                    //   ),
                    // );
                  }),
              SizedBox(
                height: size.height * .05,
              ),
              inputNumberFactorial(),
              SizedBox(
                height: size.height * .05,
              ),
              OutlinedButton(
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.white,
                  minimumSize: const Size.fromHeight(50),
                  backgroundColor: Colors.blue.shade400, //<-- SEE HERE
                ),
                onPressed: () {
                  if (value.text.isEmpty) {
                    displayErrorMessage('Please, Input any number.');
                  }
                  factorial(int.parse(value.text));

                  print(factorial(int.parse(value.text)).toString());
                },
                child: const Text(
                  'Calculate Factorial',
                  style: TextStyle(fontSize: 20),
                ), // <-- Text
              ),
            ],
          ),
        ),
      ),
    );
  }

  TextField inputNumberFactorial() {
    return TextField(
      onChanged: (val) {
        if (val.isEmpty) {
          _inputValue.value = 0;
        }

        // show button calcualte when keyboard is open
        scrollController.animateTo(
          scrollController.position.pixels + scrollPosition + 220,
          curve: Curves.easeOut,
          duration: const Duration(milliseconds: 500),
        );
      },
      textAlign: TextAlign.center,
      keyboardType: TextInputType.number,
      textInputAction: TextInputAction.done,
      controller: value,
      decoration: InputDecoration(
        focusedBorder:
            const OutlineInputBorder(borderSide: BorderSide(width: 1, color: Colors.black)),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        enabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.grey, width: 1.0),
        ),
        hintText: 'Enter Number...',
        fillColor: Colors.white,
        filled: true,
      ),
    );
  }

  void displayErrorMessage(String message) {
    ToastMessage.showMessage(message, context,
        offSetBy: 0,
        position: const StyledToastPosition(align: Alignment.topCenter, offset: 200.0),
        isShapedBorder: false);
  }
}
