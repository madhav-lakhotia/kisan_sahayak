import 'dart:math';

const List<String> allCrops = [
  "Wheat",
  "Rice",
  "Maize",
  "Barley",
  "Jowar",
  "Bajra",
  "Ragi",
  "Soybean",
  "Mustard",
  "Groundnut",
  "Sunflower",
  "Gram",
  "Tur",
  "Moong",
  "Urad",
];

const Map<String, List<String>> stateCityMap = {
  "Rajasthan": ["Jaipur","Kota","Ajmer","Udaipur","Bikaner","Jodhpur","Alwar","Sikar","Bhilwara","Chittorgarh"],
  "Maharashtra": ["Pune","Nagpur","Nashik","Aurangabad","Solapur","Amravati","Kolhapur","Satara","Jalgaon","Latur"],
  "Punjab": ["Ludhiana","Amritsar","Jalandhar","Patiala","Bathinda","Moga","Hoshiarpur","Firozpur","Sangrur","Kapurthala"],
  "Madhya Pradesh": ["Indore","Bhopal","Ujjain","Gwalior","Jabalpur","Sagar","Ratlam","Dewas","Rewa","Chhindwara"],
};

int baseCropPrice(String crop) {
  switch (crop) {
    case "Wheat": return 2300;
    case "Rice": return 2500;
    case "Maize": return 2100;
    case "Soybean": return 4500;
    case "Mustard": return 5300;
    case "Groundnut": return 5200;
    case "Gram": return 4800;
    case "Tur": return 6200;
    case "Moong": return 7000;
    case "Urad": return 6800;
    default: return 2600;
  }
}

Map<String, int> generatePrice({
  required String state,
  required String city,
  required String crop,
}) {
  final base = baseCropPrice(crop);
  final stateFactor = state.hashCode % 300;
  final cityFactor = city.hashCode % 200;
  final random = Random(state.hashCode + city.hashCode + crop.hashCode);
  final variation = random.nextInt(150) - 75;

  final avg = base + stateFactor + cityFactor + variation;

  return {
    "min": avg - 120,
    "max": avg + 120,
    "avg": avg,
  };
}

List<Map<String, dynamic>> generatePriceHistory({
  required String state,
  required String city,
  required String crop,
  int days = 5,
}) {
  final List<Map<String, dynamic>> history = [];

  int baseAvg = generatePrice(
    state: state,
    city: city,
    crop: crop,
  )["avg"]!;

  final random = Random(state.hashCode + city.hashCode + crop.hashCode);

  for (int i = days - 1; i >= 0; i--) {
    final date = DateTime.now().subtract(Duration(days: i));

    // 🔥 controlled daily fluctuation
    final fluctuation = random.nextInt(100) - 50; // -50 to +50
    baseAvg += fluctuation;

    history.add({
      "date": date.toString().substring(0, 10),
      "avg": baseAvg,
      "min": baseAvg - 120,
      "max": baseAvg + 120,
    });
  }

  return history;
}
