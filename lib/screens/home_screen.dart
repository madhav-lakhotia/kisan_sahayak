import 'package:flutter/material.dart';

// existing screens
import 'mandi_screen.dart';
import 'weather_screen.dart';
import 'voice_screen.dart';
import 'schemes_screen.dart';
import 'diary_screen.dart';

// NEW screen (disease)
import 'disease_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF2D8),
      appBar: AppBar(
        backgroundColor: const Color(0xFFFFC56D),
        title: const Text(
          "Kisan Sahayak",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [

            // 🎤 VOICE CARD (existing)
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const VoiceScreen()),
                );
              },
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFD28A),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.orange, width: 2),
                ),
                child: Column(
                  children: const [
                    Icon(Icons.mic, size: 60),
                    SizedBox(height: 10),
                    Text(
                      "Ask by Voice",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 5),
                    Text(
                      "Say: Market price, Weather, Disease",
                      textAlign: TextAlign.center,
                    )
                  ],
                ),
              ),
            ),

            const SizedBox(height: 25),

            // GRID OPTIONS
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 3,
              crossAxisSpacing: 15,
              mainAxisSpacing: 15,
              children: [

                _menuCard(
                  icon: Icons.currency_rupee,
                  title: "Market Prices",
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const MandiScreen()),
                    );
                  },
                ),

                _menuCard(
                  icon: Icons.cloud,
                  title: "Weather",
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const WeatherScreen()),
                    );
                  },
                ),

                // ⭐⭐ NEW: DISEASE DETECTION ⭐⭐
                _menuCard(
                  icon: Icons.camera_alt,
                  title: "Disease Detection",
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const DiseaseScreen()),
                    );
                  },
                ),

                _menuCard(
                  icon: Icons.book,
                  title: "Gov. Schemes",
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const SchemesScreen()),
                    );
                  },
                ),

                _menuCard(
                  icon: Icons.agriculture,
                  title: "Crop Advice",
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Crop advice feature coming soon"),
                      ),
                    );
                  },
                ),

                _menuCard(
                  icon: Icons.edit,
                  title: "Diary",
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const DiaryScreen()),
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // 🔹 reusable menu card
  Widget _menuCard({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFFFFE1A1),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: Colors.orange, width: 2),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 36),
            const SizedBox(height: 10),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
