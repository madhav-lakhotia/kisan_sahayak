import 'package:flutter/material.dart';
import 'theme.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(const KisanSahayakApp());
}

class KisanSahayakApp extends StatelessWidget {
  const KisanSahayakApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "किसान सहायक",
      theme: appTheme,     // ← yeh theme.dart ko use karega
      home: const HomeScreen(), // ← yeh home screen UI open karega
    );
  }
}
