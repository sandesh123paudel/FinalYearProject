import 'dart:math';

class CalculatorBrain {
  CalculatorBrain({required this.height, required this.weight});

  final int height;
  final int weight;

  double calculateBMI() {
    return weight / pow(height / 100, 2);
  }

  String getResults() {
    double bmi = calculateBMI();
    if (bmi >= 30) {
      return "Obese";
    } else if (bmi >= 25) {
      return "Overweight";
    } else if (bmi >= 18.5) {
      return "Normal";
    } else {
      return "Underweight";
    }
  }

  String getInterpretation() {
    double bmi = calculateBMI();
    if (bmi >= 30) {
      return "You are in the obese range. It's important to consult with a healthcare provider to manage your weight.";
    } else if (bmi >= 25) {
      return "You are overweight. Consider making dietary and lifestyle changes to improve your health.";
    } else if (bmi >= 18.5) {
      return "You have normal body weight. Well done! Maintain a healthy lifestyle.";
    } else {
      return "You are underweight. It's important to ensure you're getting enough nutrition. Consider consulting with a healthcare provider.";
    }
  }

}