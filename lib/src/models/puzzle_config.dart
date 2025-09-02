import 'package:flutter/material.dart';

enum StorageType {
  sharedPreferences,
  basicApi,      // Simple API - no authentication
  jwtApi,        // JWT token authentication
  firebase,
}

class PuzzleConfig {
  final List<String> puzzleImages; // 16 user images
  final String? lottieAnimationPath;
  final String? rewardImage;
  final String congratsTitle;
  final String congratsSubtitle;
  final String unlockButtonText;
  final Color primaryColor;
  final Color buttonColor;

  // Bulge customization
  final double bulgeSize;
  final double bulgeDepth;
  final double bulgeStartFraction;
  final double bulgeEndFraction;

  // Storage options
  final StorageType storageType;
  final String? getApiUrl;       // GET API URL
  final String? postApiUrl;      // POST API URL
  final String? deleteApiUrl;    // DELETE API URL (Optional)
  final String? jwtToken;        // JWT token for authenticated API
  final String? userId;          // User identifier

  final Function()? onComplete;
  final Function()? onSkip;

  PuzzleConfig({
    required this.puzzleImages,
    this.lottieAnimationPath,
    this.rewardImage,
    this.congratsTitle = 'Congratulations',
    this.congratsSubtitle = 'You\'ve just unlocked a puzzle piece!',
    this.unlockButtonText = 'UNLOCK',
    this.primaryColor = const Color(0xff017F01),
    this.buttonColor = const Color(0xff017F01),

    this.bulgeSize = 0.15,
    this.bulgeDepth = 0.29,
    this.bulgeStartFraction = 0.34,
    this.bulgeEndFraction = 0.64,

    // Storage settings
    this.storageType = StorageType.sharedPreferences,
    this.getApiUrl,
    this.postApiUrl,
    this.deleteApiUrl, // Optional
    this.jwtToken,
    this.userId,

    this.onComplete,
    this.onSkip,
  }) : assert(puzzleImages.length == 16, 'Must provide exactly 16 puzzle images'),
        assert(storageType != StorageType.basicApi || (getApiUrl != null && postApiUrl != null),
        'GET and POST API URLs required for basic API storage'),
        assert(storageType != StorageType.jwtApi || (getApiUrl != null && postApiUrl != null && jwtToken != null),
        'GET/POST URLs and JWT token required for JWT API storage'),
        assert(storageType != StorageType.firebase || userId != null,
        'User ID required for Firebase storage');
}
