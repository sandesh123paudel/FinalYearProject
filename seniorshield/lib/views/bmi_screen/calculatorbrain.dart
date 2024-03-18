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
    if (bmi > 24) {
      return 'Overweight';
    } else if (bmi > 18.5) {
      return 'Normal';
    } else {
      return 'Underweight';
    }
  }

  String getInterpretation() {
    double bmi = calculateBMI();
    if (bmi >= 24) {
      return 'You have a higher than normal weight. Try to exercise more.';
    } else if (bmi > 18.5) {
      return 'You have normal body weight. Well Done.';
    } else {
      return 'You have lower than normal body weight. You can eat a bit more.';
    }
  }
}