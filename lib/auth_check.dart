// ignore_for_file: use_key_in_widget_constructors

import 'home_screen.dart';
import 'login_screen.dart';
import 'auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


class AuthCheck extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, auth, child) {
        return auth.isLoggedIn ? HomeScreen() : LoginScreen();
      },
    );
  }
}
