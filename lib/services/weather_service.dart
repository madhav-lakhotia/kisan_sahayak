import 'dart:convert';
import 'package:http/http.dart' as http;

class WeatherService {
  static const String apiKey = "f0323c2281374ecaafa131415260101";

  // 📌 current weather
  static Future<Map<String, dynamic>?> fetchWeather(String city) async {
    final url =
        "https://api.weatherapi.com/v1/current.json?key=$apiKey&q=$city&aqi=no";

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    }
    return null;
  }

  // 📌 7-day forecast
  static Future<List<dynamic>?> fetchForecast(String city) async {
    final url =
        "https://api.weatherapi.com/v1/forecast.json?key=$apiKey&q=$city&days=7&aqi=no&alerts=no";

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      return json["forecast"]["forecastday"];
    }
    return null;
  }
}
