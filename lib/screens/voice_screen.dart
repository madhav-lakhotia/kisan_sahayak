import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:permission_handler/permission_handler.dart';

import 'mandi_screen.dart';
import 'weather_screen.dart';
import 'disease_screen.dart';
import 'diary_screen.dart';

class VoiceScreen extends StatefulWidget {
  const VoiceScreen({Key? key}) : super(key: key);

  @override
  State<VoiceScreen> createState() => _VoiceScreenState();
}

class _VoiceScreenState extends State<VoiceScreen> {
  late stt.SpeechToText speech;
  String recognizedText = "";
  bool isListening = false;
  bool commandExecuted = false;

  // ================== INIT ==================
  @override
  void initState() {
    super.initState();
    speech = stt.SpeechToText();
    checkMicPermission(); // 🔥 permission popup yahin se aayega
  }

  // ================== MICROPHONE PERMISSION ==================
  Future<void> checkMicPermission() async {
    var status = await Permission.microphone.status;

    if (status.isDenied) {
      await Permission.microphone.request(); // 🔥 system Allow / Deny popup
    }

    if (status.isPermanentlyDenied) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "Microphone permission permanently denied. Enable it from Settings.",
          ),
        ),
      );
      await openAppSettings();
    }
  }

  // ================== START LISTEN ==================
  void startListening() async {
    recognizedText = "";
    commandExecuted = false;

    bool available = await speech.initialize(
      onStatus: (status) => debugPrint("STATUS: $status"),
      onError: (error) => debugPrint("ERROR: $error"),
    );

    if (available) {
      setState(() => isListening = true);

      speech.listen(onResult: (result) {
        setState(() => recognizedText = result.recognizedWords);
        detectCommand(recognizedText.toLowerCase());
      });
    }
  }

  void stopListening() {
    speech.stop();
    setState(() => isListening = false);
  }

  // ================== HELPER ==================
  bool containsAny(String text, List<String> words) {
    for (final w in words) {
      if (text.contains(w)) return true;
    }
    return false;
  }

  // ================== COMMAND DETECTION ==================
  void detectCommand(String text) {
    if (text.isEmpty || commandExecuted) return;

    speech.stop();
    setState(() => isListening = false);
    commandExecuted = true;

    // WEATHER
    if (containsAny(text, [
      "weather", "mausam", "मौसम",
      "havaman", "हवामान",
      "வானிலை", "క్లైమేట్",
      "ಹವಾಮಾನ", "കാലാവസ്ഥ",
      "আবহাওয়া", "હવામાન"
    ])) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const WeatherScreen()),
      );
      return;
    }

    // MANDI
    if (containsAny(text, [
      "mandi", "market", "bhav", "भाव",
      "बाजार", "ಮಾರುಕಟ್ಟೆ",
      "சந்தை", "మార్కెట్",
      "બજાર", "ਬਾਜ਼ਾਰ"
    ])) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const MandiScreen()),
      );
      return;
    }

    // DISEASE
    if (containsAny(text, [
      "disease", "crop disease", "बीमारी",
      "रोग", "फसल रोग",
      "ರೋಗ", "நோய்",
      "వ్యాధి", "બીમારી"
    ])) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const DiseaseScreen()),
      );
      return;
    }

    // DIARY
    if (containsAny(text, [
      "diary", "note", "डायरी",
      "नोट्स", "డైరీ",
      "ದಿನಚರಿ", "குறிப்பு"
    ])) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const DiaryScreen()),
      );
      return;
    }

    // UNKNOWN
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Samajh nahi aaya. Bolo: Weather, Mandi, Disease, Diary"),
      ),
    );
  }

  // ================== UI ==================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFE6C7),
      appBar: AppBar(
        backgroundColor: const Color(0xFFFFC56D),
        title: const Text("Ask by Voice"),
        centerTitle: true,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            isListening ? Icons.mic : Icons.mic_none,
            size: 100,
            color: Colors.deepOrange,
          ),
          const SizedBox(height: 20),
          Text(
            recognizedText.isEmpty ? "Tap mic & speak..." : recognizedText,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 40),
          ElevatedButton(
            onPressed: isListening ? stopListening : startListening,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.orange,
              padding: const EdgeInsets.symmetric(
                horizontal: 40,
                vertical: 15,
              ),
            ),
            child: Text(
              isListening ? "Stop 🎙" : "Start Listening 🎤",
              style: const TextStyle(fontSize: 18),
            ),
          ),
        ],
      ),
    );
  }
}
