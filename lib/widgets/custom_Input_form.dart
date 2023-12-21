import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:trade_app/utils/app_colors.dart';

class CustomInputForm extends StatelessWidget {
  final TextEditingController? controller;
  final IconData? icon;
  final String? label;
  final String hint;
  final bool? obscureText;
  final TextInputType? keyboardType;
  final int? maxLines;
  final VoidCallback? onTap;
  final bool? readOnly;
  final String? Function(String?)? validator;
  final Widget? suffixIcon;
  List<TextInputFormatter>? inputformtters;

  CustomInputForm(
      {super.key,
      this.icon,
      this.label,
      required this.hint,
      this.obscureText,
      this.keyboardType,
      this.maxLines,
      this.onTap,
      this.readOnly,
      this.validator,
      this.suffixIcon,
      this.inputformtters,
      this.controller});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      width: MediaQuery.of(context).size.width * 0.7,
      child: TextFormField(
        controller: controller,
        readOnly: readOnly ?? false,
        onTap: onTap,
        style:
            const TextStyle(color: AppColors.blue, fontWeight: FontWeight.w900),
        maxLines: maxLines ?? 1,
        obscureText: obscureText ?? false,
        keyboardType: keyboardType ?? TextInputType.text,
        validator: validator,
        cursorColor: Colors.black,
        inputFormatters: inputformtters,
        decoration: InputDecoration(
          suffixIcon: suffixIcon,
          filled: true,
          fillColor: Colors.white,
          disabledBorder: null,
          errorBorder: null,
          enabledBorder: null,
          border: null,
          focusedBorder: null,
          labelText: label,
          labelStyle: const TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w600,
          ),
          hintText: hint,
          hintStyle: TextStyle(
            color: Colors.black.withOpacity(0.50),
            fontFamily: "Poppins",
            fontSize: 16,
            fontWeight: FontWeight.w400,
            height: 0,
            letterSpacing: 0.32,
          ),
          floatingLabelBehavior: FloatingLabelBehavior.never,
        ),
      ),
    );
  }
}
