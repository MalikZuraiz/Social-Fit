// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

class LoginWidgetsHandling extends GetxController {
  final Rx<TextEditingController> userEmail = TextEditingController().obs;
  final Rx<TextEditingController> userPassword = TextEditingController().obs;
  final RoundedLoadingButtonController controller =
      RoundedLoadingButtonController();

  final RxBool isSuffixIconChange = false.obs;

  final RxBool isObscureChange = true.obs;

  void printFormValues() {
    print('UserEmail: ${userEmail.value.text}');
    print('UserPassword: ${userPassword.value.text}');
  }

  @override
  void onClose() {
    // Clean up your controllers here
    userEmail.value.dispose();
    userPassword.value.dispose();
    super.onClose();
  }
}
