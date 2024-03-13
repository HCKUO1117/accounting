import 'package:accounting/utils/show_toast.dart';
import 'package:flutter/material.dart';
import 'package:math_expressions/math_expressions.dart';


import '../../../generated/l10n.dart';
import 'button_values.dart';

class CalculatorScreen extends StatefulWidget {
  const CalculatorScreen({Key? key}) : super(key: key);

  @override
  State<CalculatorScreen> createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  String input = '';
  String output = '';
  List<String> calculationHistory = [];

  void onButtonClick(String context, BuildContext buildContext) {
    if (context == "C") {
      input = '';
      output = '';
    } else if (context == "()") {
      // Toggle between "(" and ")"
      if (input.endsWith("(")) {
        input = "${input.substring(0, input.length - 1)})";
      } else if (input.endsWith(")")) {
        input = "${input.substring(0, input.length - 1)}(";
      } else {
        if (input.isNotEmpty && !RegExp(r'[0-9.]$').hasMatch(input)) {
          input += "(";
        } else {
          input += ")";
        }
      }
    } else if (context == "=") {
      // Check if parentheses are balanced before evaluating the expression
      if (areParenthesesBalanced(input)) {
        try {
          var userInput = input;

          // Handle percentage operation first
          userInput = userInput.replaceAllMapped(
            RegExp(r'(\d+(?:\.\d+)?)\s*%\s*(\+|\-|\*|\/|$)'),
            (match) {
              var value = double.parse(match.group(1)!);
              var operator = match.group(2) ?? '';
              return (value / 100).toString() + operator;
            },
          );

          // Updated logic for handling negative numbers
          userInput = userInput.replaceAllMapped(
            RegExp(r'(?<=\d)\s*(-)\s*(?=\d)'),
            (match) => match.group(0)!.contains('-') ? '-' : '+',
          );

          // Ensure that "÷" is replaced with "/" and "×" is replaced with "*"
          userInput = userInput.replaceAll('÷', '/');
          userInput = userInput.replaceAll('×', '*');

          // Check if the input exceeds 15 digits
          // if (getDigitCount(userInput) > 15) {
          //   // Display a pop-up notifying the user
          //   showDigitLimitExceededDialog(buildContext);
          //   return;
          // }

          Parser p = Parser();
          Expression expression = p.parse(userInput);
          ContextModel cm = ContextModel();
          var finalValue = expression.evaluate(EvaluationType.REAL, cm);
          output = formatNumber(finalValue.toString());

          // Format the input with periods as thousands separators
          input = formatNumber(userInput);

          // Add the expression to the calculation history
          calculationHistory.add("$input = $output");
        } catch (e) {
          // Handle parsing or evaluation errors
          output = 'Error';
          input = '';
        }
      } else {
        // Handle the case when parentheses are not balanced
        output = 'Error';
        input = '';
      }
    } else if (context == "+/-") {
      // ... (existing code)
    } else if (context == "%") {
      // Handle percentage button
      if (input.isNotEmpty && RegExp(r'[0-9.]$').hasMatch(input)) {
        input += "%";
      }
    } else {
      // Handle numeric input
      if (context == "." && input.contains(".")) {
        // Prevent entering multiple decimal points
        return;
      }

      if (context == "÷") {
        // Handle division symbol
        input += "÷";
      } else if (context == "×") {
        // Handle multiplication symbol
        input += "×";
      } else if (context == 'check') {
        if (areParenthesesBalanced(input)) {
          try {
            var userInput = input;

            // Handle percentage operation first
            userInput = userInput.replaceAllMapped(
              RegExp(r'(\d+(?:\.\d+)?)\s*%\s*(\+|\-|\*|\/|$)'),
              (match) {
                var value = double.parse(match.group(1)!);
                var operator = match.group(2) ?? '';
                return (value / 100).toString() + operator;
              },
            );

            // Updated logic for handling negative numbers
            userInput = userInput.replaceAllMapped(
              RegExp(r'(?<=\d)\s*(-)\s*(?=\d)'),
              (match) => match.group(0)!.contains('-') ? '-' : '+',
            );

            // Ensure that "÷" is replaced with "/" and "×" is replaced with "*"
            userInput = userInput.replaceAll('÷', '/');
            userInput = userInput.replaceAll('×', '*');

            // Check if the input exceeds 15 digits
            // if (getDigitCount(userInput) > 15) {
            //   // Display a pop-up notifying the user
            //   showDigitLimitExceededDialog(buildContext);
            //   return;
            // }

            Parser p = Parser();
            Expression expression = p.parse(userInput);
            ContextModel cm = ContextModel();
            var finalValue = expression.evaluate(EvaluationType.REAL, cm);
            output = formatNumber(finalValue.toString());

            // Format the input with periods as thousands separators
            input = formatNumber(userInput);

            // Add the expression to the calculation history
            calculationHistory.add("$input = $output");
          } catch (e) {
            // Handle parsing or evaluation errors
            output = 'Error';
            input = '';
          }
        } else {
          // Handle the case when parentheses are not balanced
          output = 'Error';
          input = '';
        }
        setState(() {});
        if (output.isEmpty) {
          ShowToast.showToast(S.of(buildContext).amountFormatError);
          return;
        }
        if(output == 'Infinity' || output == 'NaN'){
          ShowToast.showToast(S.of(buildContext).amountFormatError);
          return;
        }
        try {
          double.parse(output);
        } catch (_) {
          ShowToast.showToast(S.of(buildContext).amountFormatError);
          return;
        }
        Navigator.of(buildContext).pop(output);
      } else {
        // Avoid replacing special characters

        // Check if adding the new character will exceed 15 digits
        // if (getDigitCount(input + context) > 15) {
        //   // Display a pop-up notifying the user
        //   showDigitLimitExceededDialog(buildContext);
        //   return;
        // }

        input += context;
      }
    }

    setState(() {});
  }

