import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:vision_projecet/core/services/camera_service.dart';
import 'package:vision_projecet/features/object_detection/domain/entities/detection.dart';
import 'package:vision_projecet/features/object_detection/presentation/screens/result_screen.dart';
import '../../data/repositories/object_detection_repository.dart';

class ObjectDetectionProvider extends ChangeNotifier {
  final CameraService _cameraService = CameraService();
  final ObjectDetectionRepository _repository = ObjectDetectionRepository();

  CameraService get cameraService => _cameraService;

  String? _selectedObject;
  bool _isDetected = false;
  double _objectSize = 0.0;
  String _guidanceMessage = "Detecting object...";
  bool _isProcessing = false;
  Timer? _timer;

  String? get selectedObject => _selectedObject;
  bool get isDetected => _isDetected;
  double get objectSize => _objectSize;
  String get guidanceMessage => _guidanceMessage;

void setSelectedObject(String objectName) {
  _selectedObject = objectName;
  _isDetected = false;
  _objectSize = 0.0;
  _guidanceMessage = "Detecting $_selectedObject...";

  _timer?.cancel();
  _isProcessing = false;

  notifyListeners();
}


  Future<void> initializeCamera(BuildContext context) async {
     _timer?.cancel();
  _isProcessing = false;
  await _cameraService.initializeCamera();

  _timer = Timer.periodic(const Duration(seconds: 2), (timer) async {
    if (_isProcessing) return;
    _isProcessing = true;

    var imageFile = await _cameraService.captureImage();
    if (imageFile != null) {
      await processImage(context,imageFile);

    
      if (isDetected) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('✅ Object Detected! Auto-capturing...')),
        );

        _timer?.cancel();

        // Navigate to result screen after successful detection
        Navigator.pushNamed(
          context,
          ResultScreen.route,
          arguments: {
            'imagePath': imageFile.path,
            'detectedObject': selectedObject ?? "Unknown",
            'timestamp': DateTime.now(),
          },
        );
      }
    }

    _isProcessing = false;
  });

  notifyListeners();
}

void startDetection(BuildContext context) {
  _timer?.cancel(); // Cancel any existing timer.
  _timer = Timer.periodic(const Duration(seconds: 2), (timer) async {
    if (_isProcessing || _isDetected) return; // Do nothing if processing or already detected.

    _isProcessing = true;
    var imageFile = await _cameraService.captureImage();
    if (imageFile != null) {
      await processImage(context, imageFile);
    }
    _isProcessing = false;
  });
}


Future<void> processImage(BuildContext context, File imageFile) async {
  if (_selectedObject == null) return;

  // Retrieve detection results from the repository.
  List<DetectionResult> detectedObjects = await _repository.detectObjectsFromImage(imageFile);

  if (detectedObjects.isEmpty) {
    _isDetected = false;
    _guidanceMessage = "❌ No objects detected!";
    notifyListeners();
    return;
  }

  // Check if any detected object's label matches the selected object.
  bool matchFound = detectedObjects.any((detected) =>
      detected.label.toLowerCase() == _selectedObject!.toLowerCase());

  if (matchFound) {
    _isDetected = true;
    _guidanceMessage = "✅ Object in position!";
    notifyListeners();

    // Cancel the timer to prevent further captures.
    _timer?.cancel();
    _timer = null;

    // Wait a short delay for the UI to update, then trigger auto-capture.
    Future.delayed(const Duration(milliseconds: 500), () {
      autoCapture(context, imageFile);
    });
  } else {
    _isDetected = false;
    _guidanceMessage = "❌ Object does not match!";
    notifyListeners();
    // Let the timer continue so that detection will re-check on subsequent captures.
  }
}





 void autoCapture(BuildContext context, File imageFile) {
  // Ensure the detection timer is stopped.
  _timer?.cancel();
  _timer = null;
  notifyListeners();

  // Navigate to the ResultScreen only once.
  Navigator.pushNamed(
    context,
    ResultScreen.route,
    arguments: {
      'imagePath': imageFile.path,
      'detectedObject': _selectedObject ?? "Unknown",
      'timestamp': DateTime.now(),
    },
  );
}



  void disposeCamera(){
  _timer?.cancel(); 
  _isProcessing = false; 
  _cameraService.dispose();
  notifyListeners();
  }

}
