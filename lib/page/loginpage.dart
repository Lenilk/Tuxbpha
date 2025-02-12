import 'package:flutter/material.dart';
import 'package:dryer_smart/page/homepage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  String username = "tuxbpha";
  String password = "tuxbpha2567";
  bool isRemember = false;
  @override
  void initState() {
    super.initState();
    // TODO create function for read data to restore username and password
  }

  @override
  void dispose() {
    usernameController.dispose();
    passwordController.dispose();
    super.dispose();
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
        backgroundColor: Colors.transparent,
        body: _page(),
      ),
    );
  }

  Widget _page() {
    return Padding(
      padding: const EdgeInsets.all(32.0),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _icon(),
            const SizedBox(height: 50),
            _inputField("Username", usernameController),
            const SizedBox(height: 20),
            _inputField("Password", passwordController, isPassword: true),
            const SizedBox(height: 10),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Checkbox(
                    checkColor: Colors.white,
                    activeColor: Colors.blueAccent,
                    value: isRemember,
                    onChanged: (value) {
                      if (value != null) {
                        setState(() {
                          isRemember = value;
                        });
                      }
                    }),
                const Padding(
                  padding: EdgeInsets.fromLTRB(0, 0, 0, 5),
                  child: Text(
                    "จดจำชื่อผู้ใช้และรหัสผ่าน",
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                )
              ],
            ),
            const SizedBox(height: 10),
            _loginBtn(),
          ],
        ),
      ),
    );
  }

  Widget _icon() {
    return ClipOval(
        child: SizedBox.fromSize(
      size: const Size.fromRadius(100), // Image radius
      child: Image.asset('icon/icon.jpg', fit: BoxFit.cover),
    ));
  }

  Widget _inputField(String hintText, TextEditingController controller,
      {isPassword = false}) {
    var border = OutlineInputBorder(
        borderRadius: BorderRadius.circular(18),
        borderSide: const BorderSide(color: Colors.white));

    return TextField(
      style: const TextStyle(color: Colors.white),
      controller: controller,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: const TextStyle(color: Colors.white),
        enabledBorder: border,
        focusedBorder: border,
      ),
      obscureText: isPassword,
    );
  }

  Widget _loginBtn() {
    return ElevatedButton(
      onPressed: () {
        debugPrint("Username : ${usernameController.text}");
        debugPrint("Password : ${passwordController.text}");
        if (usernameController.text == username &&
            passwordController.text == password) {
          if (isRemember) {
            debugPrint("Remember function");
            //  TODO: create function for write data to save username and password
          } else {
            passwordController.clear();
          }

          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => const MyHomePage(title: "tuxbpha")));
        } else {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text("Username or Password is incorrect")));
          passwordController.clear();
        }
      },
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.blue,
        backgroundColor: Colors.white,
        shape: const StadiumBorder(),
        padding: const EdgeInsets.symmetric(vertical: 16),
      ),
      child: const SizedBox(
          width: double.infinity,
          child: Text(
            "Log in ",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 20),
          )),
    );
  }
}
