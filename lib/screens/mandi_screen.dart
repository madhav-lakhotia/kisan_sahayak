import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../data/mandi_static_data.dart';

class MandiScreen extends StatefulWidget {
  const MandiScreen({Key? key}) : super(key: key);

  @override
  _MandiScreenState createState() => _MandiScreenState();
}

class _MandiScreenState extends State<MandiScreen> {
  String selectedState = "Rajasthan";
  String selectedCity = "Jaipur";
  String selectedCrop = "Wheat";

  List<Map<String, dynamic>> mandiRates = [];

  @override
  void initState() {
    super.initState();
    updateTable();
  }

  void updateTable() {
    final history = generatePriceHistory(
      state: selectedState,
      city: selectedCity,
      crop: selectedCrop,
      days: 5,
    );

    setState(() {
      mandiRates = history;
    });
  }

  bool get priceIncreased {
    if (mandiRates.length < 2) return false;
    return mandiRates.last["avg"] > mandiRates[mandiRates.length - 2]["avg"];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFDF6E3),
      appBar: AppBar(
        title: const Text("मंडी भाव", style: TextStyle(fontSize: 24)),
        backgroundColor: Colors.orange.shade300,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            textLabel("फसल चुनें"),
            dropDown(allCrops, selectedCrop, (v) {
              selectedCrop = v;
              updateTable();
            }),

            const SizedBox(height: 20),

            textLabel("राज्य चुनें"),
            dropDown(stateCityMap.keys.toList(), selectedState, (v) {
              selectedState = v;
              selectedCity = stateCityMap[v]!.first;
              updateTable();
            }),

            const SizedBox(height: 20),

            textLabel("जिला / शहर चुनें"),
            dropDown(stateCityMap[selectedState]!, selectedCity, (v) {
              selectedCity = v;
              updateTable();
            }),

            const SizedBox(height: 25),

            Row(
              children: [
                Icon(
                  priceIncreased ? Icons.arrow_upward : Icons.arrow_downward,
                  color: priceIncreased ? Colors.green : Colors.red,
                ),
                const SizedBox(width: 8),
                Text(
                  priceIncreased ? "भाव बढ़ा है" : "भाव घटा है",
                  style: TextStyle(
                    color: priceIncreased ? Colors.green : Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 15),

            priceTrendGraph(),

            const SizedBox(height: 25),

            const Text(
              "पिछले 5 दिन के मंडी भाव",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 10),

            tableWidget(),
          ],
        ),
      ),
    );
  }

  // ================= GRAPH =================

  Widget priceTrendGraph() {
    if (mandiRates.isEmpty) {
      return const SizedBox(
        height: 200,
        child: Center(child: Text("No data available")),
      );
    }

    final minY =
        mandiRates.map((e) => e["avg"] as int).reduce((a, b) => a < b ? a : b) -
            150;
    final maxY =
        mandiRates.map((e) => e["avg"] as int).reduce((a, b) => a > b ? a : b) +
            150;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: SizedBox(
        height: 260,
        child: LineChart(
          LineChartData(
            minY: minY.toDouble(),
            maxY: maxY.toDouble(),
            gridData: FlGridData(
              show: true,
              horizontalInterval: 100,
              getDrawingHorizontalLine: (value) => FlLine(
                color: Colors.grey.withOpacity(0.2),
                strokeWidth: 1,
              ),
            ),
            titlesData: FlTitlesData(
              leftTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  reservedSize: 45,
                  interval: 200,
                  getTitlesWidget: (value, meta) {
                    return Text("₹${value.toInt()}",
                        style: const TextStyle(fontSize: 10));
                  },
                ),
              ),
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  interval: 1,
                  getTitlesWidget: (value, meta) {
                    int index = value.toInt();
                    if (index < 0 || index >= mandiRates.length) {
                      return const SizedBox();
                    }
                    return Padding(
                      padding: const EdgeInsets.only(top: 6),
                      child: Text(
                        mandiRates[index]["date"].substring(5),
                        style: const TextStyle(fontSize: 10),
                      ),
                    );
                  },
                ),
              ),
            ),
            borderData: FlBorderData(show: false),
            lineBarsData: [
              LineChartBarData(
                spots: mandiRates.asMap().entries.map((e) {
                  return FlSpot(
                    e.key.toDouble(),
                    (e.value["avg"] as int).toDouble(),
                  );
                }).toList(),
                isCurved: true,
                curveSmoothness: 0.4,
                barWidth: 4,
                gradient: LinearGradient(
                  colors: priceIncreased
                      ? [Colors.green.shade700, Colors.green.shade300]
                      : [Colors.red.shade700, Colors.red.shade300],
                ),
                dotData: FlDotData(
                  show: true,
                  getDotPainter: (spot, percent, barData, index) {
                    return FlDotCirclePainter(
                      radius: 5,
                      color: Colors.white,
                      strokeWidth: 3,
                      strokeColor:
                          priceIncreased ? Colors.green : Colors.red,
                    );
                  },
                ),
                belowBarData: BarAreaData(
                  show: true,
                  gradient: LinearGradient(
                    colors: priceIncreased
                        ? [
                            Colors.green.withOpacity(0.3),
                            Colors.green.withOpacity(0.05)
                          ]
                        : [
                            Colors.red.withOpacity(0.3),
                            Colors.red.withOpacity(0.05)
                          ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
              ),
            ],
            lineTouchData: LineTouchData(
              enabled: true,
              touchTooltipData: LineTouchTooltipData(
                tooltipBgColor: Colors.black87,
                getTooltipItems: (touchedSpots) {
                  return touchedSpots.map((spot) {
                    final data = mandiRates[spot.spotIndex];
                    return LineTooltipItem(
                      "₹${data["avg"]}\n${data["date"]}",
                      const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    );
                  }).toList();
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ================= UI HELPERS =================

  Widget textLabel(String t) {
    return Text(
      t,
      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
    );
  }

  Widget dropDown(List<String> items, String selected, Function(String) onChange) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      decoration: BoxDecoration(
        color: Colors.orange.shade100,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.orange, width: 2),
      ),
      child: DropdownButton<String>(
        value: selected,
        isExpanded: true,
        underline: const SizedBox(),
        items:
            items.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
        onChanged: (v) => onChange(v!),
      ),
    );
  }

  Widget tableWidget() {
    return Container(
      margin: const EdgeInsets.only(top: 15),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.orange, width: 2),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Table(
        children: [
          headerRow(),
          ...mandiRates.map(
            (e) => TableRow(children: [
              cell(e["date"]),
              cell("₹${e["min"]}"),
              cell("₹${e["max"]}"),
              cell("₹${e["avg"]}"),
            ]),
          ),
        ],
      ),
    );
  }

  TableRow headerRow() {
    return TableRow(
      decoration: BoxDecoration(color: Colors.orange.shade200),
      children: [
        cell("तारीख", bold: true),
        cell("न्यूनतम", bold: true),
        cell("अधिकतम", bold: true),
        cell("औसत", bold: true),
      ],
    );
  }

  Widget cell(String t, {bool bold = false}) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Text(
        t,
        style: TextStyle(
          fontSize: 16,
          fontWeight: bold ? FontWeight.bold : FontWeight.normal,
        ),
      ),
    );
  }
}
