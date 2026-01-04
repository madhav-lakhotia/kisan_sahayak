// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'weather_forecast_screen.dart';  // ⭐ NEW IMPORT

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  final _controller = TextEditingController(text: "Mumbai");

  Map<String, dynamic>? current;
  List? forecastDay;
  List? hourly;

  final String apiKey = "f0323c2281374ecaafa131415260101";

  Future<void> fetchWeather(String city) async {
    final url =
        "https://api.weatherapi.com/v1/forecast.json?key=$apiKey&q=$city&days=7&aqi=no&alerts=no";

    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      setState(() {
        current = jsonData["current"];
        forecastDay = jsonData["forecast"]["forecastday"];
        hourly = forecastDay![0]["hour"]; // today hours
      });
    }
  }

  @override
  void initState() {
    super.initState();
    fetchWeather("Mumbai");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.orange.shade100,

      // ⭐⭐ Forecast Button Added ⭐⭐
      appBar: AppBar(
        backgroundColor: Colors.orange.shade200,
        title: Text("Weather"),
        actions: [
          TextButton(
            onPressed: () {
              if (forecastDay != null) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => WeatherForecastScreen(forecastDay: forecastDay!),
                  ),
                );
              }
            },
            child: Text("Forecast", style: TextStyle(color: Colors.black, fontSize: 16)),
          ),
        ],
      ),
      // ⭐⭐ END ⭐⭐

      body: SafeArea(
        child: current == null
            ? const Center(child: CircularProgressIndicator())
            : Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 10),
                  
                  // 🔍 Search Box
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: TextField(
                      controller: _controller,
                      decoration: InputDecoration(
                        hintText: "Enter city...",
                        suffixIcon: IconButton(
                          icon: const Icon(Icons.search),
                          onPressed: () => fetchWeather(_controller.text),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // 🌡 City + Big Temperature
                  Text(
                    _controller.text,
                    style: const TextStyle(
                        fontSize: 35,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87),
                  ),
                  const SizedBox(height: 10),

                  Image.network(
                    "https:${current!["condition"]["icon"]}",
                    width: 120,
                  ),

                  Text(
                    "${current!["temp_c"]}°C",
                    style: const TextStyle(
                        fontSize: 65,
                        color: Colors.black,
                        fontWeight: FontWeight.w700),
                  ),
                  Text(
                    current!["condition"]["text"],
                    style: const TextStyle(
                      fontSize: 20,
                      color: Colors.black87,
                    ),
                  ),

                  const SizedBox(height: 10),

                  // ✨ Small detail row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _miniCard("💧 Humidity", "${current!["humidity"]}%"),
                      _miniCard("🎐 Wind", "${current!["wind_kph"]} km/h"),
                      _miniCard("🔥 Feels", "${current!["feelslike_c"]}°C"),
                    ],
                  ),

                  const SizedBox(height: 20),

                  // 🕒 Hourly Forecast
                  SizedBox(
                    height: 110,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: hourly!.length,
                      itemBuilder: (context, index) {
                        final h = hourly![index];
                        return _hourCard(
                          h["time"].substring(11),
                          "https:${h["condition"]["icon"]}",
                          "${h["temp_c"]}°",
                        );
                      },
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  Widget _miniCard(String title, String value) {
    return Column(
      children: [
        Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        Text(value),
      ],
    );
  }

  Widget _hourCard(String hour, String icon, String temp) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
          color: Colors.white.withOpacity(.8),
          borderRadius: BorderRadius.circular(12)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(hour, style: const TextStyle(fontSize: 16)),
          Image.network(icon, width: 40),
          Text(temp)
        ],
      ),
    );
  }
}