  int getDigitCount(String input) {
    return input.replaceAll(RegExp(r'[^0-9]'), '').length;
  }

  void showDigitLimitExceededDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Digit Limit Exceeded"),
          content: const Text("You can input numbers with a maximum of 15 digits."),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text(
                "OK",
                style: TextStyle(
                  color: Colors.black, // Set button text color to black
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  String getLastNumber(String input) {
    var reversedInput = input.split('').reversed.join();
    var match = RegExp(r'^[0-9.,]+$').firstMatch(reversedInput);
    return match?.group(0)?.split('').reversed.join('') ?? '';
  }

  // Inside _CalculatorScreenState class
  String formatNumber(String numberString) {
    // Replace "/" with "÷" and "*" with "×"
    var formattedNumber = numberString.replaceAll('/', '÷').replaceAll('*', '×');

    // Check if the number is an integer
    if (formattedNumber.contains('.') && double.tryParse(formattedNumber)! % 1 == 0) {
      // Remove decimal part for integers
      formattedNumber = formattedNumber.replaceAll(RegExp(r'\.0$'), '');
    }

    return formattedNumber;
  }

  bool areParenthesesBalanced(String input) {
    int count = 0;
    for (var char in input.runes) {
      if (String.fromCharCode(char) == '(') {
        count++;
      } else if (String.fromCharCode(char) == ')') {
        count--;
      }
      if (count < 0) {
        return false; // Mismatched closing parenthesis
      }
    }
    return count == 0; // Parentheses are balanced if count is zero
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
          // actions: [
          //   // TextButton(
          //   //   onPressed: () {
          //   //     Get.back(result: output.isNotEmpty ? output : null);
          //   //   },
          //   //   child: Text(Messages.confirm.tr),
          //   // ),
          // ],
          ),
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            Expanded(
              child: Container(
                // width: 350,
                alignment: Alignment.bottomRight,
                padding: const EdgeInsets.only(top: 24.0, right: 24, left: 24),
                margin: const EdgeInsets.only(top: 24.0, right: 24, left: 24),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: const Color(0XFFF4EAE0),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    Expanded(
                      child: SingleChildScrollView(
                        child: Text(
                          input,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.normal,
                          ),
                          textAlign: TextAlign.end,
                        ),
                      ),
                    ),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Text(
                        output,
                        style: const TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.normal,
                        ),
                        textAlign: TextAlign.end,
                      ),
                    ),
                    Row(
                      children: [
                        // IconButton(
                        //   onPressed: () {
                        //     // Show calculation history
                        //     showHistoryDialog(context);
                        //   },
                        //   icon: const Icon(Icons.history),
                        // ),
                        const Spacer(),
                        IconButton(
                          onPressed: () {
                            if (input.isNotEmpty) {
                              input = input.substring(0, input.length - 1);
                              setState(() {});
                            }
                          },
                          icon: const Icon(Icons.backspace_outlined),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Wrap(
                children: [
                  ...ButtonArea1.values.map(
                    (e) => SizedBox(
                      width: screenSize.width / 4.5,
                      height: screenSize.width / 4.5,
                      child: buildButton(
                        text: e.text,
                        color: e.color,
                        textColor: e.textColor,
                      ),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildButton({
    required String text,
    required Color color,
    required Color textColor,
  }) {
    return Container(
      margin: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(75),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade300,
            offset: const Offset(4, 4),
            blurRadius: 10,
            spreadRadius: 1,
          ),
          const BoxShadow(
            color: Colors.white,
            offset: Offset(-4, -4),
            blurRadius: 10,
            spreadRadius: 1,
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: () => onButtonClick(text, context),
        style: ElevatedButton.styleFrom(
          backgroundColor: color, // Background color
          elevation: 0, // Set elevation to 0 to delete default shadow
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(75),
          ),
        ),
        child: FittedBox(
          child: text == 'check'
              ? Icon(
                  Icons.check,
                  color: textColor,
                  size: 32,
                )
              : Text(
                  text,
                  style: TextStyle(
                    fontSize: 32,
                    color: textColor,
                  ),
                ),
        ),
      ),
    );
  }

  void showHistoryDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Container(
            alignment: Alignment.center,
            child: const Text("Calculation History", style: TextStyle(fontSize: 20)),
          ),
          content: SizedBox(
            width: double.maxFinite,
            child: ListView.builder(
              itemCount: calculationHistory.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(calculationHistory[index]),
                );
              },
            ),
          ),
          backgroundColor: const Color(0xFFF4F6F0), // Set background color
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFFCB935F).withOpacity(0.83), // Set the container color
                    borderRadius: BorderRadius.circular(20), // Set border radius
                  ),
                  child: TextButton(
                    onPressed: () {
                      // Clear history
                      setState(() {
                        calculationHistory.clear();
                      });
                      Navigator.pop(context);
                    },
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.black, // Set button text color
                    ),
                    child: const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text("Clear History"),
                    ),
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFFCB935F).withOpacity(0.83), // Set the container color
                    borderRadius: BorderRadius.circular(20), // Set border radius
                  ),
                  child: TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.black, // Set button text color
                    ),
                    child: const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text("Close"),
                    ),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}
