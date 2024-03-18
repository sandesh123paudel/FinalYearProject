import 'package:flutter/material.dart';
import 'package:seniorshield/widgets/responsive_text.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            ResponsiveText("text")
          ],
        ),
      ),
    );
  }
}
