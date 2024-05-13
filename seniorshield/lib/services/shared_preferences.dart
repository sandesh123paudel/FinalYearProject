import 'dart:core';

import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesHelper{
  static String userIdKey="USERKEY";
  static String userFullNameKey="USERFULLNAMEKEY";
  static String userEmailKey="USEREMAILKEY";
  static String userRoleKey="USERROLEKEY";
  static String userAddressKey="USERADDRESSKEY";




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








}