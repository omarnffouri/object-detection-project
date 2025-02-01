import 'dart:io';
import 'package:camera/camera.dart';

class CameraService {
  CameraController? _controller;
  late List<CameraDescription> _cameras;

  Future<void> initializeCamera() async {
    _cameras = await availableCameras();
    _controller = CameraController(_cameras[0], ResolutionPreset.medium);
    await _controller!.initialize();
  }

  CameraController? get controller => _controller;

  Future<File?> captureImage() async {
    if (_controller != null && _controller!.value.isInitialized) {
      final XFile file = await _controller!.takePicture();
      return File(file.path);
    }
    return null;
  }

  void dispose() {
    _controller?.dispose();
  }
}
