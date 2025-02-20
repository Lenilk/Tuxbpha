import 'package:flutter/material.dart';
import 'package:dryer_smart/page/loginpage.dart';
void main() {
  runApp(const MyApp());
}
class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
        textTheme: const TextTheme(
          bodyLarge: TextStyle(fontSize: 22,fontWeight: FontWeight.bold, color: Colors.white), // สำหรับข้อความหลัก
        ),
      ),
      home:  const LoginPage(),
    );
  }
}
