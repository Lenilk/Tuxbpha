import 'package:flutter/material.dart';


class ComfirmDialogWidget extends StatelessWidget {
  final String data;
  const ComfirmDialogWidget({super.key,required this.data});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
          title: Text('ตั้งค่าอุณหภูมิ เป็น $data หรือไม่'),
          actions: <Widget>[
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: const Text('ยกเลิก '),
              onPressed: () {
                Navigator.of(context).pop(false);
              },
            ),
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: const Text('ยืนยัน'),
              onPressed: () {
                Navigator.of(context).pop(true);
              },
            ),
          ],
        );
  }
}

