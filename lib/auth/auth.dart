import 'package:flutter/material.dart';
import '../assets/constants.dart' as Constants;

class Auth extends StatelessWidget {
  Auth({Key? key, this.title = "ABEXA APP"}) : super(key: key);

  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text(title)),
        automaticallyImplyLeading: false,
        backgroundColor: const Color(Constants.mainColor),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomLeft,
              colors: [
                Color(Constants.mainColor),
                Color(Constants.gradientBottomRightColor)
              ]),
        ),
        child: Container(
          margin: const EdgeInsets.only(top: 70),
          child: Stack(
            children: [
              Container(
                height: MediaQuery.of(context).size.height / 2,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.white,
                ),
                margin: const EdgeInsets.only(top: 60, left: 30, right: 30),
                child: Column(
                  children: [
                    Column(
                      children: [
                        const SizedBox(height: 100),
                        const Text("Première connexion ?"),
                        const SizedBox(height: 20),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            primary: const Color(Constants.buttonColor),
                            padding: const EdgeInsets.only(
                                top: 20, bottom: 20, left: 55, right: 55),
                          ),
                          onPressed: () =>
                              {Navigator.pushNamed(context, '/register')},
                          child: const Text("S'enregistrer"),
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        const SizedBox(height: 50),
                        const Text("Déjà membre ?"),
                        const SizedBox(height: 20),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            primary: const Color(Constants.buttonColor),
                            padding: const EdgeInsets.only(
                                top: 20, bottom: 20, left: 55, right: 55),
                          ),
                          onPressed: () =>
                              {Navigator.pushNamed(context, '/login')},
                          child: const Text("Se connecter"),
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
    );
  }
}
