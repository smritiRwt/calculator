import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_cordinate_map/controller/calculator_controller';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Calculator',
      theme: ThemeData(
        primarySwatch: Colors.green,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: CalculatorScreen(),
    );
  }
}

class CalculatorScreen extends StatelessWidget {
  CalculatorController controller = Get.put(CalculatorController());

  CalculatorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'CALCULATOR',
          style: TextStyle(
              fontSize: 22, fontWeight: FontWeight.normal, color: Colors.white),
        ),
        backgroundColor: Colors.black,
      ),
      body: Center(
        child: Container(
          margin: const EdgeInsets.only(top: 30, bottom: 30),
          height: 650,
          width: 350,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Colors.white,
            boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 5)],
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16.0, 35, 16, 35),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                _buildExpressionDisplay(context),
                const SizedBox(
                  height: 50,
                ),
                _buildCalculatorButtons(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Expression display with history popup
  Widget _buildExpressionDisplay(BuildContext context) {
    return Obx(
      () => Container(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        alignment: Alignment.centerLeft,
        height: 50,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(border: Border.all(width: 0.1)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                controller.expression.value,
                style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black),
              ),
            ),
            PopupMenuButton<String>(
              onSelected: (value) {
                if (value == 'history') {
                  _showHistoryDialog(context);
                }
              },
              itemBuilder: (BuildContext context) {
                return const [
                  PopupMenuItem<String>(
                    value: 'history',
                    child: Text('History'),
                  ),
                ];
              },
            ),
          ],
        ),
      ),
    );
  }

  // Calculator buttons grid
  Widget _buildCalculatorButtons() {
    List<String> buttons = [
      '7', '8', '9', '/',
      '4', '5', '6', '*',
      '1', '2', '3', '-',
      '0', '.', '=', '+',
      'AC', 'C', // Add AC and C buttons
    ];

    return GridView.builder(
      shrinkWrap: true,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4, // Set 4 columns for the grid
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemCount: buttons.length,
      itemBuilder: (context, index) {
        return _buildButton(buttons[index]);
      },
    );
  }

  // Build individual buttons
  Widget _buildButton(String buttonText) {
    return ElevatedButton(
      onPressed: () {
        _onButtonPressed(buttonText);
      },
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.all(2),
        backgroundColor: _getButtonColor(buttonText),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50),
        ),
        elevation: 5,
      ),
      child: Text(
        buttonText,
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: _getTextColor(buttonText),
        ),
      ),
    );
  }

  // Button color based on text
  Color _getButtonColor(String buttonText) {
    if (buttonText == 'C') {
      return Colors.redAccent;
    } else if (buttonText == 'AC') {
      return Colors.deepOrange;
    } else if (buttonText == '=') {
      return Colors.greenAccent;
    } else {
      return Colors.grey[200]!; // Default color for other buttons
    }
  }

  // Text color based on button
  Color _getTextColor(String buttonText) {
    return (buttonText == 'C' || buttonText == 'AC' || buttonText == '=')
        ? Colors.white
        : Colors.black;
  }

  // Handle button press events
  void _onButtonPressed(String buttonText) {
    if (buttonText == 'C') {
      controller.clear();
    } else if (buttonText == 'AC') {
      controller.expression.value = '';
      controller.update();
    } else if (buttonText == '=') {
      controller.calculate();
    } else {
      controller.updateExpression(controller.expression.value + buttonText);
    }
  }

  // Show history in a dialog
  void _showHistoryDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('History'),
          content: SizedBox(
            height: 300,
            width: 300,
            child: Obx(
              () => ListView.builder(
                itemCount: controller.history.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(controller.history[index]),
                  );
                },
              ),
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Close'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
