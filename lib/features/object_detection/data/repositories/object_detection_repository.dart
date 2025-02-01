import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:vision_projecet/features/object_detection/domain/entities/detection.dart';

class ObjectDetectionRepository {
  final Dio dio = Dio();

  final String apiKey = "AIzaSyBDL8zapbOUuCqnTgUvpCysGT59NthTU3w";

    Future<List<DetectionResult>> detectObjectsFromImage(File imageFile) async {
    try {

      final imageBytes = await imageFile.readAsBytes();
      final String base64Image = base64Encode(imageBytes);

 
      final Map<String, dynamic> requestPayload = {
        "requests": [
          {
            "image": {"content": base64Image},
            "features": [
              {"type": "LABEL_DETECTION", "maxResults": 10},
              {"type": "OBJECT_LOCALIZATION", "maxResults": 5} 
            ]
          }
        ]
      };

      print("🔄 Sending request to Vision API...");
      print("📤 Payload: ${jsonEncode(requestPayload).substring(0, 500)}..."); // Log first 500 chars

      final response = await dio.post(
        'https://vision.googleapis.com/v1/images:annotate?key=$apiKey',
        data: jsonEncode(requestPayload),
        options: Options(headers: {'Content-Type': 'application/json'}),
      );

      if (response.statusCode == 200) {
        print("✅ API Response Received!");
        final jsonResponse = response.data;
        print("📥 Response: $jsonResponse");

        final List? annotations = jsonResponse['responses'][0]['localizedObjectAnnotations'];
        if (annotations != null) {
          return annotations.map((obj) {
            return DetectionResult(label: obj['name'] ?? 'Unknown');
          }).toList();
        }
        return [];
      } else {
        print("❌ API Error: ${response.statusCode} - ${response.statusMessage}");
     print("❌ Full API Error: ${response.data}");
        return [];
      }
    } catch (e) {
      print("🚨 Exception occurred while detecting objects: $e");
      return [];
    }
  }
}

