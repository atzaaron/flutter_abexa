import 'package:flutter/material.dart';
import 'package:flutter_abexa/services/auth_service.dart';
import 'package:provider/provider.dart';
import '../assets/constants.dart' as Constants;
import 'package:email_validator/email_validator.dart';

class Login extends StatefulWidget {
  const Login({Key? key, this.title = "ABEXA APP"}) : super(key: key);

  final String title;

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  bool _passwordVisible = false;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  void initState() {
    _passwordVisible = false;
    super.initState();
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  _manageLogin(BuildContext context) async {
    final authService = Provider.of<AuthService>(context, listen: false);
    if (_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Login process, validators are ok")));
      await authService.signInWithEmailAndPassword(
          emailController.text, passwordController.text);
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Seems like validators are not ok")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Center(child: Text(widget.title)),
        automaticallyImplyLeading: false,
          backgroundColor: const Color(mainColor),
          leading: Builder(builder: (BuildContext context) {
            return IconButton(
              icon: const Icon(Icons.menu),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
              tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
            );
          })),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomLeft,
              colors: [
                Color(mainColor),
                Color(gradientBottomRightColor)
              ]),
        ),
        child: SingleChildScrollView(
          child: Container(
            margin: const EdgeInsets.only(top: 70),
            child: Stack(
              children: [
                Container(
                  height: MediaQuery.of(context).size.height / 2.2,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white,
                  ),
                  margin: const EdgeInsets.only(top: 60, left: 25, right: 25),
                  child: Column(
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          IconButton(
                            onPressed: () =>
                                {Navigator.popAndPushNamed(context, "/auth")},
                            icon: const Icon(Icons.arrow_back,
                                color: Color(Constants.mainColor), size: 40),
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          const SizedBox(height: 35),
                          SizedBox(
                            width: 300,
                            child: Form(
                              key: _formKey,
                              autovalidateMode: AutovalidateMode.always,
                              child: Column(
                                children: [
                                  TextFormField(
                                    controller: emailController,
                                    validator: (email) => EmailValidator
                                            .validate(email ?? "")
                                        ? null
                                        : "Veuillez rentrer un email valide.",
                                    decoration: const InputDecoration(
                                      hintText: "Adresse email",
                                      prefixIcon: Icon(
                                        Icons.email_outlined,
                                        color: Colors.grey,
                                        size: 30,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 15),
                                  TextFormField(
                                    controller: passwordController,
                                    // validator: ,
                                    obscureText: _passwordVisible,
                                    decoration: InputDecoration(
                                      hintText: "Mot de passe",
                                      prefixIcon: const Icon(
                                        Icons.password,
                                        color: Colors.grey,
                                        size: 30,
                                      ),
                                      suffixIcon: IconButton(
                                        icon: Icon(_passwordVisible
                                            ? Icons.visibility_off
                                            : Icons.visibility),
                                        onPressed: (() {
                                          setState(() {
                                            _passwordVisible =
                                                !_passwordVisible;
                                          });
                                        }),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 45),
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      primary:
                                          const Color(Constants.buttonColor),
                                      padding: const EdgeInsets.only(
                                          top: 20,
                                          bottom: 20,
                                          left: 55,
                                          right: 55),
                                    ),
                                    onPressed: () => _manageLogin(context),
                                    child: const Text("Se connecter"),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const Align(
                  alignment: Alignment.topCenter,
                  child: CircleAvatar(
                    radius: 60.0,
                    backgroundColor: Color(Constants.mainColor),
                    child: Image(
                      image: AssetImage('assets/images/profile.png'),
                      height: 100,
                      width: 100,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
