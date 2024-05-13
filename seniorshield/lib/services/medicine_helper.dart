import 'dart:async';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/medicine.dart';


class MedicineStorage {
   static const String medicineListKey = 'medicineList';
  //
  // static Future<void> saveMedicineList(List<Medicine> medicines) async {
  //   final prefs = await SharedPreferences.getInstance();
  //   final medicineListJson = medicines.map((med) => jsonEncode(med.toJson())).toList();
  //   await prefs.setStringList(medicineListKey, medicineListJson);
  // }
  //
  // static Future<List<Medicine>> loadMedicineList() async {
  //   final prefs = await SharedPreferences.getInstance();
  //   final medicineListJson = prefs.getStringList(medicineListKey) ?? [];
  //   return medicineListJson.map((medJson) => Medicine.fromJson(jsonDecode(medJson))).toList();
  // }


  static final _medicineListController = StreamController<List<Medicine>>.broadcast();

  static Stream<List<Medicine>> get medicineListStream => _medicineListController.stream;

  static void _notifyListeners(List<Medicine> medicines) {
    _medicineListController.sink.add(medicines);
  }

  static Future<void> saveMedicineList(List<Medicine> medicines) async {
    final prefs = await SharedPreferences.getInstance();
    final medicineListJson = medicines.map((med) => jsonEncode(med.toJson())).toList();
    await prefs.setStringList(medicineListKey, medicineListJson);
    _notifyListeners(medicines); // Notify listeners about the change
  }

  static Future<List<Medicine>> loadMedicineList() async {
    final prefs = await SharedPreferences.getInstance();
    final medicineListJson = prefs.getStringList(medicineListKey) ?? [];
    final medicines = medicineListJson.map((medJson) => Medicine.fromJson(jsonDecode(medJson))).toList();
    _notifyListeners(medicines); // Notify listeners about the change
    return medicines;
  }


   static Future<void> deleteMedicine(Medicine medicine) async {
     final medicines = await loadMedicineList();
     medicines.remove(medicine);
     await saveMedicineList(medicines);
     _notifyListeners(medicines); // Notify listeners after deleting
   }


}