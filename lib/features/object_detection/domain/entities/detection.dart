import 'dart:ui';

class DetectionResult {
  final String label;
  final Rect? boundingBox;
  DetectionResult( {
    required this.label,
    this.boundingBox
  });
}