// medicine_model.dart

class Medicine {
  final String name;
  final String dosage;

  Medicine({required this.name, required this.dosage});

  // Factory constructor to convert JSON object to Medicine instance
  factory Medicine.fromJson(Map<String, dynamic> json) {
    return Medicine(
      name: json['name'],
      dosage: json['dosage'],
    );
  }

  // Method to convert Medicine instance to JSON object
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'dosage': dosage,
    };
  }
}
