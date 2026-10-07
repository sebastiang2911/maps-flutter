import 'package:flutter/material.dart';

class EndMarkerPainter extends CustomPainter {
  final int kilometers;
  final String location;

  EndMarkerPainter({
    required this.kilometers,
    required this.location,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final blackPaint = Paint()..color = Colors.black;
    final whitePaint = Paint()..color = Colors.white;

    const double circleBlackRadious = 20;
    const double circleWhiteRadious = 7;

    // Black circle
    canvas.drawCircle(
      Offset(size.width * 0.5, size.height - circleBlackRadious),
      circleBlackRadious,
      blackPaint,
    );

    // White circle
    canvas.drawCircle(
      Offset(size.width * 0.5, size.height - circleBlackRadious),
      circleWhiteRadious,
      whitePaint,
    );

    // Draw white box
    final path = Path();
    path.moveTo(10, 20);
    path.lineTo(size.width - 10, 20);
    path.lineTo(size.width - 10, 100);
    path.lineTo(10, 100);

    //Shadow

    canvas.drawShadow(path, Colors.black, 10, false);
    canvas.drawPath(path, whitePaint);

    // Draw black box
    const blackBox = Rect.fromLTWH(10, 20, 70, 80);
    canvas.drawRect(blackBox, blackPaint);

    // Text...

    final textSpan = TextSpan(
      text: kilometers.toString(),
      style: const TextStyle(
        color: Colors.white,
        fontSize: 22,
        fontWeight: FontWeight.w400,
      ),
    );

    final minutesPainter = TextPainter(
      text: textSpan,
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.center,
    )..layout(minWidth: 70, maxWidth: 70);

    minutesPainter.paint(canvas, const Offset(10, 35));

    // Word MINUTES
    const minutesText = TextSpan(
      text: 'KMS',
      style: TextStyle(
        color: Colors.white,
        fontSize: 20,
        fontWeight: FontWeight.w200,
      ),
    );

    final minutesMinPainter = TextPainter(
      text: minutesText,
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.center,
    )..layout(
        minWidth: 70,
        maxWidth: 70,
      );

    minutesMinPainter.paint(canvas, const Offset(10, 68));

    // Space description
    final locationText = TextSpan(
      text: location,
      style: const TextStyle(
        color: Colors.black,
        fontSize: 20,
        fontWeight: FontWeight.w300,
      ),
    );

    final locationPainter = TextPainter(
      maxLines: 2,
      ellipsis: '...',
      text: locationText,
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.left,
    )..layout(
        minWidth: size.width - 95,
        maxWidth: size.width - 95,
      );

    final double offsettY = (location.length > 25) ? 35 : 48;

    locationPainter.paint(canvas, Offset(90, offsettY));
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;

  @override
  bool shouldRebuildSemantics(covariant CustomPainter oldDelegate) => false;
}
