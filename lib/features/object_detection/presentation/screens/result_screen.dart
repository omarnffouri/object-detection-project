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
      appBar: AppBar(title: const Text('Detection Result')),
      body: Column(
        children: [
          Expanded(child: Image.file(imageFile)),
          Text("Detected Object: $detectedObject"),
          Text("Timestamp: ${timestamp.toLocal()}"),
          ElevatedButton(
            onPressed: () => NavigationHelper.pushAndRemoveUntil(context,const ObjectSelectionScreen(), false),
            child: const Text('Back'),
          ),
        ],
      ),
    );
  }
}
