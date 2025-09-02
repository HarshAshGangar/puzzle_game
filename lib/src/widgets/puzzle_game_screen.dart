import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lottie/lottie.dart';
import '../models/puzzle_config.dart';
import '../controllers/puzzle_controller.dart';
import 'puzzle_piece_painter.dart';
import 'puzzle_piece_clipper.dart';
import 'dart:math' as math;

class PuzzleGameScreen extends StatefulWidget {
  final PuzzleConfig config;

  const PuzzleGameScreen({
    Key? key,
    required this.config,
  }) : super(key: key);

  @override
  _PuzzleGameScreenState createState() => _PuzzleGameScreenState();
}

class _PuzzleGameScreenState extends State<PuzzleGameScreen>
    with TickerProviderStateMixin {

  late PuzzleController _controller;

  @override
  void initState() {
    super.initState();
    _controller = PuzzleController(widget.config);
    _controller.initializeAnimations(this);
    _controller.loadRevealedPieces();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  // Bulge configurations (for 16 pieces - 4x4 grid)
  bool hasTopBulgeOut(int index) {
    switch (index) {
      case 4: case 5: case 6: case 7: case 11: case 14:
      return true;
      default:
        return false;
    }
  }

  bool hasTopBulgeIn(int index) {
    switch (index) {
      case 8: case 9: case 10: case 12: case 13: case 15:
      return true;
      default:
        return false;
    }
  }

  bool hasBottomBulgeOut(int index) {
    switch (index) {
      case 4: case 5: case 6: case 8: case 9: case 11:
      return true;
      default:
        return false;
    }
  }

  bool hasBottomBulgeIn(int index) {
    switch (index) {
      case 0: case 1: case 2: case 3: case 5: case 7: case 8: case 10:
      return true;
      default:
        return false;
    }
  }

  bool hasLeftBulgeOut(int index) {
    switch (index) {
      case 2: case 13: case 15:
      return true;
      default:
        return false;
    }
  }

  bool hasLeftBulgeIn(int index) {
    switch (index) {
      case 1: case 3: case 5: case 6: case 7: case 9: case 10: case 11: case 14:
      return true;
      default:
        return false;
    }
  }

  bool hasRightBulgeOut(int index) {
    switch (index) {
      case 0: case 2: case 4: case 5: case 6: case 8: case 9: case 10: case 13:
      return true;
      default:
        return false;
    }
  }

  bool hasRightBulgeIn(int index) {
    switch (index) {
      case 1: case 8: case 12: case 14:
      return true;
      default:
        return false;
    }
  }

  bool isSvgImage(String imagePath) {
    return imagePath.toLowerCase().endsWith('.svg');
  }

  Widget createPuzzlePiece(int pieceIndex, double size, {Color? backgroundColor, bool showImage = true, bool showBorder = true}) {
    final bulgeSize = size * widget.config.bulgeSize;
    double containerWidth = size;
    double containerHeight = size;

    if (hasLeftBulgeOut(pieceIndex) || hasRightBulgeOut(pieceIndex)) {
      containerWidth += bulgeSize;
    }
    if (hasTopBulgeOut(pieceIndex) || hasBottomBulgeOut(pieceIndex)) {
      containerHeight += bulgeSize;
    }

    return Container(
      width: containerWidth,
      height: containerHeight,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          if (backgroundColor != null)
            CustomPaint(
              size: Size(containerWidth, containerHeight),
              painter: PuzzlePiecePainter(
                fillColor: backgroundColor,
                hasTopBulgeOut: hasTopBulgeOut(pieceIndex),
                hasTopBulgeIn: hasTopBulgeIn(pieceIndex),
                hasBottomBulgeOut: hasBottomBulgeOut(pieceIndex),
                hasBottomBulgeIn: hasBottomBulgeIn(pieceIndex),
                hasLeftBulgeOut: hasLeftBulgeOut(pieceIndex),
                hasLeftBulgeIn: hasLeftBulgeIn(pieceIndex),
                hasRightBulgeOut: hasRightBulgeOut(pieceIndex),
                hasRightBulgeIn: hasRightBulgeIn(pieceIndex),
                bulgeDepth: widget.config.bulgeDepth,
                bulgeStartFraction: widget.config.bulgeStartFraction,
                bulgeEndFraction: widget.config.bulgeEndFraction,
              ),
            )
          else if (showImage)
            Positioned(
              left: hasLeftBulgeOut(pieceIndex) ? bulgeSize : 0,
              top: hasTopBulgeOut(pieceIndex) ? bulgeSize : 0,
              child: Container(
                width: size,
                height: size,
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    _getPositionedImage(pieceIndex, size),
                  ],
                ),
              ),
            ),
          if (showBorder)
            CustomPaint(
              size: Size(containerWidth, containerHeight),
              painter: PuzzlePiecePainter(
                borderColor: Colors.black87,
                borderWidth: 2.0,
                hasTopBulgeOut: hasTopBulgeOut(pieceIndex),
                hasTopBulgeIn: hasTopBulgeIn(pieceIndex),
                hasBottomBulgeOut: hasBottomBulgeOut(pieceIndex),
                hasBottomBulgeIn: hasBottomBulgeIn(pieceIndex),
                hasLeftBulgeOut: hasLeftBulgeOut(pieceIndex),
                hasLeftBulgeIn: hasLeftBulgeIn(pieceIndex),
                hasRightBulgeOut: hasRightBulgeOut(pieceIndex),
                hasRightBulgeIn: hasRightBulgeIn(pieceIndex),
                bulgeDepth: widget.config.bulgeDepth,
                bulgeStartFraction: widget.config.bulgeStartFraction,
                bulgeEndFraction: widget.config.bulgeEndFraction,
              ),
            ),
        ],
      ),
    );
  }

  Widget _getPositionedImage(int pieceIndex, double size) {
    switch (pieceIndex) {
      case 0: return _getPiece0Image(size);
      case 1: return _getPiece1Image(size);
      case 2: return _getPiece2Image(size);
      case 3: return _getPiece3Image(size);
      case 4: return _getPiece4Image(size);
      case 5: return _getPiece5Image(size);
      case 6: return _getPiece6Image(size);
      case 7: return _getPiece7Image(size);
      case 8: return _getPiece8Image(size);
      case 9: return _getPiece9Image(size);
      case 10: return _getPiece10Image(size);
      case 11: return _getPiece11Image(size);
      case 12: return _getPiece12Image(size);
      case 13: return _getPiece13Image(size);
      case 14: return _getPiece14Image(size);
      case 15: return _getPiece15Image(size);
      default: return Container();
    }
  }

  Widget _getPiece0Image(double size) {
    final imagePath = widget.config.puzzleImages[0];
    final bulgeSize = size * 0.01;
    return Positioned(
      left: hasRightBulgeOut(0) ? -bulgeSize : 0,
      top: hasBottomBulgeOut(0) ? -bulgeSize : 0,
      child: Transform.translate(
        offset: Offset(1, 0),
        child: Container(
          width: size + (hasRightBulgeOut(0) ? bulgeSize * 22 : 0),
          height: size + (hasBottomBulgeOut(0) ? bulgeSize : 0),
          child: isSvgImage(imagePath)
              ? SvgPicture.asset(imagePath, fit: BoxFit.cover)
              : Image.asset(imagePath, fit: BoxFit.cover),
        ),
      ),
    );
  }

  Widget _getPiece1Image(double size) {
    final imagePath = widget.config.puzzleImages[1];
    final bulgeSize = size * 0.02;
    return Positioned(
      left: hasLeftBulgeIn(1) ? bulgeSize * 0.5 : (hasRightBulgeOut(1) ? -bulgeSize : 0),
      top: hasBottomBulgeIn(1) ? bulgeSize * 0.5 : (hasBottomBulgeOut(1) ? -bulgeSize : 0),
      child: Transform.translate(
        offset: Offset(-3, -2),
        child: Container(
          width: size + (hasRightBulgeOut(1) || hasLeftBulgeIn(1) ? bulgeSize : 0),
          height: size + (hasBottomBulgeOut(1) || hasBottomBulgeIn(1) ? bulgeSize : 0),
          child: isSvgImage(imagePath)
              ? SvgPicture.asset(imagePath, fit: BoxFit.cover)
              : Image.asset(imagePath, fit: BoxFit.cover),
        ),
      ),
    );
  }

  Widget _getPiece2Image(double size) {
    final imagePath = widget.config.puzzleImages[2];
    final bulgeSize = size * 0.06;
    return Positioned(
      left: hasLeftBulgeOut(2) ? -bulgeSize : (hasRightBulgeOut(2) ? -bulgeSize : 0),
      top: hasBottomBulgeIn(2) ? bulgeSize * 0.5 : 0,
      child: Transform.translate(
        offset: Offset(-30, -6),
        child: Container(
          width: size + (hasLeftBulgeOut(2) || hasRightBulgeOut(2) ? bulgeSize * 9 : 0),
          height: size + (hasBottomBulgeIn(2) ? bulgeSize : 0),
          child: isSvgImage(imagePath)
              ? SvgPicture.asset(imagePath, fit: BoxFit.cover)
              : Image.asset(imagePath, fit: BoxFit.cover),
        ),
      ),
    );
  }

  Widget _getPiece3Image(double size) {
    final imagePath = widget.config.puzzleImages[3];
    final bulgeSize = size * 0.01;
    return Positioned(
      left: hasLeftBulgeIn(3) ? bulgeSize * 0.5 : 0,
      top: hasBottomBulgeIn(3) ? bulgeSize * 0.5 : 0,
      child: Transform.translate(
        offset: Offset(0, -1),
        child: Container(
          width: size + (hasLeftBulgeIn(3) ? bulgeSize : 0),
          height: size + (hasBottomBulgeIn(3) ? bulgeSize : 0),
          child: isSvgImage(imagePath)
              ? SvgPicture.asset(imagePath, fit: BoxFit.cover)
              : Image.asset(imagePath, fit: BoxFit.cover),
        ),
      ),
    );
  }

  Widget _getPiece4Image(double size) {
    final imagePath = widget.config.puzzleImages[4];
    final bulgeSize = size * 0.06;
    return Positioned(
      left: hasRightBulgeOut(4) ? -bulgeSize : 0,
      top: hasTopBulgeOut(4) ? -bulgeSize : (hasBottomBulgeOut(4) ? -bulgeSize : 0),
      child: Transform.translate(
        offset: Offset(4, -26),
        child: Container(
          width: size + (hasRightBulgeOut(4) ? bulgeSize * 4 : 0),
          height: size + (hasTopBulgeOut(4) || hasBottomBulgeOut(4) ? bulgeSize * 7.7 : 0),
          child: isSvgImage(imagePath)
              ? SvgPicture.asset(imagePath, fit: BoxFit.cover)
              : Image.asset(imagePath, fit: BoxFit.cover),
        ),
      ),
    );
  }

  Widget _getPiece5Image(double size) {
    final imagePath = widget.config.puzzleImages[5];
    final bulgeSize = size * 0.05;
    return Positioned(
      left: hasLeftBulgeIn(5) ? bulgeSize * 0.5 : (hasRightBulgeOut(5) ? -bulgeSize : 0),
      top: hasTopBulgeOut(5) ? -bulgeSize : (hasBottomBulgeOut(5) ? -bulgeSize : 0),
      child: Transform.translate(
        offset: Offset(-3, -27.5),
        child: Container(
          width: size + (hasRightBulgeOut(5) || hasLeftBulgeIn(5) ? bulgeSize * 4.5 : 0),
          height: size + (hasTopBulgeOut(5) || hasBottomBulgeOut(5) ? bulgeSize * 9.1 : 0),
          child: isSvgImage(imagePath)
              ? SvgPicture.asset(imagePath, fit: BoxFit.cover)
              : Image.asset(imagePath, fit: BoxFit.cover),
        ),
      ),
    );
  }

  Widget _getPiece6Image(double size) {
    final imagePath = widget.config.puzzleImages[6];
    final bulgeSize = size * 0.02;
    return Positioned(
      left: hasLeftBulgeIn(6) ? bulgeSize * 0.5 : (hasRightBulgeOut(6) ? -bulgeSize : 0),
      top: hasTopBulgeOut(6) ? -bulgeSize : (hasBottomBulgeOut(6) ? -bulgeSize : 0),
      child: Transform.translate(
        offset: Offset(0, -30),
        child: Container(
          width: size + (hasRightBulgeOut(6) || hasLeftBulgeIn(6) ? bulgeSize * 10 : 0),
          height: size + (hasTopBulgeOut(6) || hasBottomBulgeOut(6) ? bulgeSize * 22.5 : 0),
          child: isSvgImage(imagePath)
              ? SvgPicture.asset(imagePath, fit: BoxFit.cover)
              : Image.asset(imagePath, fit: BoxFit.cover),
        ),
      ),
    );
  }

  Widget _getPiece7Image(double size) {
    final imagePath = widget.config.puzzleImages[7];
    final bulgeSize = size * 0.011;
    return Positioned(
      left: hasLeftBulgeIn(7) ? bulgeSize * 0.5 : 0,
      top: hasTopBulgeOut(7) ? -bulgeSize : (hasBottomBulgeIn(7) ? bulgeSize * 0.5 : 0),
      child: Transform.translate(
        offset: Offset(-0.8, -32),
        child: Container(
          width: size + (hasLeftBulgeIn(7) ? bulgeSize : 0),
          height: size + (hasTopBulgeOut(7) || hasBottomBulgeIn(7) ? bulgeSize * 22.5 : 0),
          child: isSvgImage(imagePath)
              ? SvgPicture.asset(imagePath, fit: BoxFit.cover)
              : Image.asset(imagePath, fit: BoxFit.cover),
        ),
      ),
    );
  }

  Widget _getPiece8Image(double size) {
    final imagePath = widget.config.puzzleImages[8];
    final bulgeSize = size * 0.23;
    return Positioned(
      left: hasRightBulgeOut(8) ? -bulgeSize : (hasRightBulgeIn(8) ? bulgeSize * 0.5 : 0),
      top: hasTopBulgeIn(8) ? bulgeSize * 0.5 : (hasBottomBulgeOut(8) ? -bulgeSize : 0),
      child: Transform.translate(
        offset: Offset(19, -11),
        child: Container(
          width: size + (hasRightBulgeOut(8) || hasRightBulgeIn(8) ? bulgeSize : 0),
          height: size + (hasTopBulgeIn(8) || hasBottomBulgeOut(8) ? bulgeSize : 0),
          child: isSvgImage(imagePath)
              ? SvgPicture.asset(imagePath, fit: BoxFit.cover)
              : Image.asset(imagePath, fit: BoxFit.cover),
        ),
      ),
    );
  }

  Widget _getPiece9Image(double size) {
    final imagePath = widget.config.puzzleImages[9];
    final bulgeSize = size * 0.23;
    return Positioned(
      left: hasLeftBulgeIn(9) ? bulgeSize * 0.5 : (hasRightBulgeOut(9) ? -bulgeSize : 0),
      top: hasTopBulgeIn(9) ? bulgeSize * 0.5 : (hasBottomBulgeOut(9) ? -bulgeSize : 0),
      child: Transform.translate(
        offset: Offset(-10, -11),
        child: Container(
          width: size + (hasLeftBulgeIn(9) || hasRightBulgeOut(9) ? bulgeSize : 0),
          height: size + (hasTopBulgeIn(9) || hasBottomBulgeOut(9) ? bulgeSize : 0),
          child: isSvgImage(imagePath)
              ? SvgPicture.asset(imagePath, fit: BoxFit.cover)
              : Image.asset(imagePath, fit: BoxFit.cover),
        ),
      ),
    );
  }

  Widget _getPiece10Image(double size) {
    final imagePath = widget.config.puzzleImages[10];
    final bulgeSize = size * 0.0011;
    return Positioned(
      left: hasLeftBulgeIn(10) ? bulgeSize * 0.5 : (hasRightBulgeOut(10) ? -bulgeSize : 0),
      top: hasTopBulgeIn(10) ? bulgeSize * 0.5 : (hasBottomBulgeIn(10) ? bulgeSize * 0.5 : 0),
      child: Transform.translate(
        offset: Offset(-1, -1.5),
        child: Container(
          width: size + (hasLeftBulgeIn(10) || hasRightBulgeOut(10) ? bulgeSize * 220 : 0),
          height: size + (hasTopBulgeIn(10) || hasBottomBulgeIn(10) ? bulgeSize * 4 : 0),
          child: isSvgImage(imagePath)
              ? SvgPicture.asset(imagePath, fit: BoxFit.cover)
              : Image.asset(imagePath, fit: BoxFit.cover),
        ),
      ),
    );
  }

  Widget _getPiece11Image(double size) {
    final imagePath = widget.config.puzzleImages[11];
    final bulgeSize = size * 0.00105;
    return Positioned(
      left: hasLeftBulgeIn(11) ? bulgeSize * 0.5 : 0,
      top: hasTopBulgeOut(11) ? -bulgeSize : (hasBottomBulgeOut(11) ? -bulgeSize : 0),
      child: Transform.translate(
        offset: Offset(-0.6, -33),
        child: Container(
          width: size + (hasLeftBulgeIn(11) ? bulgeSize : 0),
          height: size + (hasTopBulgeOut(11) || hasBottomBulgeOut(11) ? bulgeSize * 435 : 0),
          child: isSvgImage(imagePath)
              ? SvgPicture.asset(imagePath, fit: BoxFit.cover)
              : Image.asset(imagePath, fit: BoxFit.cover),
        ),
      ),
    );
  }

  Widget _getPiece12Image(double size) {
    final imagePath = widget.config.puzzleImages[12];
    final bulgeSize = size * 0.02;
    return Positioned(
      left: hasRightBulgeIn(12) ? bulgeSize * 0.5 : 0,
      top: hasTopBulgeIn(12) ? bulgeSize * 0.5 : 0,
      child: Transform.translate(
        offset: Offset(-1, -3),
        child: Container(
          width: size + (hasRightBulgeIn(12) ? bulgeSize : 0),
          height: size + (hasTopBulgeIn(12) ? bulgeSize : 0),
          child: isSvgImage(imagePath)
              ? SvgPicture.asset(imagePath, fit: BoxFit.cover)
              : Image.asset(imagePath, fit: BoxFit.cover),
        ),
      ),
    );
  }

  Widget _getPiece13Image(double size) {
    final imagePath = widget.config.puzzleImages[13];
    final bulgeSize = size * 0.01;
    return Positioned(
      left: hasLeftBulgeOut(13) ? -bulgeSize : (hasRightBulgeOut(13) ? -bulgeSize : 0),
      top: hasTopBulgeIn(13) ? bulgeSize * 0.5 : 0,
      child: Transform.translate(
        offset: Offset(-31, -1),
        child: Container(
          width: size + (hasLeftBulgeOut(13) || hasRightBulgeOut(13) ? bulgeSize * 45 : 0),
          height: size + (hasTopBulgeIn(13) ? bulgeSize : 0),
          child: isSvgImage(imagePath)
              ? SvgPicture.asset(imagePath, fit: BoxFit.cover)
              : Image.asset(imagePath, fit: BoxFit.cover),
        ),
      ),
    );
  }

  Widget _getPiece14Image(double size) {
    final imagePath = widget.config.puzzleImages[14];
    final bulgeSize = size * 0.01;
    return Positioned(
      left: hasLeftBulgeIn(14) ? bulgeSize * 0.5 : (hasRightBulgeIn(14) ? bulgeSize * 0.5 : 0),
      top: hasTopBulgeOut(14) ? -bulgeSize : 0,
      child: Transform.translate(
        offset: Offset(0.05, -31.9),
        child: Container(
          width: size + (hasLeftBulgeIn(14) || hasRightBulgeIn(14) ? bulgeSize : 0),
          height: size + (hasTopBulgeOut(14) ? bulgeSize * 23 : 0),
          child: isSvgImage(imagePath)
              ? SvgPicture.asset(imagePath, fit: BoxFit.cover)
              : Image.asset(imagePath, fit: BoxFit.cover),
        ),
      ),
    );
  }

  Widget _getPiece15Image(double size) {
    final imagePath = widget.config.puzzleImages[15];
    final bulgeSize = size * 0.01;
    return Positioned(
      left: hasLeftBulgeOut(15) ? -bulgeSize : 0,
      top: hasTopBulgeIn(15) ? bulgeSize * 0.5 : 0,
      child: Transform.translate(
        offset: Offset(-31, -1),
        child: Container(
          width: size + (hasLeftBulgeOut(15) ? bulgeSize * 23 : 0),
          height: size + (hasTopBulgeIn(15) ? bulgeSize : 0),
          child: isSvgImage(imagePath)
              ? SvgPicture.asset(imagePath, fit: BoxFit.cover)
              : Image.asset(imagePath, fit: BoxFit.cover),
        ),
      ),
    );
  }


  Widget createPuzzleSlot(int slotIndex, double size, {required bool isDragTarget, required Widget child}) {
    return Container(
      width: size,
      height: size,
      child: Stack(
        children: [
          ClipPath(
            clipper: PuzzlePieceClipper(
              hasTopBulgeOut: hasTopBulgeOut(slotIndex),
              hasTopBulgeIn: hasTopBulgeIn(slotIndex),
              hasBottomBulgeOut: hasBottomBulgeOut(slotIndex),
              hasBottomBulgeIn: hasBottomBulgeIn(slotIndex),
              hasLeftBulgeOut: hasLeftBulgeOut(slotIndex),
              hasLeftBulgeIn: hasLeftBulgeIn(slotIndex),
              hasRightBulgeOut: hasRightBulgeOut(slotIndex),
              hasRightBulgeIn: hasRightBulgeIn(slotIndex),
              bulgeDepth: widget.config.bulgeDepth,
              bulgeStartFraction: widget.config.bulgeStartFraction,
              bulgeEndFraction: widget.config.bulgeEndFraction,
            ),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
              ),
              child: child,
            ),
          ),
          CustomPaint(
            size: Size(size, size),
            painter: PuzzlePiecePainter(
              hasTopBulgeOut: hasTopBulgeOut(slotIndex),
              hasTopBulgeIn: hasTopBulgeIn(slotIndex),
              hasBottomBulgeOut: hasBottomBulgeOut(slotIndex),
              hasBottomBulgeIn: hasBottomBulgeIn(slotIndex),
              hasLeftBulgeOut: hasLeftBulgeOut(slotIndex),
              hasLeftBulgeIn: hasLeftBulgeIn(slotIndex),
              hasRightBulgeOut: hasRightBulgeOut(slotIndex),
              hasRightBulgeIn: hasRightBulgeIn(slotIndex),
              borderColor: isDragTarget
                  ? (slotIndex == _controller.currentPieceIndex ? Colors.green : Colors.red)
                  : Colors.grey.shade400,
              borderWidth: isDragTarget ? 2.0 : 1.0,
              bulgeDepth: widget.config.bulgeDepth,
              bulgeStartFraction: widget.config.bulgeStartFraction,
              bulgeEndFraction: widget.config.bulgeEndFraction,
            ),
          ),
        ],
      ),
    );
  }

  // Fixed version of the build method section
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return Stack(
              children: [
                Column(
                  children: [
                    // Skip button
                    if (!_controller.showUnlockScreen)
                      _buildSkipButton(),

                    // Main content based on current state
                    if (_controller.showCongratsAndPiece && !_controller.showPuzzleGame)
                      _buildCongratsScreen()
                    else if (_controller.showPuzzleGame)
                      _buildPuzzleGame()
                    else if (_controller.showUnlockScreen)
                        _buildUnlockScreen(),
                  ],
                ),

                // Side animations
                if (_controller.showSideAnimations)
                  ..._buildSideAnimations(),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildSkipButton() {
    return Padding(
      padding: EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          GestureDetector(
            onTap: () {
              widget.config.onSkip?.call();
              Navigator.of(context).pop();
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(15),
                border: Border.all(color: widget.config.primaryColor, width: 1),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('Skip', style: TextStyle(
                    color: widget.config.primaryColor,
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                  )),
                  const SizedBox(width: 3),
                  Icon(Icons.skip_next_outlined,
                    size: 18,
                    color: widget.config.primaryColor,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCongratsScreen() {
    return Expanded(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              widget.config.congratsTitle,
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.w600,
                color: widget.config.primaryColor,
              ),
            ),
            SizedBox(height: 13),
            Text(
              widget.config.congratsSubtitle,
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Color(0xff808080)),
            ),
            Text(
              'Tap to reveal the surprise! 👀',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Color(0xff808080)),
            ),
            SizedBox(height: 45),
            if (!_controller.showPuzzlePiece)
              GestureDetector(
                onTap: _controller.revealPiece,
                child: createPuzzlePiece(
                  _controller.currentPieceIndex,
                  120,
                  backgroundColor: Colors.black,
                  showImage: false,
                  showBorder: true,
                ),
              )
            else
              AnimatedBuilder(
                animation: _controller.fadeAnimation,
                builder: (context, child) {
                  double pieceSize = 120;
                  double bulgeSize = pieceSize * widget.config.bulgeSize;
                  double containerWidth = pieceSize;
                  double containerHeight = pieceSize;

                  if (hasLeftBulgeOut(_controller.currentPieceIndex) ||
                      hasRightBulgeOut(_controller.currentPieceIndex)) {
                    containerWidth += bulgeSize;
                  }
                  if (hasTopBulgeOut(_controller.currentPieceIndex) ||
                      hasBottomBulgeOut(_controller.currentPieceIndex)) {
                    containerHeight += bulgeSize;
                  }

                  return Opacity(
                    opacity: _controller.fadeAnimation.value,
                    child: Container(
                      width: containerWidth,
                      height: containerHeight,
                      child: Stack(
                        clipBehavior: Clip.none,
                        children: [
                          _getPositionedImage(_controller.currentPieceIndex, pieceSize),
                        ],
                      ),
                    ),
                  );
                },
              ),
          ],
        ),
      ),
    );
  }


  Widget _buildPuzzleGame() {
    return Expanded(
      child: AnimatedBuilder(
        animation: _controller.navigationAnimation,
        builder: (context, child) {
          return Opacity(
            opacity: _controller.navigationAnimation.value,
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.all(20),
                  child: AnimatedBuilder(
                    animation: _controller.rotationAnimation,
                    builder: (context, child) {
                      double pieceSize = 85;
                      double bulgeSize = pieceSize * widget.config.bulgeSize;
                      double containerWidth = pieceSize;
                      double containerHeight = pieceSize;
                      if (hasLeftBulgeOut(_controller.currentPieceIndex) || hasRightBulgeOut(_controller.currentPieceIndex)) {
                        containerWidth += bulgeSize;
                      }
                      if (hasTopBulgeOut(_controller.currentPieceIndex) || hasBottomBulgeOut(_controller.currentPieceIndex)) {
                        containerHeight += bulgeSize;
                      }

                      return Draggable<int>(
                        data: _controller.currentPieceIndex,
                        feedback: Material(
                          color: Colors.transparent,
                          child: Transform.rotate(
                            angle: 0.0,
                            child: Container(
                              width: containerWidth,
                              height: containerHeight,
                              child: Stack(
                                clipBehavior: Clip.none,
                                children: [
                                  Positioned(
                                    left: hasLeftBulgeOut(_controller.currentPieceIndex) ? bulgeSize : 0,
                                    top: hasTopBulgeOut(_controller.currentPieceIndex) ? bulgeSize : 0,
                                    child: Container(
                                      width: pieceSize,
                                      height: pieceSize,
                                      child: Stack(
                                        clipBehavior: Clip.none,
                                        children: [
                                          _getPositionedImage(_controller.currentPieceIndex, pieceSize),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        childWhenDragging: Container(
                          width: containerWidth,
                          height: containerHeight,
                          color: Colors.transparent,
                          child: SizedBox.shrink(),
                        ),
                        child: Transform.rotate(
                          angle: _controller.rotationAnimation.value * 2 * math.pi * 3,
                          child: Container(
                            width: containerWidth,
                            height: containerHeight,
                            child: Stack(
                              clipBehavior: Clip.none,
                              children: [
                                Positioned(
                                  left: hasLeftBulgeOut(_controller.currentPieceIndex) ? bulgeSize : 0,
                                  top: hasTopBulgeOut(_controller.currentPieceIndex) ? bulgeSize : 0,
                                  child: Container(
                                    width: pieceSize,
                                    height: pieceSize,
                                    child: Stack(
                                      clipBehavior: Clip.none,
                                      children: [
                                        _getPositionedImage(_controller.currentPieceIndex, pieceSize),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                SizedBox(height: 20),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Center(
                      child: LayoutBuilder(
                        builder: (context, constraints) {
                          double availableWidth = constraints.maxWidth;
                          double gridSize = 340;

                          return Container(
                            width: availableWidth,
                            height: 400,
                            child: Stack(
                              clipBehavior: Clip.none,
                              children: List.generate(16, (index) {
                                int row = index ~/ 4;
                                int col = index % 4;
                                double pieceSize = 85;
                                double spacing = 85;

                                double startX = (availableWidth - gridSize) / 2;
                                double startY = 30;

                                double left = startX + (col * spacing);
                                double top = startY + (row * spacing);

                                return Positioned(
                                    left: left,
                                    top: top,
                                    child: DragTarget<int>(
                                      onAccept: (pieceIndex) {
                                        _controller.placePiece(index);
                                      },
                                      builder: (context, candidateData, rejectedData) {
                                        return createPuzzleSlot(
                                          index,
                                          pieceSize,
                                          isDragTarget: candidateData.isNotEmpty,
                                          child: _controller.placedPieces[index]
                                              ? createPuzzlePiece(_controller.piecePositions[index], pieceSize, showBorder: false)
                                              : Container(),
                                        );
                                      },
                                    )
                                );
                              }),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildUnlockScreen() {
    return AnimatedBuilder(
      animation: _controller.unlockFadeAnimation,
      builder: (context, child) {
        return Opacity(
          opacity: _controller.unlockFadeAnimation.value,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: 100,),
                Builder(
                  builder: (context) {
                    int revealedCount = _controller.revealedPieces.where((e) => e).length;
                    int remaining = 16 - revealedCount;
                    return Text(
                      'Unlock $remaining more pieces',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: widget.config.primaryColor,
                      ),
                    );
                  },
                ),
                Text(
                  'for a free surprise bag',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: widget.config.primaryColor,
                  ),
                ),
                SizedBox(height: 40),
                Row(
                  children: [
                    SizedBox(width: 60,),
                    AnimatedBuilder(
                      animation: _controller.unlockSlideAnimation,
                      builder: (context, child) {
                        return Transform.translate(
                          offset: Offset(0, MediaQuery.of(context).size.height * _controller.unlockSlideAnimation.value * 0.5),
                          child: Container(
                            width: 218,
                            height: 211,
                            child: widget.config.rewardImage != null
                                ? Image.asset(
                              widget.config.rewardImage!,
                              fit: BoxFit.contain,
                            )
                                : Icon(Icons.card_giftcard, size: 100, color: widget.config.primaryColor),
                          ),
                        );
                      },
                    ),
                  ],
                ),
                SizedBox(height: 180),
                AnimatedBuilder(
                  animation: _controller.unlockSlideAnimation,
                  builder: (context, child) {
                    return Transform.translate(
                      offset: Offset(0, MediaQuery.of(context).size.height * _controller.unlockSlideAnimation.value),
                      child: Container(
                        width: 280,
                        height: 60,
                        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                        child: ElevatedButton(
                          onPressed: () async {
                            widget.config.onComplete?.call();
                            Navigator.of(context).pop();
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: widget.config.buttonColor,
                            foregroundColor: Colors.white,
                            padding: EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 10,
                            shadowColor: Colors.black54,
                          ),
                          child: Text(
                            widget.config.unlockButtonText,
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  List<Widget> _buildSideAnimations() {
    return [
      AnimatedBuilder(
        animation: _controller.sideAnimation,
        builder: (context, child) {
          return Positioned(
            left: -90,
            bottom: 150,
            child: Opacity(
              opacity: _controller.sideAnimation.value,
              child: Container(
                width: 400,
                height: 400,
                child: widget.config.lottieAnimationPath != null
                    ? Lottie.asset(
                  widget.config.lottieAnimationPath!,
                  fit: BoxFit.contain,
                  repeat: true,
                  animate: true,
                )
                    : Icon(Icons.celebration, size: 100, color: widget.config.primaryColor),
              ),
            ),
          );
        },
      ),
      AnimatedBuilder(
        animation: _controller.sideAnimation,
        builder: (context, child) {
          return Positioned(
            left: 50,
            bottom: 150,
            child: Opacity(
              opacity: _controller.sideAnimation.value,
              child: Transform.scale(
                scaleX: -1,
                child: Container(
                  width: 400,
                  height: 400,
                  child: widget.config.lottieAnimationPath != null
                      ? Lottie.asset(
                    widget.config.lottieAnimationPath!,
                    fit: BoxFit.contain,
                    repeat: true,
                    animate: true,
                  )
                      : Icon(Icons.celebration, size: 100, color: widget.config.primaryColor),
                ),
              ),
            ),
          );
        },
      ),
    ];
  }
}
