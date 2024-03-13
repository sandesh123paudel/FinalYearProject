import 'package:flutter/material.dart';
import 'package:seniorshield/widgets/responsive_text.dart';

import '../constants/colors.dart';
import '../constants/util/util.dart';

class CustomLoginTextField extends StatefulWidget {
  final String? labelText;
  final String? hintText;
  final bool obscureText;
  final TextInputType? keyboardType;

  const CustomLoginTextField({
    Key? key,
    @required this.labelText,
    @required this.hintText,
    this.keyboardType,
    this.obscureText = false,
  }) : super(key: key);

  @override
  _CustomLoginTextFieldState createState() => _CustomLoginTextFieldState();
}

class _CustomLoginTextFieldState extends State<CustomLoginTextField> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ResponsiveText(
          widget.labelText!,
          fontSize: 16,
          textColor: kPrimaryColor,
          fontWeight: FontWeight.w500,
        ),
        SizedBox(height: kVerticalMargin / 2),
        TextField(
          keyboardType: widget.keyboardType,
          cursorColor: kPrimaryColor,
          style: TextStyle(color: kPrimaryColor),
          obscureText: widget.obscureText ? _obscureText : false,
          decoration: InputDecoration(
            hintText: widget.hintText,
            hintStyle: TextStyle(color: kPrimaryColor.withOpacity(0.5)),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: kPrimaryColor),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: kPrimaryColor, width: 2),
            ),
            suffixIcon: widget.obscureText
                ? IconButton(
              onPressed: () {
                setState(() {
                  _obscureText = !_obscureText;
                });
              },
              icon: Icon(
                _obscureText ? Icons.visibility_off : Icons.visibility,
                color: kPrimaryColor,
              ),
            )
                : null,
          ),
        ),
      ],
    );
  }
}
