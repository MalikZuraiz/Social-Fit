// ignore_for_file: avoid_print

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'package:social_fit/social_module/auth/register_view.dart';

class RegisterController extends GetxController {
  final Rx<TextEditingController> emailLogin = TextEditingController().obs;
  final Rx<TextEditingController> userName = TextEditingController().obs;
  final Rx<TextEditingController> userBio = TextEditingController().obs;
  final Rx<TextEditingController> userWeight = TextEditingController().obs;
  final Rx<TextEditingController> userHeight = TextEditingController().obs;
  final Rx<TextEditingController> userDaysofExercise =
      TextEditingController().obs;
  final Rx<TextEditingController> userDOBController =
      TextEditingController().obs;
  final Rx<TextEditingController> userage = TextEditingController().obs;
  final Rx<TextEditingController> passwordLogin = TextEditingController().obs;
  final Rx<TextEditingController> repasswordLogin = TextEditingController().obs;
  RxBool isTrainer = RxBool(false);
  final RxBool isChecked = false.obs;
  final RxBool isCheckedHealth = false.obs;
  final RxBool isImageSelected = false.obs;
  final Rx<File?> _imageFile = Rx<File?>(null);
  File? get imageFile => _imageFile.value;
  final ImagePicker _picker = ImagePicker();

  final RoundedLoadingButtonController controller =
      RoundedLoadingButtonController();

  final RxBool isSuffixIconChange = false.obs;

  final RxBool isObscureChange = true.obs;

  final RxBool reisSuffixIconChange = false.obs;

  final RxBool reisObscureChange = true.obs;
  final RxString selectedLevel = 'Easy'.obs;
  final RxList<String> selectedGoals = <String>[].obs;

  void pickImage(ImageSource source) async {
    final pickedFile = await _picker.pickImage(source: source);
    if (pickedFile != null) {
      _imageFile.value = File(pickedFile.path);
      update();
    }
  }

  void toggleIsTrainer() {
    isTrainer.value = !isTrainer.value;
  }

  void selectDateOfBirth(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );

    if (pickedDate != null) {
      userDOBController.value.text = pickedDate.toIso8601String().split('T')[0];
      update();
    }
  }

  final Rx<Gender?> selectedGender = Rx<Gender?>(null);

  void printFormValues() {
    print('Email: ${emailLogin.value.text}');
    print('Username: ${userName.value.text}');
    print('User Bio: ${userBio.value.text}');
    print('User Weight: ${userWeight.value.text}');
    print('User Height: ${userHeight.value.text}');
    print('User Days of Exercise: ${userDaysofExercise.value.text}');
    print('User Date of Birth: ${userDOBController.value.text}');
    print('Is Trainer: ${isTrainer.value}');
    print('Is Checked: ${isChecked.value}');
    print('Is Checked Health: ${isCheckedHealth.value}');
    print('Is Image Selected: ${isImageSelected.value}');
    print('Selected Gender: ${selectedGender.value}');
    print('Selected Level: ${selectedLevel.value}');
    print('Selected Goals: $selectedGoals');
  }

  @override
  void onClose() {
    // Clean up your controllers here
    emailLogin.value.dispose();
    userName.value.dispose();
    userBio.value.dispose();
    userWeight.value.dispose();
    userHeight.value.dispose();
    userDaysofExercise.value.dispose();
    userDOBController.value.dispose();
    userage.value.dispose();
    passwordLogin.value.dispose();
    repasswordLogin.value.dispose();
    super.onClose();
  }
}
