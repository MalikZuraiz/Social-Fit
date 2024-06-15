// ignore_for_file: use_super_parameters

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/services.dart';

class ReuseTextField extends StatelessWidget {
  final Icon prefixIcon;
  final bool suffixIcon;
  final bool onSuffixIconChange;
  final String emailLabel;
  final TextEditingController emailLogin;
  final VoidCallback? isSuffixChange;
  final bool isObscure;
  final TextInputType keyboardType;
  final String? errorMessage;
  final bool restrictTo1To7;

  const ReuseTextField({
    Key? key,
    this.isSuffixChange,
    required this.emailLogin,
    required this.prefixIcon,
    this.suffixIcon = false,
    this.onSuffixIconChange = false,
    required this.emailLabel,
    required this.isObscure,
    this.keyboardType = TextInputType.text,
    this.errorMessage,
    this.restrictTo1To7 = false,
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
      keyboardType: keyboardType,
      textAlignVertical: TextAlignVertical.center,
      inputFormatters: restrictTo1To7
          ? [FilteringTextInputFormatter.allow(RegExp(r'^[1-7]$'))]
          : null,
      decoration: InputDecoration(
        fillColor: const Color(0xffE7E7F2),
        filled: true,
        prefixIcon: prefixIcon,
        prefixIconColor: const Color(0xff00205C),
        suffixIcon: suffixIcon
            ? GestureDetector(
                onTap: isSuffixChange,
                child: Icon(
                    onSuffixIconChange ? Icons.visibility_off : Icons.visibility),
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
        errorText: errorMessage,
      ),
    );
  }
}
