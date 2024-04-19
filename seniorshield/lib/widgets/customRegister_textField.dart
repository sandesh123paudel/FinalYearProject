import 'package:flutter/material.dart';
import 'package:seniorshield/widgets/responsive_text.dart';

import '../constants/colors.dart';
import '../constants/util/util.dart';

class CustomRegisterTextField extends StatefulWidget {
  final String? labelText;
  final String? hintText;
  final bool obscureText;
  final TextInputType? keyboardType;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final String? errorText; // New errorText parameter
  final ValueChanged<String>? onChanged; // Added onChanged parameter

  const CustomRegisterTextField({
    Key? key,
    @required this.labelText,
    @required this.hintText,
    this.keyboardType,
    this.obscureText = false,
    this.controller,
    this.errorText, // Added errorText parameter
    this.onChanged,
    this.validator, // Added validator parameter
  }) : super(key: key);

  @override
  _CustomRegisterTextFieldState createState() => _CustomRegisterTextFieldState();
}

class _CustomRegisterTextFieldState extends State<CustomRegisterTextField> {
  late TextEditingController _textEditingController;
  bool _obscureText = true;

  @override
  void initState() {
    super.initState();
    // Initialize TextEditingController if not provided
    _textEditingController = widget.controller ?? TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ResponsiveText(
          widget.labelText!,
          fontSize: 16,
          textColor: kPrimaryColor,
          fontWeight: FontWeight.bold,
        ),
        SizedBox(height: kVerticalMargin / 2),
        TextFormField(
          controller: _textEditingController,
          keyboardType: widget.keyboardType,
          cursorColor: kPrimaryColor,
          style: TextStyle(color: kPrimaryColor),
          obscureText: widget.obscureText ? _obscureText : false,
          onSaved: (value){
            _textEditingController.text=value!;
          },
          onChanged: (value) {
            setState(() {
              // Reset error message on change
              widget.errorText;
            });
            widget.onChanged?.call(value); // Pass onChanged callback to TextField
          },
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

        if (widget.errorText != null) // Display error text if available
          Padding(
            padding: const EdgeInsets.only(top: 4.0),
            child: Text(
              widget.errorText!,
              style: TextStyle(color: Colors.red),
            ),
          ),
      ],
    );
  }
}
