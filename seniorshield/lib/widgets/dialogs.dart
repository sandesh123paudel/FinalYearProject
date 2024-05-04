import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:seniorshield/constants/colors.dart';

class Dialogs {
  static void showSnackbar(BuildContext context, String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg),backgroundColor: kPrimaryColor.withOpacity(0.8),behavior: SnackBarBehavior.floating,));
  }

  static void showProgressBar(BuildContext context)
  {
    showDialog(context: context, builder: (_)=>const Center(child: CircularProgressIndicator(color: kPrimaryColor,),));
  }
}
