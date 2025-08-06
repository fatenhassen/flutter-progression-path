import 'package:flutter/material.dart';
import 'package:math_expressions/math_expressions.dart';

void main() {
  runApp(CalculatorApp());
}

class CalculatorApp extends StatefulWidget {
  @override
  _CalculatorAppState createState() => _CalculatorAppState();
}

class _CalculatorAppState extends State<CalculatorApp> {
  String _history = '';
  String _output = '0';
  bool _isDarkMode = true;

  final List<String> _buttons = [
    'AC',
    '+/-',
    '%',
    '÷',
    '7',
    '8',
    '9',
    '×',
    '4',
    '5',
    '6',
    '-',
    '1',
    '2',
    '3',
    '+',
    '←',
    '0',
    '.',
    '=',
  ];

  void _onButtonPressed(String buttonText) {
    setState(() {
      if (buttonText == 'AC') {
        _history = '';
        _output = '0';
      } else if (buttonText == '←') {
        if (_output.isNotEmpty && _output != '0') {
          _output = _output.substring(0, _output.length - 1);
          if (_output.isEmpty || _output == '-') {
            _output = '0';
          }
        }
      } else if (buttonText == '=') {
        _history = _output;
        try {
          String finalExpression = _output
              .replaceAll('×', '*')
              .replaceAll('÷', '/');
          Parser p = Parser();
          Expression exp = p.parse(finalExpression);
          ContextModel cm = ContextModel();
          _output = exp.evaluate(EvaluationType.REAL, cm).toString();
        } catch (e) {
          _output = 'Error';
        }
      } else if (buttonText == '%') {
        if (_output.isNotEmpty && _output != '0' && _output != 'Error') {
          try {
            double value = double.parse(_output);
            _output = (value / 100).toString();
          } catch (e) {
            _output = 'Error';
          }
        }
      } else if (buttonText == '+/-') {
        if (_output != '0' && _output != 'Error') {
          if (_output.startsWith('-')) {
            _output = _output.substring(1);
          } else {
            _output = '-' + _output;
          }
        }
      } else {
        if (_output == '0' || _output == 'Error') {
          _output = buttonText;
        } else {
          _output += buttonText;
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final themeData = _isDarkMode ? ThemeData.dark() : ThemeData.light();
    final backgroundColor = _isDarkMode
        ? const Color(0xFF23252E)
        : const Color(0xFFF5F5F5);
    final buttonContainerColor = _isDarkMode
        ? const Color(0xFF1E2028)
        : Colors.white;
    final displayTextColor = _isDarkMode ? Colors.white : Colors.black;

    const pinkTextColor = Color.fromARGB(255, 236, 61, 184);
    const greenTextColor = Color.fromARGB(255, 26, 190, 190);
    const defaultTextColor = Colors.white; // Default for numbers in dark mode

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: themeData.copyWith(scaffoldBackgroundColor: backgroundColor),
      home: Scaffold(
        body: SafeArea(
          child: Column(
            children: <Widget>[
              Align(
                alignment: Alignment.topRight,
                child: IconButton(
                  icon: Icon(
                    _isDarkMode ? Icons.wb_sunny : Icons.nightlight_round,
                    color: _isDarkMode ? Colors.white : Colors.black,
                  ),
                  onPressed: () {
                    setState(() {
                      _isDarkMode = !_isDarkMode;
                    });
                  },
                ),
              ),

              Expanded(
                flex: 1,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Text(
                        _history,
                        textAlign: TextAlign.right,
                        style: TextStyle(
                          fontSize: 24.0,
                          color: displayTextColor.withOpacity(0.6),
                        ),
                      ),
                      const SizedBox(height: 10.0),
                      Text(
                        _output,
                        textAlign: TextAlign.right,
                        style: TextStyle(
                          fontSize: 48.0,
                          fontWeight: FontWeight.bold,
                          color: displayTextColor,
                        ),
                      ),
                      const SizedBox(height: 20.0),
                    ],
                  ),
                ),
              ),

              Container(
                decoration: BoxDecoration(
                  color: buttonContainerColor,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30.0),
                    topRight: Radius.circular(30.0),
                  ),
                ),
                padding: const EdgeInsets.all(20.0),
                child: GridView.count(
                  shrinkWrap: true,
                  crossAxisCount: 4,
                  mainAxisSpacing: 15.0,
                  crossAxisSpacing: 15.0,
                  childAspectRatio: 1.0,
                  children: List.generate(_buttons.length, (index) {
                    final buttonText = _buttons[index];

                    final buttonColor = buttonContainerColor;

                    Color textColor;

                    if (['÷', '×', '-', '+', '='].contains(buttonText)) {
                      textColor = pinkTextColor;
                    } else if (['AC', '+/-', '%'].contains(buttonText)) {
                      textColor = greenTextColor;
                    } else if (buttonText == '←') {
                      textColor = greenTextColor;
                    } else {
                      textColor = _isDarkMode ? Colors.white : Colors.black;
                    }

                    return GestureDetector(
                      onTap: () => _onButtonPressed(buttonText),
                      child: Container(
                        decoration: BoxDecoration(
                          color: buttonColor,
                          borderRadius: BorderRadius.circular(50.0),

                          boxShadow: [
                            BoxShadow(
                              color: _isDarkMode
                                  ? Colors.black.withOpacity(0.5)
                                  : Colors.grey.withOpacity(0.3),
                              blurRadius: 5,
                              offset: Offset(2, 2),
                            ),
                          ],
                        ),
                        child: Center(
                          child: buttonText == '←'
                              ? Icon(Icons.backspace_outlined, color: textColor)
                              : Text(
                                  buttonText,
                                  style: TextStyle(
                                    color: textColor,
                                    fontSize: 24.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                        ),
                      ),
                    );
                  }),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
