import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';

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
  int points = 0;
  int stars = 0;
  final int totalStars = 10;
  bool collisionDetected = false;
  bool allstarsShowed = false;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  FirebaseAuth auth = FirebaseAuth.instance;
  final uid = FirebaseAuth.instance.currentUser!.uid;

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
        if (points < totalStars ~/ 2) {
          generateStarPosition();
          _showTimer = Timer(Duration(seconds: 1), () {
            setState(() {
              showStar = false;
              collisionDetected =
                  false; // Reset collision detection for next star
            });
          });
        } else {
          _starTimer?.cancel();
          _showTimer?.cancel();
          recordTestResult(points >= totalStars ~/ 2);
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: Text('Test Completed'),
              content: Text(points >= totalStars ~/ 2
                  ? 'You have successfully completed the test.'
                  : 'You have failed the test.'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context); // Close the dialog
                    Navigator.pop(context); // Return to previous page
                  },
                  child: Text('OK'),
                ),
              ],
            ),
          );
        }
      });
    });
  }

  void generateStarPosition() {
    setState(() {
      starX = Random().nextDouble() * screenWidth;
      starY = Random().nextDouble() * screenHeight;
      showStar = true;
      collisionDetected = false; // Reset collision detection for new star
      stars++;
      if (stars == 10) {
        allstarsShowed = true;
      }

      if (allstarsShowed && (points < totalStars ~/ 2)) {
        _starTimer?.cancel();
        _showTimer?.cancel();
        recordTestResult(false); // Record test result as fail
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Test Completed'),
            content: Text('You have failed the test.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context); // Close the dialog
                  Navigator.pop(context); // Return to previous page
                },
                child: Text('OK'),
              ),
            ],
          ),
        );
      }
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
    if (!collisionDetected &&
        (ballX <= starX + 50 && ballX >= starX - 50) &&
        (ballY <= starY + 50 && ballY >= starY - 50)) {
      setState(() {
        showStar = false;
        points++;
        collisionDetected = true; // Set collision detected flag
      });
    }
    if (!allstarsShowed && points >= totalStars ~/ 2) {
      _starTimer?.cancel();
      _showTimer?.cancel();
      recordTestResult(true); // Record test result as pass
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Test Completed'),
          content: Text('You have successfully completed the test.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close the dialog
                Navigator.pop(context); // Return to previous page
              },
              child: Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  void recordTestResult(bool pass) async {
    try {
      User? user = auth.currentUser;
      if (user != null) {
        await _firestore
            .collection('User')
            .doc(user.uid)
            .collection('TestHistory')
            .add({
          'testType': 'Eye Training',
          'pass': pass,
          'timestamp': DateTime.now(),
        });

        print('Eye Training test result recorded successfully!');
      }
    } catch (e) {
      print('Error recording eye training test result: $e');
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
          Positioned(
            left: 10,
            top: 10,
            child: Text(
              'Points: $points',
              style: TextStyle(color: Colors.white),
            ),
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
