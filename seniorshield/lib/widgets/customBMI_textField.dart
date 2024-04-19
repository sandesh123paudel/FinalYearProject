import 'package:flutter/material.dart';
import 'package:seniorshield/widgets/responsive_text.dart';
import '../constants/colors.dart';
import '../constants/util/util.dart';

class CustomBMITextField extends StatefulWidget {
  final String? labelText;
  final String? hintText;
  final TextEditingController? controller;
  final String? Function(String?)? validator;

  const CustomBMITextField({
    Key? key,
    @required this.labelText,
    @required this.hintText,
    this.controller,
    this.validator,
  }) : super(key: key);

  @override
  _CustomBMITextFieldState createState() => _CustomBMITextFieldState();
}

class _CustomBMITextFieldState extends State<CustomBMITextField> {
  late TextEditingController _textEditingController;

  @override
  void initState() {
    super.initState();
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
          keyboardType: TextInputType.number,
          cursorColor: kPrimaryColor,
          style: TextStyle(color: kPrimaryColor),
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
          ),
          validator: widget.validator,
        ),
      ],
    );
  }
}
