import 'dart:core';

import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesHelper{
  static String userIdKey="USERKEY";
  static String userFullNameKey="USERFULLNAMEKEY";
  static String userEmailKey="USEREMAILKEY";
  static String userRoleKey="USERROLEKEY";
  static String userAddressKey="USERADDRESSKEY";
  static String userNameKey="USERNAMEKEY";




  Future<bool> saveUserId(String getUserId) async{
    SharedPreferences prefs= await SharedPreferences.getInstance();
    return prefs.setString(userIdKey, getUserId);
  }

  Future<bool> saveFullName(String getName) async{
    SharedPreferences prefs= await SharedPreferences.getInstance();
    return prefs.setString(userFullNameKey, getName);
  }

  Future<bool> saveEmail(String getEmail) async{
    SharedPreferences prefs= await SharedPreferences.getInstance();
    return prefs.setString(userEmailKey, getEmail);
  }

  Future<bool> saveRole(String getRole) async{
    SharedPreferences prefs= await SharedPreferences.getInstance();
    return prefs.setString(userRoleKey, getRole);
  }
  Future<bool> saveAddress(String getAddress) async{
    SharedPreferences prefs= await SharedPreferences.getInstance();
    return prefs.setString(userAddressKey, getAddress);
  }

  Future<bool> saveName(String getUserName) async{
    SharedPreferences prefs= await SharedPreferences.getInstance();
    return prefs.setString(userNameKey, getUserName);
  }




  Future<String?> getUserId() async{
    SharedPreferences prefs= await SharedPreferences.getInstance();
    return prefs.getString(userIdKey);
  }

  Future<String?> getFullName() async{
    SharedPreferences prefs= await SharedPreferences.getInstance();
    return prefs.getString(userFullNameKey);
  }

  Future<String?> getEmail() async{
    SharedPreferences prefs= await SharedPreferences.getInstance();
    return prefs.getString(userEmailKey);
  }

  Future<String?> getRole() async{
    SharedPreferences prefs= await SharedPreferences.getInstance();
    return prefs.getString(userRoleKey);
  }

  Future<String?> getAddress() async{
    SharedPreferences prefs= await SharedPreferences.getInstance();
    return prefs.getString(userAddressKey);
  }

  Future<String?> getUserName() async{
    SharedPreferences prefs= await SharedPreferences.getInstance();
    return prefs.getString(userNameKey);
  }




  static String medicineNameKey = "MEDICINENAMEKEY";
  static String dosageKey = "DOSAGEKEY";
  static String timeKey = "TIMEKEY"; // Add key for time

  // Methods to save medicine information
  Future<bool> saveMedicineName(String name) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString(medicineNameKey, name);
  }

  Future<bool> saveDosage(String dosage) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString(dosageKey, dosage);
  }

  Future<bool> saveTime(String time) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString(timeKey, time);
  }

  // Methods to retrieve medicine information
  Future<String?> getMedicineName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(medicineNameKey);
  }

  Future<String?> getDosage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(dosageKey);
  }

  Future<String?> getTime() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(timeKey);
  }





}