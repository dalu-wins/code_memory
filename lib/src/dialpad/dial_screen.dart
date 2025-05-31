import 'package:code_memory/src/generator/generator_screen.dart';
import 'package:flutter/material.dart';

class DialScreen extends StatefulWidget {
  final String pin;

  const DialScreen({super.key, required this.pin});

  @override
  State<DialScreen> createState() => _DialScreenState();
}

class _DialScreenState extends State<DialScreen> {
  List<String> enteredDigits = [];

  void _nextRound() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => GeneratorScreen()),
    );
  }

  void _onIncomplete() {
    print("Incomplete");
  }

  void _onError() {
    print("Error");
    setState(() {
      enteredDigits.clear();
    });
  }

  void _onSuccess() {
    print("Success");
    _nextRound();
  }

  void _appendDigit(String digit) {
    if (enteredDigits.length < widget.pin.length) {
      setState(() {
        enteredDigits.add(digit);
      });
    }
  }

  void _deleteDigit() {
    if (enteredDigits.isNotEmpty) {
      setState(() {
        enteredDigits.removeLast();
      });
    }
  }

  void _onOkPressed() {
    final enteredPin = enteredDigits.join();

    print("Entered PIN: $enteredPin");

    if (enteredPin.length != widget.pin.length) {
      _onIncomplete();
    } else if (enteredPin != widget.pin) {
      _onError();
    } else {
      _onSuccess();
    }
  }

  Widget _buildPinDots() {
    var dotColor = Theme.of(context).colorScheme.secondary;

    return Expanded(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: List.generate(widget.pin.length, (index) {
          bool filled = index < enteredDigits.length;
          return Container(
            margin: EdgeInsets.symmetric(horizontal: 8),
            width: 20,
            height: 20,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: filled ? dotColor : Colors.transparent,
              border: Border.all(
                color: dotColor,
                width: 2,
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildKeypad() {
    final keys = [
      ['1', '2', '3'],
      ['4', '5', '6'],
      ['7', '8', '9'],
      ['del', '0', 'ok'],
    ];

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: keys.map((row) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: row.map((label) {
            if (label == 'del') {
              return _buildButton(
                child: Icon(Icons.backspace, size: 24),
                onPressed: _deleteDigit,
              );
            } else if (label == 'ok') {
              return _buildButton(
                child: Icon(Icons.check, size: 24),
                onPressed: _onOkPressed,
              );
            } else {
              return _buildButton(
                child: Text(label, style: TextStyle(fontSize: 24)),
                onPressed: () => _appendDigit(label),
              );
            }
          }).toList(),
        );
      }).toList(),
    );
  }

  Widget _buildButton({
    required Widget child,
    required VoidCallback onPressed,
  }) {
    return FilledButton.tonal(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        shape: CircleBorder(),
        padding: EdgeInsets.all(40),
      ),
      child: child,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: _nextRound,
            icon: Icon(Icons.fast_forward),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            _buildPinDots(),
            _buildKeypad(),
          ],
        ),
      ),
    );
  }
}
