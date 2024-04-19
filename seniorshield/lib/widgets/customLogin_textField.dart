import 'package:flutter/material.dart';
import 'package:seniorshield/widgets/responsive_text.dart';
import '../constants/colors.dart';
import '../constants/util/util.dart';

class CustomLoginTextField extends StatefulWidget {
  final String? labelText;
  final String? hintText;
  final bool obscureText;
  final TextInputType? keyboardType;
  final TextEditingController? controller;
  final String? Function(String?)? validator; // New validator parameter
  final String? errorText; // New errorText parameter
  final ValueChanged<String>? onChanged;

  const CustomLoginTextField({
    Key? key,
    @required this.labelText,
    @required this.hintText,
    this.keyboardType,
    this.obscureText = false,
    this.controller,
    this.validator, // Added validator parameter
    this.errorText,// Added errorText parameter
    this.onChanged,
  }) : super(key: key);

  @override
  _CustomLoginTextFieldState createState() => _CustomLoginTextFieldState();
}

class _CustomLoginTextFieldState extends State<CustomLoginTextField> {
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
          fontWeight: FontWeight.w500,
        ),
        SizedBox(height: kVerticalMargin / 2),
        TextFormField(
          controller: _textEditingController,
          keyboardType: widget.keyboardType,
          cursorColor: kPrimaryColor,
          onChanged: widget.onChanged,
          style: TextStyle(color: kPrimaryColor),
          onSaved: (value){
            _textEditingController.text=value!;
          },
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
          validator: widget.validator, // Set validator
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
