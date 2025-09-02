import 'package:flutter/material.dart';
import '../models/puzzle_config.dart';
import '../utils/puzzle_storage.dart';
import 'dart:math' as math;

class PuzzleController extends ChangeNotifier {
  final PuzzleConfig config;
  late PuzzleStorage _storage;

  // Animation controllers
  late AnimationController fadeController;
  late AnimationController navigationController;
  late AnimationController continuousRotationController;
  late AnimationController lottieController;
  late AnimationController sideAnimationController;
  late AnimationController unlockFadeController;
  late AnimationController unlockSlideController;

  // Animations
  late Animation<double> fadeAnimation;
  late Animation<double> navigationAnimation;
  late Animation<double> rotationAnimation;
  late Animation<double> sideAnimation;
  late Animation<double> unlockFadeAnimation;
  late Animation<double> unlockSlideAnimation;

  // State variables
  bool showLottieAnimation = false;
  bool showPuzzlePiece = false;
  bool showPuzzleGame = false;
  int currentPieceIndex = 0;
  bool showSideAnimations = false;
  bool showCongratsAndPiece = true;
  bool showUnlockScreen = false;
  List<bool> placedPieces = List.filled(16, false);
  List<int> piecePositions = List.filled(16, -1);
  List<bool> revealedPieces = List.filled(16, false);

  late math.Random _random;
  bool _isRevealing = false;

  PuzzleController(this.config) {
    _storage = PuzzleStorage(config);
    _random = math.Random();
  }

  void initializeAnimations(TickerProvider vsync) {
    fadeController = AnimationController(
      duration: Duration(milliseconds: 1000),
      vsync: vsync,
    );
    fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: fadeController, curve: Curves.easeInOut),
    );

    navigationController = AnimationController(
      duration: Duration(milliseconds: 1000),
      vsync: vsync,
    );
    navigationAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: navigationController, curve: Curves.easeInOut),
    );

    continuousRotationController = AnimationController(
      duration: Duration(seconds: 20),
      vsync: vsync,
    )..repeat();

    rotationAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: continuousRotationController, curve: Curves.linear),
    );

    lottieController = AnimationController(
      duration: Duration(milliseconds: 1500),
      vsync: vsync,
    );

    sideAnimationController = AnimationController(
      duration: Duration(milliseconds: 2500),
      vsync: vsync,
    );
    sideAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: sideAnimationController, curve: Curves.easeInOut),
    );

    unlockFadeController = AnimationController(
      duration: Duration(milliseconds: 800),
      vsync: vsync,
    );
    unlockFadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: unlockFadeController, curve: Curves.easeInOut),
    );

    unlockSlideController = AnimationController(
      duration: Duration(milliseconds: 1200),
      vsync: vsync,
    );
    unlockSlideAnimation = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(parent: unlockSlideController, curve: Curves.easeOutCubic),
    );
  }

  Future<void> loadRevealedPieces() async {
    List<bool>? savedPieces = await _storage.getRevealedPieces();
    if (savedPieces != null) {
      revealedPieces = savedPieces;

      // Select random unrevealed piece
      List<int> unrevealedIndices = [];
      for (int i = 0; i < revealedPieces.length; i++) {
        if (!revealedPieces[i]) {
          unrevealedIndices.add(i);
        }
      }

      if (unrevealedIndices.isNotEmpty) {
        currentPieceIndex = unrevealedIndices[_random.nextInt(unrevealedIndices.length)];
      } else {
        currentPieceIndex = 0;
      }

      for (int i = 0; i < revealedPieces.length; i++) {
        if (revealedPieces[i]) {
          placedPieces[i] = true;
          piecePositions[i] = i;
        }
      }
    } else {
      currentPieceIndex = _random.nextInt(16);
    }
    notifyListeners();
  }

  Future<void> saveRevealedPieces() async {
    await _storage.saveRevealedPieces(revealedPieces);
  }

  void revealPiece() {
    if (_isRevealing) return;

    _isRevealing = true;
    showPuzzlePiece = true;
    showSideAnimations = true;
    notifyListeners();

    sideAnimationController.reset();
    fadeController.reset();

    Future.wait([
      sideAnimationController.forward(),
      fadeController.forward(),
    ]).then((_) {
      showSideAnimations = false;
      showPuzzleGame = true;
      _isRevealing = false;
      notifyListeners();

      navigationController.reset();
      navigationController.forward();
    });
  }

  void showUnlockScreenMethod() {
    showPuzzleGame = false;
    showCongratsAndPiece = false;
    showPuzzlePiece = false;
    showUnlockScreen = true;
    notifyListeners();

    unlockFadeController.reset();
    unlockSlideController.reset();
    unlockFadeController.forward();
    unlockSlideController.forward();
  }

  void completePuzzle() {
    int revealedCount = revealedPieces.where((e) => e).length;
    if (revealedCount >= 16) {
      config.onComplete?.call();
    }
  }

  void placePiece(int slotIndex) {
    if (slotIndex == currentPieceIndex) {
      placedPieces[slotIndex] = true;
      piecePositions[slotIndex] = currentPieceIndex;
      revealedPieces[currentPieceIndex] = true;
      saveRevealedPieces();
      showUnlockScreenMethod();
      notifyListeners();
    }
  }

  @override
  void dispose() {
    fadeController.dispose();
    navigationController.dispose();
    continuousRotationController.dispose();
    lottieController.dispose();
    sideAnimationController.dispose();
    unlockFadeController.dispose();
    unlockSlideController.dispose();
    super.dispose();
  }
}
