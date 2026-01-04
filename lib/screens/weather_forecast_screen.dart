import 'package:flutter/material.dart';

class WeatherForecastScreen extends StatelessWidget {
  final List forecastDay;

  const WeatherForecastScreen({super.key, required this.forecastDay});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.orange.shade100,
      appBar: AppBar(
        backgroundColor: Colors.orange.shade200,
        title: const Text("7-Day Forecast"),
      ),
      body: ListView.builder(
        itemCount: forecastDay.length,
        itemBuilder: (context, index) {
          final d = forecastDay[index];
          return ListTile(
            leading: Image.network("https:${d["day"]["condition"]["icon"]}", width: 40),
            title: Text(d["date"], style: TextStyle(fontSize: 18)),
            subtitle: Text(d["day"]["condition"]["text"]),
            trailing: Text(
              "${d["day"]["mintemp_c"]}°C  /  ${d["day"]["maxtemp_c"]}°C",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
          );
        },
      ),
    );
  }
}
