import 'package:flutter/material.dart';
import 'package:mini_e_commerce/provider/prodctprovider.dart';
import 'package:mini_e_commerce/ui/SplashScreen.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ProductProvider())],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Mini E-Commerce',
      theme: ThemeData(primarySwatch: Colors.deepOrange),
      home: const SplashScreen(),
    );
  }
}
