import 'dart:io';
import 'package:flutter/material.dart';
import 'package:vision_projecet/core/utils/navigation_helper.dart';
import 'package:vision_projecet/features/image_capture/presentation/screens/object_selection_screen.dart';

class ResultScreen extends StatelessWidget {
static const String route = '/result-screen';

  final File imageFile;
  final String detectedObject;
  final DateTime timestamp;

  const ResultScreen({
    super.key,
    required this.imageFile,
    required this.detectedObject,
    required this.timestamp,
  });

  @override
Widget build(BuildContext context) {
  return Scaffold(
    body: Stack(
      fit: StackFit.expand,
      children: [
        Image.file(
          imageFile,
          fit: BoxFit.cover,
        ),
        Positioned(
          bottom: 50,
          left: 0,
          right: 0,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.black54,
                  borderRadius: BorderRadius.circular(12)
                ),
                child: Column(
                  children: [
                    Text(
                      "Detected Object: $detectedObject",
                      style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      "Timestamp: ${timestamp.toLocal()}",
                      style: const TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () => NavigationHelper.pushAndRemoveUntil(context, const ObjectSelectionScreen(), false),
                child: const Text('Back'),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

}
