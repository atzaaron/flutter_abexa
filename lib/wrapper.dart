import 'package:flutter/material.dart';
import 'package:flutter_abexa/main.dart';
import 'package:flutter_abexa/models/user.dart';
import 'package:flutter_abexa/services/auth_service.dart';
import 'package:provider/provider.dart';
import 'auth/auth.dart';

class Wrapper extends StatelessWidget {
  const Wrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);
    return StreamBuilder<UserModel?>(
        stream: authService.user,
        builder: (_, AsyncSnapshot<UserModel?> snapshot) {
          if (snapshot.connectionState == ConnectionState.active) {
            final UserModel? user = snapshot.data;
            return user == null ? const Auth() : const MyHomePage();
          } else {
            return const Scaffold(
                body: Center(
              child: CircularProgressIndicator(),
            ));
          }
        });
  }
}
