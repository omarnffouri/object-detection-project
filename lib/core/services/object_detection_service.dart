import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';

class ObjectDetectionService {
  final Dio dio = Dio();
  final String apiKey;

  ObjectDetectionService(this.apiKey);

  Future<void> detectObjects(File imageFile) async {
    try {
      final imageBytes = await imageFile.readAsBytes();
      final base64Image = base64Encode(imageBytes);

      final requestPayload = {
        'requests': [
          {
            'image': {'content': base64Image},
            'features': [
              {'type': 'OBJECT_LOCALIZATION', 'maxResults': 10}
            ],
          }
        ],
      };

      final response = await dio.post(
        'https://vision.googleapis.com/v1/images:annotate?key=$apiKey',
        options: Options(headers: {'Content-Type': 'application/json'}),
        data: requestPayload,
      );

      if (response.statusCode == 200) {
        print("Object Detection Results: ${response.data}");
      } else {
        print("Error: ${response.statusCode} - ${response.statusMessage}");
      }
    } catch (e) {
      print("Exception occurred: $e");
    }
  }
}
