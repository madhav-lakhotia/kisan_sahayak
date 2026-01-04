import 'dart:convert';
import 'package:http/http.dart' as http;

class MandiApiService {
  static const String apiKey = "579b464db66ec23bdd00000197ff313a6399466f7ef549892e510281"; // <-- Yaha apna key daalna
  static const String resourceId = "9ef84268-d588-465a-a308-a864a43d0070"; // mostly same for mandi data
  
  static Future<List<Map<String, String>>> fetchMandiRates({
    required String state,
    required String district,
    required String commodity,
  }) async {
    final url = Uri.parse(
      "https://api.data.gov.in/resource/$resourceId"
      "?api-key=$apiKey"
      "&format=json"
      "&limit=100"
      "&filters[state]=$state"
      "&filters[district]=$district"
      "&filters[commodity]=$commodity"
      "&sort[date]=desc"
    );

    print("API Call ► $url");

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      if (!jsonData.containsKey("records")) return [];

      List<Map<String, String>> rows = [];
      for (var row in jsonData["records"]) {
        rows.add({
          "date": row["arrival_date"] ?? "",
          "min": row["min_price"] ?? "",
          "max": row["max_price"] ?? "",
          "modal": row["modal_price"] ?? "",
        });
      }
      return rows;
    } else {
      throw Exception("Error fetching data: ${response.statusCode}");
    }
  }
}
