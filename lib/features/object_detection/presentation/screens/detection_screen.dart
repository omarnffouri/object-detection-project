import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:provider/provider.dart';
import 'package:vision_projecet/features/object_detection/presentation/providers/object_detection_provicer.dart';

class DetectionScreen extends StatefulWidget {
  static const String route = '/detection-screen';

  const DetectionScreen({super.key});

  @override
  State<DetectionScreen> createState() => _DetectionScreenState();
}

class _DetectionScreenState extends State<DetectionScreen> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    Future.delayed(Duration.zero, () {
      Provider.of<ObjectDetectionProvider>(context, listen: false).initializeCamera(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Object Detection')),
      body: Consumer<ObjectDetectionProvider>(
        builder: (context, provider, child) {
          final controller = provider.cameraService.controller;

          if (controller == null || !controller.value.isInitialized) {
            return const Center(child: CircularProgressIndicator());
          }

          return Column(
            children: [
              Expanded(
                child: AspectRatio(
                  aspectRatio: controller.value.aspectRatio,
                  child: CameraPreview(controller),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  provider.guidanceMessage,
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
