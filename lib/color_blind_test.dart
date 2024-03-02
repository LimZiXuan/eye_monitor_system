import 'package:flutter/material.dart';

class ColorBlindTest extends StatefulWidget {
  const ColorBlindTest({Key? key}) : super(key: key);

  @override
  _ColorBlindTestState createState() => _ColorBlindTestState();
}

class _ColorBlindTestState extends State<ColorBlindTest> {
  List<ColorBlindImage> images = [
    ColorBlindImage(
      imagePath: 'assets/img/download.png',
      correctOptionIndex: 1,
      options: ['71', '74', '70', '79'],
    ),
    ColorBlindImage(
      imagePath: 'assets/img/img1.png',
      correctOptionIndex: 0,
      options: ['12', '13', '14', '15'],
    ),
    ColorBlindImage(
      imagePath: 'assets/img/img2.png',
      correctOptionIndex: 1,
      options: ['5', '8', '9', '2'],
    ),
    ColorBlindImage(
      imagePath: 'assets/img/img3.png',
      correctOptionIndex: 3,
      options: ['9', '2', '3', '6'],
    ),
    // Add more ColorBlindImage instances for additional test images
  ];

  int currentImageIndex = 0;
  int? selectedOptionIndex;

  void selectOption(int index) {
    setState(() {
      selectedOptionIndex = index;
    });
  }

  void goToNextImage() {
    setState(() {
      if (currentImageIndex < images.length - 1) {
        currentImageIndex++;
        selectedOptionIndex = null;
      } else {
        // Show results or navigate to another page
        // For simplicity, just print results
        print('Test completed!');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Color Blind Test'),
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(16.0),
            child: Image.asset(
              images[currentImageIndex].imagePath,
              width: MediaQuery.of(context).size.width * 0.8,
            ),
          ),
          SizedBox(height: 20),
          if (selectedOptionIndex != null)
            Text(
              selectedOptionIndex ==
                      images[currentImageIndex].correctOptionIndex
                  ? 'Correct!'
                  : 'Incorrect!',
              style: TextStyle(
                color: selectedOptionIndex ==
                        images[currentImageIndex].correctOptionIndex
                    ? Colors.green
                    : Colors.red,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children:
                images[currentImageIndex].options.asMap().entries.map((option) {
              return ElevatedButton(
                onPressed: selectedOptionIndex == null
                    ? () => selectOption(option.key)
                    : null,
                child: Text(option.value),
                style: ButtonStyle(
                  backgroundColor: selectedOptionIndex != null
                      ? MaterialStateProperty.all<Color>(
                          option.key ==
                                  images[currentImageIndex].correctOptionIndex
                              ? Colors.green
                              : Colors.red,
                        )
                      : null,
                ),
              );
            }).toList(),
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: selectedOptionIndex != null ? goToNextImage : null,
            child: Text('Next'),
          ),
        ],
      ),
    );
  }
}

class ColorBlindImage {
  final String imagePath;
  final List<String> options;
  final int correctOptionIndex;

  ColorBlindImage({
    required this.imagePath,
    required this.options,
    required this.correctOptionIndex,
  });
}
