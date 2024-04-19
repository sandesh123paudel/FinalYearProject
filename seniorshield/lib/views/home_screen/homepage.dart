import 'package:flutter/material.dart';
import 'package:seniorshield/constants/colors.dart';
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
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                ResponsiveText("text")
              ],
            ),
          ),
        ),
      ),
    );
  }
}
