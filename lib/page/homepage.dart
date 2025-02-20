import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:isolate';
import 'package:dryer_smart/components/icon_widget.dart';
import 'package:dryer_smart/dto/data.dart';
import 'package:dryer_smart/page/detail_dialog_widget.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:dryer_smart/components/comfirm_dialog_widget.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String? HumidVal = "Loading";
  String? TempVal = "Loading";
  String? state = "Loading";
  void fetchHumid() async {
    final res = await http.get(Uri.parse(
        'https://api.anto.io/channel/get/u6xuDlZyHCPHLDwRKhpOZA8SnZOjps0KMI51krgc/DHTTest/DHT21'));
    String responseBody = utf8.decode(res.bodyBytes);

    Data body = parseBody(responseBody);
    debugPrint(body.toString());
    setState(() {
      HumidVal = body.value;
    });
  }

  void fetchTemp() async {
    final res = await http.get(Uri.parse(
        'https://api.anto.io/channel/get/u6xuDlZyHCPHLDwRKhpOZA8SnZOjps0KMI51krgc/DHTTest/test'));
    String responseBody = utf8.decode(res.bodyBytes);

    Data body = parseBody(responseBody);
    debugPrint(body.toString());
    setState(() {
      TempVal = body.value;
    });
  }

  Data parseBody(String body) {
    final data = jsonDecode(body) as Map<String, dynamic>;
    return Data.fromJson(data);
  }

  void fetchState() async {
    final res = await http.get(Uri.parse(
        'https://api.anto.io/channel/get/u6xuDlZyHCPHLDwRKhpOZA8SnZOjps0KMI51krgc/DHTTest/State'));
    String responseBody = utf8.decode(res.bodyBytes);

    Data body = parseBody(responseBody);
    debugPrint(body.toString());
    setState(() {
      state = body.value;
    });
  }

  void setStateApi(String state) async {
    if (state != this.state) {
      debugPrint("Sent data");
      final res = await http.get(Uri.parse(
          'https://api.anto.io/channel/set/u6xuDlZyHCPHLDwRKhpOZA8SnZOjps0KMI51krgc/DHTTest/State/$state'));
      if (res.statusCode == 200) {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text("Sent data success")));
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text("fail to sent data")));
      }
    }
  }

  void allFetchData() {
    try {
      fetchHumid();
      fetchTemp();
      fetchState();
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  late Timer fetchingData =
      Timer.periodic(const Duration(milliseconds: 2000), (timer) {
    allFetchData();
  });
  @override
  void initState() {
    super.initState();
    allFetchData();

    fetchingData;
  }

  @override
  void dispose() {
    fetchingData.cancel();
    super.dispose();
  }

  Widget myText(String s) {
    return Text(s,
        style: const TextStyle(
            fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold));
  }

  void comfirmBtnFn(BuildContext context, String data) async {
    bool? isComfirmed = await ComfirmDialogWidget(context, data);
    if (isComfirmed != null) {
      if (isComfirmed) {
        setStateApi(data);
      }
    }
  }

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
          foregroundColor: Colors.white,
          backgroundColor: Colors.transparent,
          actions: [
            IconButton(
                tooltip: "คู่มือการใช้งาน",
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const DetailPage()));
                },
                icon: const Icon(Icons.help))
          ],
        ),
        backgroundColor: Colors.transparent,
        body: Padding(
          padding: const EdgeInsets.fromLTRB(50, 50, 50, 100),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Column(
                  children: [
                    icon_widget(80),
                    SizedBox(height: 12,),
                    myText("แสดงค่าอุณหภูมิ"),
                    myText("$TempVal"),
                    myText("แสดงค่าความชื้น"),
                    myText("$HumidVal"),
                    myText('ระดับอุณหภูมิ: $state'),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Center(child: myText("เลือกระดับอุณหภูมิ")),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.greenAccent),
                    onPressed: () {
                      comfirmBtnFn(context, "LOW");
                    },
                    child: myText("ต่ำ"),
                  ),
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.amber),
                      onPressed: () {
                        comfirmBtnFn(context, "MEDIUM");
                      },
                      child: myText("ปานกลาง")),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orangeAccent),
                    onPressed: () {
                      comfirmBtnFn(context, "HIGH");
                    },
                    child: myText("สูง"),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.redAccent),
                    onPressed: () {
                      comfirmBtnFn(context, "หยุดการทำงาน");
                    },
                    child: myText("หยุดการทำงาน")),
              ),
              const SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.fromLTRB(100, 0, 100, 0),
                        backgroundColor: Colors.blueAccent),
                    onPressed: () {
                      exit(0);
                    },
                    child: myText("ออก")),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
