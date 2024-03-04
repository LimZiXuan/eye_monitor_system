import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math';

class EyeTraining extends StatefulWidget {
  const EyeTraining({Key? key}) : super(key: key);

  @override
  _EyeTrainingState createState() => _EyeTrainingState();
}

class _EyeTrainingState extends State<EyeTraining> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Eye Training"),
        centerTitle: true,
      ),
      body: EyeGame(speed: 2), // Adjust speed here
    );
  }
}

class EyeGame extends StatefulWidget {
  final double speed;

  const EyeGame({Key? key, required this.speed}) : super(key: key);

  @override
  _EyeGameState createState() => _EyeGameState();
}

class _EyeGameState extends State<EyeGame> {
  Timer? _starTimer;
  Timer? _showTimer;
  double ballX = 0;
  double ballY = 0;
  double screenWidth = 0;
  double screenHeight = 0;
  double starX = 0;
  double starY = 0;
  bool showStar = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      setState(() {
        screenWidth = MediaQuery.of(context).size.width;
        screenHeight = MediaQuery.of(context).size.height;
        startGame();
      });
    });
  }

  void startGame() {
    _starTimer = Timer.periodic(Duration(seconds: 2), (timer) {
      setState(() {
        showStar = true;
        generateStarPosition();
        _showTimer = Timer(Duration(seconds: 1), () {
          setState(() {
            showStar = false;
          });
        });
      });
    });
  }

  void generateStarPosition() {
    setState(() {
      starX = Random().nextDouble() * screenWidth;
      starY = Random().nextDouble() * screenHeight;
    });
  }

  void onTap(double x, double y) {
    setState(() {
      ballX = x - 25; // Adjust for the ball's width
      ballY = y - 25; // Adjust for the ball's height
    });
    checkCollision();
  }

  void checkCollision() {
    if ((ballX <= starX + 50 && ballX >= starX - 50) &&
        (ballY <= starY + 50 && ballY >= starY - 50)) {
      setState(() {
        showStar = false;
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
    _starTimer?.cancel(); // Cancel the timer if it is not null
    _showTimer?.cancel(); // Cancel the timer if it is not null
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanUpdate: (details) {
        onTap(details.localPosition.dx, details.localPosition.dy);
      },
      child: Stack(
        children: [
          Container(
            color: Colors.black,
          ),
          if (showStar)
            Positioned(
              left: starX,
              top: starY,
              child: Icon(
                Icons.star,
                color: Colors.yellow,
                size: 50,
              ),
            ),
          Positioned(
            left: ballX,
            top: ballY,
            child: Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: Colors.red,
                shape: BoxShape.circle,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
