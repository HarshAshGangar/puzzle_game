import 'package:flutter/material.dart';
import 'package:puzzle_game/puzzle_game.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Puzzle Game Example',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  // Sample puzzle images - in real app, use your own images
  final List<String> puzzleImages = [
    'assets/images/piece1.png',
    'assets/images/piece2.png',
    //till the last image
    'assets/images/piece16.png',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Puzzle Game Example'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => PuzzleGameScreen(
                  config: PuzzleConfig(
                    puzzleImages: puzzleImages,
                    congratsTitle: 'Awesome!',
                    congratsSubtitle: 'You found a puzzle piece!',
                    unlockButtonText: 'COLLECT',
                    primaryColor: Colors.purple,
                    buttonColor: Colors.deepPurple,
                    onComplete: () {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Puzzle completed!')),
                      );
                    },
                    onSkip: () {
                      Navigator.pop(context);
                    },
                  ),
                ),
              ),
            );
          },
          child: Text('Start Puzzle Game'),
        ),
      ),
    );
  }
}
