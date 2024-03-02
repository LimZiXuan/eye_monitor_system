import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

void main() {
  runApp(EyeTraining());
}

class EyeTraining extends StatefulWidget {
  const EyeTraining({Key? key}) : super(key: key);

  @override
  _EyeTrainingState createState() => _EyeTrainingState();
}

class _EyeTrainingState extends State<EyeTraining> {
  bool _showInstruction = true;
  int _countdown = 3;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Eye Training"),
        centerTitle: true,
      ),
      body: _showInstruction ? _instructionPage() : _gamePage(),
    );
  }

  Widget _instructionPage() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Instructions:',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
          ),
          SizedBox(height: 20),
          Text(
            'Catch the ball with your eyes!',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16),
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              _startCountdown();
            },
            child: Text('Start'),
          ),
        ],
      ),
    );
  }

  Widget _gamePage() {
    return Stack(
      children: [
        GameScreen(),
        if (_countdown > 0)
          Center(
            child: Text(
              '$_countdown',
              style: TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
            ),
          ),
      ],
    );
  }

  void _startCountdown() {
    setState(() {
      _showInstruction = false;
    });

    Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (_countdown > 1) {
          _countdown--;
        } else {
          _countdown = 0;
          timer.cancel();
        }
      });
    });
  }
}

class GameScreen extends StatefulWidget {
  @override
  _GameScreenState createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  double ballX = 0;
  double ballY = 0;
  double playerX = 0;
  double screenHeight = 0;
  double screenWidth = 0;
  Timer? _ballTimer;

  void movePlayer(double dx) {
    setState(() {
      playerX = dx;
    });
  }

  void dropBall() {
    setState(() {
      ballX = Random().nextDouble() * screenWidth;
      ballY = 0;
    });
  }

  void checkCollision() {
    if ((ballY > screenHeight - 50) &&
        (ballX >= playerX && ballX <= playerX + 50)) {
      dropBall();
    }
  }

  @override
  void initState() {
    super.initState();
    _ballTimer = Timer.periodic(Duration(milliseconds: 10), (timer) {
      setState(() {
        ballY += 5;
        checkCollision();
      });
    });
  }

  @override
  void dispose() {
    _ballTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onHorizontalDragUpdate: (details) {
        movePlayer(playerX + details.delta.dx);
      },
      child: Stack(
        children: [
          Container(
            color: Colors.amber,
            child: Center(
              child: Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.red,
                ),
                margin: EdgeInsets.only(
                  top: ballY,
                  left: ballX,
                ),
              ),
            ),
          ),
          Positioned(
            left: playerX,
            bottom: 0,
            child: Container(
              width: 50,
              height: 20,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }
}
