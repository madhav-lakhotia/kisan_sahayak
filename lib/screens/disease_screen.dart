import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart'; // kIsWeb
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

class DiseaseScreen extends StatefulWidget {
  const DiseaseScreen({Key? key}) : super(key: key);

  @override
  State<DiseaseScreen> createState() => _DiseaseScreenState();
}

class _DiseaseScreenState extends State<DiseaseScreen> {
  Uint8List? webImageBytes; // ✅ for web
  XFile? pickedImage;

  final ImagePicker _picker = ImagePicker();

  bool isLoading = false;
  String diseaseName = "---";
  String confidence = "---";

  // 🔑 ROBoflow CONFIG
  static const String apiKey = "uDIMNnI7duFuzoXUjOWM";
  static const String modelId = "detecting-diseases/5";

  // 📁 Gallery
  Future<void> pickFromGallery() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      final bytes = await image.readAsBytes();
      setState(() {
        pickedImage = image;
        webImageBytes = bytes;
        diseaseName = "---";
        confidence = "---";
      });
    }
  }

  // 📷 Camera
  Future<void> pickFromCamera() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.camera);
    if (image != null) {
      final bytes = await image.readAsBytes();
      setState(() {
        pickedImage = image;
        webImageBytes = bytes;
        diseaseName = "---";
        confidence = "---";
      });
    }
  }

  // 🤖 AI CALL
  Future<void> detectDisease() async {
    if (pickedImage == null) return;

    setState(() => isLoading = true);

    final uri = Uri.parse(
      "https://detect.roboflow.com/$modelId?api_key=$apiKey",
    );

    final request = http.MultipartRequest("POST", uri);
    request.files.add(
      http.MultipartFile.fromBytes(
        "file",
        webImageBytes!,
        filename: "image.jpg",
      ),
    );

    final response = await request.send();
    final responseData = await response.stream.bytesToString();
    final jsonResult = json.decode(responseData);

    setState(() {
      isLoading = false;

      if (jsonResult["predictions"] != null &&
          jsonResult["predictions"].isNotEmpty) {
        final prediction = jsonResult["predictions"][0];
        diseaseName = prediction["class"];
        confidence =
            "${(prediction["confidence"] * 100).toStringAsFixed(2)} %";
      } else {
        diseaseName = "No disease detected";
        confidence = "0%";
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F8F3),
      appBar: AppBar(
        title: const Text("Crop Disease Detection"),
        centerTitle: true,
        backgroundColor: Colors.green.shade700,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [

            // 🖼 IMAGE PREVIEW
            Container(
              height: 220,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.green.shade300, width: 2),
              ),
              child: webImageBytes == null
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(Icons.image, size: 80, color: Colors.grey),
                        SizedBox(height: 10),
                        Text("No image selected"),
                      ],
                    )
                  : ClipRRect(
                      borderRadius: BorderRadius.circular(14),
                      child: Image.memory(
                        webImageBytes!,
                        fit: BoxFit.cover,
                        width: double.infinity,
                      ),
                    ),
            ),

            const SizedBox(height: 25),

            // 📤 BUTTONS
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: pickFromGallery,
                    icon: const Icon(Icons.upload),
                    label: const Text("Upload Image"),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: pickFromCamera,
                    icon: const Icon(Icons.camera_alt),
                    label: const Text("Camera"),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 30),

            // 🤖 DETECT
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: pickedImage == null || isLoading
                    ? null
                    : detectDisease,
                child: isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text(
                        "Detect Disease",
                        style: TextStyle(fontSize: 18),
                      ),
              ),
            ),

            const SizedBox(height: 30),

            // 📊 RESULT
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Result",
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text("Disease: $diseaseName"),
                  Text("Confidence: $confidence"),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
