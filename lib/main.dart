import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'utils/app_routers.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: false,
        appBarTheme: const AppBarTheme(
          backgroundColor: Color.fromARGB(229, 255, 167, 36),
        ),
      ),
      getPages: AppRoutes.pages,
    );
  }
}
