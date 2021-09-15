import 'package:flutter/material.dart';
import 'package:flutter_abexa/auth/auth.dart';
import 'package:flutter/services.dart';
import 'package:flutter_abexa/auth/login.dart';
import 'package:flutter_abexa/auth/register.dart';
import '../assets/constants.dart' as Constants;

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  // SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);

  runApp(MaterialApp(
      title: 'ABEXA APP',
      initialRoute: '/auth',
      debugShowCheckedModeBanner: false,
      routes: {
        '/': (context) => const MyHomePage(),
        '/auth': (context) =>
            Auth(title: "S'authentifier - " + Constants.appName),
        '/register': (context) =>
            const Register(title: "S'enregistrer -" + Constants.appName),
        '/login': (context) =>
            const Login(title: "Se connecter - " + Constants.appName),
      }));
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Hi"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const <Widget>[
            Text(
              'You have pushed the button this many times:',
            ),
          ],
        ),
      ),
    );
  }
}
