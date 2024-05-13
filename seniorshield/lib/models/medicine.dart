class Medicine {
  final String name;
  final String dosage;
  final String reminderTime;

  Medicine({required this.name, required this.dosage, required this.reminderTime});

  Map<String, dynamic> toJson() => {
    'name': name,
    'dosage': dosage,
    'reminderTime': reminderTime,
  };

  static Medicine fromJson(Map<String, dynamic> json) => Medicine(
    name: json['name'],
    dosage: json['dosage'],
    reminderTime: json['reminderTime'],
  );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is Medicine &&
              runtimeType == other.runtimeType &&
              name == other.name &&
              dosage == other.dosage &&
              reminderTime == other.reminderTime;

  @override
  int get hashCode => name.hashCode ^ dosage.hashCode ^ reminderTime.hashCode;
}
