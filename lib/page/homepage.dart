import 'dart:async';
import 'dart:convert';
import 'dart:io';

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
  int _counter = 0;
  String? HumidVal = "Loading";
  String? TempVal = "Loading";
  String? state = "Loading";

  Future<String?> fetchHumid() async {
    final res = await http.get(Uri.parse(
        'https://api.anto.io/channel/get/u6xuDlZyHCPHLDwRKhpOZA8SnZOjps0KMI51krgc/DHTTest/DHT21'));
    final body = jsonDecode(res.body) as Map<String, dynamic>;
    debugPrint(body.toString());
    setState(() {
      HumidVal = body['value'];
    });
    return body['value'];
  }

  void fetchTemp() async {
    debugPrint(fetchingData.isActive.toString());
    final res = await http.get(Uri.parse(
        'https://api.anto.io/channel/get/u6xuDlZyHCPHLDwRKhpOZA8SnZOjps0KMI51krgc/DHTTest/test'));
    final body = jsonDecode(res.body) as Map<String, dynamic>;
    debugPrint(body.toString());
    setState(() {
      TempVal = body['value'];
    });
  }

  void fetchState() async {
    final res = await http.get(Uri.parse(
        'https://api.anto.io/channel/get/u6xuDlZyHCPHLDwRKhpOZA8SnZOjps0KMI51krgc/DHTTest/State'));
    final body = jsonDecode(res.body) as Map<String, dynamic>;
    debugPrint(body.toString());
    setState(() {
      state = body['value'];
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
        ),
        backgroundColor: Colors.transparent,
        body: Padding(
          padding: const EdgeInsets.fromLTRB(50, 150, 50, 150),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Column(
                  children: [
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
                    child: myText("Low"),
                  ),
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.amber),
                      onPressed: () {
                        comfirmBtnFn(context, "MEDIUM");
                      },
                      child: myText("Medium")),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orangeAccent),
                    onPressed: () {
                      comfirmBtnFn(context, "HIGH");
                    },
                    child: myText("High"),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.redAccent),
                    onPressed: () {
                      comfirmBtnFn(context, "DOWN");
                    },
                    child: myText("SHUTDOWN")),
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
                    child: myText("Exit")),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
