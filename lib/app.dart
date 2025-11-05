import 'package:flutter/material.dart';
import 'routes.dart';

class PickMyDishApp extends StatelessWidget {
  const PickMyDishApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PickMyDish',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
        fontFamily: 'Inter',
      ),
      initialRoute: AppRoutes.splash,
      routes: AppRoutes.routes,
      debugShowCheckedModeBanner: false,
    );
  }
}
