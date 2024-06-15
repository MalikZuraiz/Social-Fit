// ignore_for_file: use_super_parameters

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CALTextField extends StatelessWidget {
  final Icon prefixIcon;
  final bool suffixIcon;
  final bool onSuffixIconChange;
  final String emailLabel;
  final TextEditingController emailLogin;
  final VoidCallback? isSuffixChange;
  final bool isObscure;
  final TextInputType keyboardType; // Added keyboardType parameter

  const CALTextField({
    Key? key,
    this.isSuffixChange,
    required this.emailLogin,
    required this.prefixIcon,
    this.suffixIcon = false,
    this.onSuffixIconChange = false,
    required this.emailLabel,
    required this.isObscure,
    this.keyboardType =
        TextInputType.text, // Made keyboardType optional with default value
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: emailLogin,
      textAlign: TextAlign.start,
      textInputAction: TextInputAction.none,
      obscureText: isObscure,
      autofocus: false,
      style: GoogleFonts.poppins(fontSize: 15),
      keyboardType: keyboardType, // Use keyboardType parameter here
      textAlignVertical: TextAlignVertical.center,
      decoration: InputDecoration(
        fillColor: const Color(0xffE7E7F2),
        filled: true,
        prefixIcon: prefixIcon,
        prefixIconColor: const Color(0xff00205C),
        suffixIcon: suffixIcon
            ? GestureDetector(
                onTap: isSuffixChange,
                child: Icon(onSuffixIconChange
                    ? Icons.calendar_month_outlined
                    : Icons.calendar_month_outlined),
              )
            : null,
        suffixIconColor: const Color(0xff00205C),
        labelText: emailLabel,
        labelStyle: GoogleFonts.poppins(fontSize: 15),
        floatingLabelBehavior: FloatingLabelBehavior.never,
        border: OutlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }
}
