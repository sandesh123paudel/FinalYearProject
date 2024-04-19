import 'dart:math';

import 'package:flutter/material.dart';
import 'package:seniorshield/constants/colors.dart';
import 'package:seniorshield/constants/util/util.dart';
import 'package:seniorshield/widgets/customBMI_textField.dart';
import 'package:seniorshield/widgets/responsive_text.dart';
import '../../constants/images.dart';
import '../../widgets/customLogin_textField.dart';
import 'calculatorbrain.dart';

class BMIScreen extends StatefulWidget {
  const BMIScreen({Key? key}) : super(key: key);

  @override
  State<BMIScreen> createState() => _BMIScreenState();
}

class _BMIScreenState extends State<BMIScreen> {
  TextEditingController weightController = TextEditingController();
  TextEditingController heightController = TextEditingController();
  TextEditingController ageController = TextEditingController();

  late CalculatorBrain calculator;
  bool isMaleSelected = false;
  bool isFemaleSelected = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 20),
              ResponsiveText("Calculate BMI", fontSize: 20, textColor: kPrimaryColor, fontWeight: FontWeight.bold),
              SizedBox(height: 40),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        isMaleSelected = true;
                        isFemaleSelected = false;
                      });
                    },
                    child: AnimatedContainer(
                      duration: Duration(milliseconds: 200),
                      height: height / 6,
                      width: width / 3,
                      padding: EdgeInsets.all(16),
                      child: Image.asset(
                        user_male,
                        width: 100,
                        height: 100,
                      ),
                      decoration: BoxDecoration(
                        color: isMaleSelected ? kPrimaryColor.withOpacity(0.8) : kPrimaryColor.withOpacity(0.7),
                        borderRadius: BorderRadius.circular(32),
                        boxShadow: isMaleSelected
                            ? [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.5),
                            spreadRadius: 3,
                            blurRadius: 7,
                            offset: Offset(0, 3),
                          ),
                        ]
                            : null,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: kHorizontalMargin * 3,
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        isMaleSelected = false;
                        isFemaleSelected = true;
                      });
                    },
                    child: AnimatedContainer(
                      duration: Duration(milliseconds: 200),
                      height: height / 6,
                      width: width / 3,
                      padding: EdgeInsets.all(16),
                      child: Image.asset(
                        user_female,
                        width: 100,
                        height: 100,
                      ),
                      decoration: BoxDecoration(
                        color: isFemaleSelected ? kPrimaryColor.withOpacity(0.8) : kPrimaryColor.withOpacity(0.7),
                        borderRadius: BorderRadius.circular(32),
                        boxShadow: isFemaleSelected
                            ? [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.5),
                            spreadRadius: 3,
                            blurRadius: 7,
                            offset: Offset(0, 3),
                          ),
                        ]
                            : null,
                      ),
                    ),
                  ),
                ],
              ),

              SizedBox(height: kVerticalMargin),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    CustomBMITextField(
                      controller: weightController,
                      labelText: 'Weight',
                      hintText: '80 kg',
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter weight';
                        }
                        if (double.tryParse(value) == null) {
                          return 'Please enter a valid number';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 20),
                    CustomBMITextField(
                      controller: heightController,
                      labelText: 'Height',
                      hintText: '180 cm',
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter height';
                        }
                        if (double.tryParse(value) == null) {
                          return 'Please enter a valid number';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 20),
                    CustomBMITextField(
                      controller: ageController,
                      labelText: 'Age',
                      hintText: '50 yrs',
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter age';
                        }
                        if (int.tryParse(value) == null) {
                          return 'Please enter a valid number';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        if (_validateInputs()) {
                          double weight = double.parse(weightController.text);
                          double height = double.parse(heightController.text);
                          int age = int.parse(ageController.text);

                          calculator = CalculatorBrain(height: height.toInt(), weight: weight.toInt());
                          _showResultBottomSheet(calculator.calculateBMI(), calculator.getResults(), calculator.getInterpretation());
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        primary: kPrimaryColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(32),
                        ),
                      ),
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                        child: ResponsiveText(
                          "Calculate",
                          fontSize: 16,
                          textColor: Colors.white,
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showResultBottomSheet(double bmi, String result, String interpretation) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ResponsiveText(
                'BMI Calculation Result',
                fontSize: 20,
                fontWeight: FontWeight.bold,
                textColor: kPrimaryColor,
              ),
              SizedBox(height: 20),
              ResponsiveText('BMI: ${bmi.toStringAsFixed(1)}'),
              SizedBox(height: 10),
              ResponsiveText('Result: $result', fontWeight: FontWeight.bold,),
              SizedBox(height: 10),
              ResponsiveText('Report: $interpretation',fontWeight: FontWeight.bold),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Close the bottom sheet
                },
                style: ElevatedButton.styleFrom(
                  primary: kPrimaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(32),
                  ),
                ),
                child: Center(
                  child: Padding(
                    padding:  EdgeInsets.all(kHorizontalMargin),
                    child: ResponsiveText(
                      'OK',
                      textColor: kDefaultIconLightColor,
                      fontSize: 18,
                    ),
                  )
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  bool _validateInputs() {
    if (weightController.text.isEmpty || heightController.text.isEmpty || ageController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please fill all the fields'),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 2),
        ),
      );
      return false;
    }
    if (double.tryParse(weightController.text) == null ||
        double.tryParse(heightController.text) == null ||
        int.tryParse(ageController.text) == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please enter valid numeric values'),
          backgroundColor: Colors.red,
        ),
      );
      return false;
    }
    return true;
  }
}


