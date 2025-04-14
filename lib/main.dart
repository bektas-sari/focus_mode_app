import 'dart:async';
import 'package:flutter/material.dart';

void main() {
  runApp(const FocusModeApp());
}

class FocusModeApp extends StatelessWidget {
  const FocusModeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Focus Mode',
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.deepPurple,
        scaffoldBackgroundColor: Colors.deepPurple.shade50,
      ),
      home: const FocusModeHomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class FocusModeHomePage extends StatefulWidget {
  const FocusModeHomePage({super.key});

  @override
  State<FocusModeHomePage> createState() => _FocusModeHomePageState();
}

class _FocusModeHomePageState extends State<FocusModeHomePage> {
  int selectedMinutes = 25;
  int remainingSeconds = 25 * 60;
  Timer? _timer;
  bool isRunning = false;

  void _startTimer() {
    if (_timer != null) return;
    setState(() {
      isRunning = true;
    });

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (remainingSeconds > 0) {
        setState(() {
          remainingSeconds--;
        });
      } else {
        _stopTimer();
      }
    });
  }

  void _stopTimer() {
    _timer?.cancel();
    _timer = null;
    setState(() {
      isRunning = false;
      remainingSeconds = selectedMinutes * 60;
    });
  }

  String _formatTime(int totalSeconds) {
    final minutes = (totalSeconds ~/ 60).toString().padLeft(2, '0');
    final seconds = (totalSeconds % 60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  @override
  Widget build(BuildContext context) {
    double progress = remainingSeconds / (selectedMinutes * 60);
    return Scaffold(
      appBar: AppBar(title: const Text('Focus Mode'), centerTitle: true),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (!isRunning) ...[
              const Text(
                'Select Focus Time (minutes)',
                style: TextStyle(fontSize: 16),
              ),
              Slider(
                min: 15,
                max: 90,
                divisions: 15,
                value: selectedMinutes.toDouble(),
                label: '$selectedMinutes min',
                onChanged: (value) {
                  setState(() {
                    selectedMinutes = value.round();
                    remainingSeconds = selectedMinutes * 60;
                  });
                },
              ),
              const SizedBox(height: 20),
            ],
            Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  width: 200,
                  height: 200,
                  child: CircularProgressIndicator(
                    value: progress,
                    strokeWidth: 12,
                    backgroundColor: Colors.grey.shade300,
                    valueColor: const AlwaysStoppedAnimation<Color>(
                      Colors.deepPurple,
                    ),
                  ),
                ),
                Text(
                  _formatTime(remainingSeconds),
                  style: const TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 30),
            ElevatedButton.icon(
              onPressed: isRunning ? _stopTimer : _startTimer,
              icon: Icon(isRunning ? Icons.stop : Icons.play_arrow),
              label: Text(isRunning ? 'Stop' : 'Start Focus'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 16,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
