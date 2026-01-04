import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

class DiseaseApiService {
  // 🔑 CHANGE THESE TWO VALUES
  static const String apiKey = "uDIMNnI7duFuzoXUjOWM";
  static const String modelId = "detecting-diseases/5"; 
  // example: detecting-diseases/5

  static Future<Map<String, dynamic>> detectDisease(File imageFile) async {
    try {
      final uri = Uri.parse(
        "https://detect.roboflow.com/$modelId?api_key=$apiKey",
      );

      final request = http.MultipartRequest("POST", uri);

      request.files.add(
        await http.MultipartFile.fromPath(
          "file",
          imageFile.path,
        ),
      );

      final response = await request.send();

      if (response.statusCode == 200) {
        final responseData = await response.stream.bytesToString();
        final decoded = json.decode(responseData);

        // If predictions available
        if (decoded["predictions"] != null &&
            decoded["predictions"].isNotEmpty) {
          final prediction = decoded["predictions"][0];

          return {
            "success": true,
            "disease": prediction["class"],
            "confidence":
                (prediction["confidence"] * 100).toStringAsFixed(2),
          };
        } else {
          return {
            "success": false,
            "message": "No disease detected"
          };
        }
      } else {
        return {
          "success": false,
          "message": "Server error: ${response.statusCode}"
        };
      }
    } catch (e) {
      return {
        "success": false,
        "message": "Error: $e"
      };
    }
  }
}
