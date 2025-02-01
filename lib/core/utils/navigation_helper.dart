import 'dart:io';
import 'package:flutter/material.dart';
import 'package:vision_projecet/features/object_detection/presentation/screens/result_screen.dart';

class NavigationHelper {
  static void navigateTo(BuildContext context, Widget destination) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => destination),
    );
  }

  static void navigateBack(BuildContext context) {
    Navigator.of(context).pop();
  }

  static void pushAndRemoveUntil(BuildContext context,Widget destination,bool hasRoute){
       Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (_) => destination),
                (Route<dynamic> route) => hasRoute,
              );
  }

  static void navigateToResult(BuildContext context, File imageFile, String detectedObject, DateTime timestamp) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => ResultScreen(
          imageFile: imageFile,
          detectedObject: detectedObject,
          timestamp: timestamp,
        ),
      ),
    );
  }
}
