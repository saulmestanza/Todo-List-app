import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'provider/login_provider.dart';
import 'screens/home.dart';
import 'screens/login.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => LoginProvider(),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Consumer<LoginProvider>(
        builder: (context, auth, _) {
          return auth.isLoggedIn ? HomeScreen() : LoginScreen();
        },
      ),
    );
  }
}
