import 'package:flutter/material.dart';

class DetailPage extends StatelessWidget {
  const DetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: const BoxDecoration(
            gradient: LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: [
            Colors.blue,
            Colors.red,
          ],
        )),
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            foregroundColor: Colors.white,
            title: Text("คู่มือการใช้งาน",style: Theme.of(context).textTheme.bodyLarge,),
            centerTitle: true,
          ),
          backgroundColor: Colors.transparent,
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14),
            child: ListView(
              children: [
                const SizedBox(height: 12,),
                Text(
                  "อุณหภูมิต่ำ สำหรับผ้าบาง อุณหภูมิ 40-45 องศา ระยะเวลาการอบ 15 นาที เช่น ผ้าอ้อม เสื้อเด็ก ผ้าม่านแบบบาง ผ้าชนิดชีฟอง",
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                const SizedBox(
                  height: 12,
                ),
                Text(
                    "อุณหภูมิปานกลาง สำหรับผ้าหนาปานกลาง อุณหภูมิ 45-60 องศา ระยะเวลาการอบ 20 นาที เช่น เสื้อเชิ้ต เสื้อยืด กางเกงสแล็ก",
                    style: Theme.of(context).textTheme.bodyLarge),
                const SizedBox(
                  height: 12,
                ),
                Text(
                    "อุณหภูมิสูง สำหรับผ้าหนา อุณหภูมิ 60-70 องศา ระยะเวลาการอบ 40 นาที เช่น ผ้านวม กางเกงยีนส์",
                    style: Theme.of(context).textTheme.bodyLarge)
              ],
            ),
          ),
        ));
  }
}
