import 'dart:io';
import 'package:flutter/material.dart';
import 'package:vision_projecet/features/image_capture/presentation/screens/object_selection_screen.dart';
import 'package:vision_projecet/features/object_detection/presentation/screens/detection_screen.dart';
import 'package:vision_projecet/features/object_detection/presentation/screens/result_screen.dart';

class AppRouter {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case ObjectSelectionScreen.route:
        return MaterialPageRoute(builder: (_) => const ObjectSelectionScreen());

      case DetectionScreen.route:
        return MaterialPageRoute(builder: (_) => const DetectionScreen());

      case ResultScreen.route:
        if (settings.arguments is Map<String, dynamic>) {
          final args = settings.arguments as Map<String, dynamic>;
          final File imageFile = File(args['imagePath']);
          final String detectedObject = args['detectedObject'] ?? "Unknown";
          final DateTime timestamp = args['timestamp'] ?? DateTime.now();

          return MaterialPageRoute(
            builder: (_) => ResultScreen(
              imageFile: imageFile,
              detectedObject: detectedObject,
              timestamp: timestamp,
            ),
          );
        }
        return _errorRoute(settings.name);

      default:
        return _errorRoute(settings.name);
    }
  }

  static Route<dynamic> _errorRoute(String? routeName) {
    return MaterialPageRoute(
      builder: (_) => Scaffold(
        body: Center(
          child: Text('No route defined for $routeName'),
        ),
      ),
    );
  }
}
