import 'package:flutter/material.dart';
import 'package:seniorshield/constants/util/util.dart';
import 'package:seniorshield/widgets/responsive_text.dart';

import '../../constants/colors.dart';

class PillRemainderScreen extends StatelessWidget {
  const PillRemainderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(height: kVerticalMargin),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ResponsiveText("Your Medicines",fontSize: 20,textColor: kPrimaryColor,fontWeight: FontWeight.bold,),
            ),
          ],
        ),
      ),
    );
  }
}
