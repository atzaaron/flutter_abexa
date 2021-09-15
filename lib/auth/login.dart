import 'package:flutter/material.dart';
import '../assets/constants.dart' as Constants;

class Login extends StatelessWidget {
  const Login({Key? key, this.title = "ABEXA APP"}) : super(key: key);

  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: const Color(Constants.mainColor),
          title: Text(title)),
    );
  }
}
