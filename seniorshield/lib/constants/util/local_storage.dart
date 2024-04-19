// local_storage.dart

import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

import '../../models/medicine.dart';

class LocalStorage {
  static const String _medicineKey = 'medicine';

  static Future<bool> saveMedicine(Medicine medicine) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      List<String>? medicineListString = prefs.getStringList(_medicineKey);
      List<Medicine> medicineList =
          medicineListString?.map((e) => Medicine.fromJson(jsonDecode(e))).toList() ??
              [];
      medicineList.add(medicine);
      List<String> updatedMedicineList =
      medicineList.map((e) => jsonEncode(e.toJson())).toList();
      return await prefs.setStringList(_medicineKey, updatedMedicineList);
    } catch (e) {
      print('Error saving medicine: $e');
      return false;
    }
  }

  static Future<List<Medicine>> getMedicines() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      List<String>? medicineListString = prefs.getStringList(_medicineKey);
      if (medicineListString == null) {
        return [];
      }
      List<Medicine> medicineList =
      medicineListString.map((e) => Medicine.fromJson(jsonDecode(e))).toList();
      return medicineList;
    } catch (e) {
      print('Error getting medicines: $e');
      return [];
    }
  }
}
