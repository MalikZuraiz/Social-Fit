// ignore_for_file: avoid_print, unused_local_variable, unused_import

import 'dart:io';

import 'package:circular_profile_avatar/circular_profile_avatar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:enefty_icons/enefty_icons.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:multiselect_formfield/multiselect_formfield.dart';

import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'package:social_fit/social_module/auth/login_view.dart';
import 'package:social_fit/social_module/home/home_view.dart';
import 'package:social_fit/social_module/state_management/widget_handling.dart';
import 'package:social_fit/social_module/utils/cal_reuse.dart';
import 'package:social_fit/social_module/utils/reuse_textfield.dart';
import 'package:social_fit/social_module/utils/utils.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  RegisterController registerController = Get.put(RegisterController());
  @override
  Widget build(BuildContext context) {
    final double buttonwidth = MediaQuery.of(context).size.width * 1;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text('Social Fit',
            style: TextStyle(
                fontFamily: 'Billabong',
                fontWeight: FontWeight.bold,
                fontSize: 32,
                color: Color(0xff000221))),
        automaticallyImplyLeading: false,
        leading: IconButton(
            onPressed: () {
              Get.to(() => const LoginView());
            },
            icon: const Icon(
              Icons.arrow_back_ios_new_rounded,
              color: Colors.black,
            )),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.all(28),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text('Sign-up to the Social Fit App ',
                          style: GoogleFonts.poppins(
                              fontWeight: FontWeight.bold, fontSize: 18)),
                    ],
                  ),
                  Text('Enter the Email & \nPassword to Join',
                      style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w500, fontSize: 18)),
                  Padding(
                    padding: const EdgeInsets.only(top: 15),
                    child: Center(
                      child: Stack(
                        children: [
                          Obx(() {
                            return CircleAvatar(
                              radius: 50,
                              backgroundImage:
                                  registerController.imageFile != null
                                      ? FileImage(registerController.imageFile!)
                                      : const AssetImage('assets/avatar.png')
                                          as ImageProvider,
                            );
                          }),
                          Positioned(
                            bottom: -10,
                            right: 0,
                            child: IconButton(
                              icon: Icon(
                                Icons.add_a_photo_rounded,
                                color: Colors.grey.shade900,
                              ),
                              onPressed: () {
                                showModalBottomSheet(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return SizedBox(
                                      height: 150,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: <Widget>[
                                          ListTile(
                                            leading: const Icon(Icons.camera),
                                            title: const Text('Take a picture'),
                                            onTap: () {
                                              registerController.pickImage(
                                                  ImageSource.camera);
                                              Navigator.pop(context);
                                            },
                                          ),
                                          ListTile(
                                            leading:
                                                const Icon(Icons.photo_library),
                                            title: const Text(
                                                'Choose from gallery'),
                                            onTap: () {
                                              registerController.pickImage(
                                                  ImageSource.gallery);
                                              Navigator.pop(context);
                                            },
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 30),
                    child: Obx(() => ReuseTextField(
                          emailLabel: 'Enter Your Name',
                          emailLogin: registerController.userName.value,
                          isObscure: false,
                          prefixIcon: const Icon(Icons.person),
                          suffixIcon: false,
                          onSuffixIconChange: false,
                        )),
                  ),
                  Padding(
                      padding: const EdgeInsets.only(top: 20),
                      child: Obx(
                        () => ReuseTextField(
                          emailLabel: 'Enter Bio',
                          emailLogin: registerController.userBio.value,
                          isObscure: false,
                          prefixIcon: const Icon(Icons.star),
                          suffixIcon: false,
                          onSuffixIconChange: false,
                        ),
                      )),
                  Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: Obx(() => ReuseTextField(
                          emailLabel: 'Enter Weight',
                          emailLogin: registerController.userWeight.value,
                          keyboardType: TextInputType.number,
                          isObscure: false,
                          prefixIcon: const Icon(Icons.bloodtype_outlined),
                          suffixIcon: false,
                          onSuffixIconChange: false,
                        )),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: Obx(() => ReuseTextField(
                          emailLabel: 'Enter Height',
                          emailLogin: registerController.userHeight.value,
                          keyboardType: TextInputType.number,
                          isObscure: false,
                          prefixIcon: const Icon(Icons.boy_outlined),
                          suffixIcon: false,
                          onSuffixIconChange: false,
                        )),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: Obx(() => CALTextField(
                          emailLabel: 'Enter Date of Birth',
                          emailLogin:
                              registerController.userDOBController.value,
                          keyboardType: TextInputType.datetime,
                          isObscure: false,
                          prefixIcon: const Icon(Icons.calendar_today_outlined),
                          suffixIcon: true,
                          isSuffixChange: () =>
                              registerController.selectDateOfBirth(context),
                        )),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: Obx(() => ReuseTextField(
                          emailLabel: 'How many days to exercise ?',
                          emailLogin:
                              registerController.userDaysofExercise.value,
                          keyboardType: TextInputType.number,
                          isObscure: false,
                          prefixIcon: const Icon(Icons.sunny),
                          suffixIcon: false,
                          onSuffixIconChange: false,
                          errorMessage: 'Enter the days between 1-7',
                          restrictTo1To7: true,
                        )),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: Obx(() => ReuseTextField(
                          emailLabel: 'Enter Email',
                          emailLogin: registerController.emailLogin.value,
                          isObscure: false,
                          prefixIcon: const Icon(Icons.email),
                          suffixIcon: false,
                          onSuffixIconChange: false,
                        )),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: Obx(() => ReuseTextField(
                          emailLabel: 'Enter Password',
                          emailLogin: registerController.passwordLogin.value,
                          isObscure: registerController.isObscureChange.value,
                          prefixIcon: const Icon(Icons.lock),
                          suffixIcon: true,
                          onSuffixIconChange:
                              registerController.isSuffixIconChange.value,
                          isSuffixChange: () {
                            registerController.isObscureChange.value =
                                !registerController.isObscureChange.value;
                            registerController.isSuffixIconChange.value =
                                !registerController.isSuffixIconChange.value;
                          },
                        )),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: Obx(() => ReuseTextField(
                          emailLabel: 'Confirm Password',
                          emailLogin: registerController.repasswordLogin.value,
                          isObscure: registerController.reisObscureChange.value,
                          prefixIcon: const Icon(Icons.lock_reset),
                          suffixIcon: true,
                          onSuffixIconChange:
                              registerController.reisSuffixIconChange.value,
                          isSuffixChange: () {
                            registerController.reisObscureChange.value =
                                !registerController.reisObscureChange.value;
                            registerController.reisSuffixIconChange.value =
                                !registerController.reisSuffixIconChange.value;
                          },
                        )),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: Obx(() => DropdownButtonFormField<String>(
                          decoration: const InputDecoration(
                            filled: true,
                            fillColor: Color(0xffE7E7F2),
                            prefixIcon: Icon(Icons.boy_rounded),
                            prefixIconColor: Color(0xff00205C),
                            border: InputBorder.none,
                          ),
                          value: registerController.selectedLevel.value,
                          onChanged: (String? newValue) {
                            if (newValue != null) {
                              registerController.selectedLevel.value = newValue;
                            }
                          },
                          items: <String>['Easy', 'Medium', 'Hard', 'Extreme']
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                        )),
                  ),
                  Padding(
                      padding: const EdgeInsets.only(top: 20),
                      child: MultiSelectFormField(
                        autovalidate: AutovalidateMode.always,
                        title: const Text('Select Exercise Goals'),
                        dataSource: const [
                          {
                            "display": "Weight Loss",
                            "value": "Weight Loss",
                          },
                          {
                            "display": "Muscle Building",
                            "value": "Muscle Building",
                          },
                          {
                            "display": "Cardiovascular Health",
                            "value": "Cardiovascular Health",
                          },
                          {
                            "display": "Flexibility",
                            "value": "Flexibility",
                          },
                          {
                            "display": "Endurance",
                            "value": "Endurance",
                          },
                        ],
                        textField: 'display',
                        valueField: 'value',
                        okButtonLabel: 'OK',
                        cancelButtonLabel: 'CANCEL',
                        hintWidget: const Text(''),
                        initialValue: registerController.selectedGoals,
                        onSaved: (value) {
                          if (value == null) return;
                          registerController.selectedGoals
                              .assignAll(value.cast<String>());
                        },
                      )),
                  Padding(
                    padding: const EdgeInsets.only(top: 15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Gender',
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        Row(
                          children: [
                            Obx(
                              () => GestureDetector(
                                onTap: () {
                                  registerController.selectedGender.value =
                                      Gender.male;
                                },
                                child: CircleAvatar(
                                  radius: 15,
                                  backgroundColor:
                                      registerController.selectedGender.value ==
                                              Gender.male
                                          ? Colors.blue
                                          : Colors.grey,
                                  child: Icon(Icons.male,
                                      color: registerController
                                                  .selectedGender.value ==
                                              Gender.male
                                          ? Colors.white
                                          : Colors.black),
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Obx(
                              () => GestureDetector(
                                onTap: () {
                                  registerController.selectedGender.value =
                                      Gender.female;
                                },
                                child: CircleAvatar(
                                  radius: 15,
                                  backgroundColor:
                                      registerController.selectedGender.value ==
                                              Gender.female
                                          ? Colors.pink
                                          : Colors.grey,
                                  child: Icon(Icons.female,
                                      color: registerController
                                                  .selectedGender.value ==
                                              Gender.female
                                          ? Colors.white
                                          : Colors.black),
                                ),
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 15),
                    child: Obx(() => Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Joining As Trainer ?',
                              style: GoogleFonts.poppins(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            Switch(
                              value: registerController.isTrainer.value,
                              onChanged: (value) {
                                registerController.isTrainer.value = value;
                              },
                            ),
                          ],
                        )),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 5),
                    child: Obx(() => Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Any Health Conditions or Injuries ?',
                                style: GoogleFonts.poppins(
                                    fontWeight: FontWeight.w400, fontSize: 12)),
                            Transform.scale(
                              scale: 1.5,
                              child: Checkbox(
                                  activeColor: Colors.orange,
                                  shape: const CircleBorder(),
                                  value:
                                      registerController.isCheckedHealth.value,
                                  onChanged: (value) {
                                    registerController.isCheckedHealth.value =
                                        value!;
                                  }),
                            )
                          ],
                        )),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 5),
                    child: Obx(() => Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Agree upon the term and conditions.',
                                style: GoogleFonts.poppins(
                                    fontWeight: FontWeight.w400, fontSize: 12)),
                            Transform.scale(
                              scale: 1.2,
                              child: Checkbox(
                                  value: registerController.isChecked.value,
                                  onChanged: (value) {
                                    registerController.isChecked.value = value!;
                                  }),
                            )
                          ],
                        )),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 15),
                    child: RoundedLoadingButton(
                      width: buttonwidth * 0.8,
                      color: const Color(0xff00C1AA),
                      controller: registerController.controller,
                      animateOnTap: true,
                      errorColor: Colors.red,
                      failedIcon: Icons.error,
                      onPressed: () async {
                        registerController.controller.start();
                        registerController.printFormValues();
                        var connectivityResult =
                            await (Connectivity().checkConnectivity());
                        if ([
                              registerController.emailLogin,
                              registerController.passwordLogin,
                              registerController.repasswordLogin,
                              registerController.userName,
                              registerController.userBio,
                              // userage,
                              registerController.userDOBController,
                              registerController.userDaysofExercise,
                              registerController.userHeight,
                              registerController.userWeight
                            ].any((controller) =>
                                controller.value.text.isEmpty) ||
                            registerController.selectedGoals.isEmpty) {
                          registerController.controller.stop();
                          Get.snackbar(
                            'Fill the Fields',
                            'Enter All Fields',
                            margin: const EdgeInsets.only(
                                bottom: 10, left: 10, right: 10),
                            backgroundColor: Colors.red,
                            borderRadius: 12,
                            snackPosition: SnackPosition.BOTTOM,
                          );
                        } else if (connectivityResult ==
                            ConnectivityResult.none) {
                          registerController.controller.stop();
                          Get.snackbar(
                              'Internet', 'Make Sure Internet is Available',
                              margin: const EdgeInsets.only(
                                bottom: 10,
                                left: 10,
                                right: 10,
                              ),
                              backgroundColor: Colors.red,
                              borderRadius: 12,
                              snackPosition: SnackPosition.BOTTOM);
                        } else if (registerController
                                .passwordLogin.value.text.length !=
                            6) {
                          registerController.controller.stop();
                          Get.snackbar(
                            'Password Length',
                            'Password should have length of 6',
                            margin: const EdgeInsets.only(
                                bottom: 10, left: 10, right: 10),
                            backgroundColor: Colors.red,
                            borderRadius: 12,
                            snackPosition: SnackPosition.BOTTOM,
                          );
                        } else if (Utils().checkEmailValid(
                                registerController.emailLogin.value.text) ==
                            false) {
                          registerController.controller.stop();
                          Get.snackbar(
                            'Email Pattern Error',
                            'Enter Correct Email',
                            margin: const EdgeInsets.only(
                                bottom: 10, left: 10, right: 10),
                            backgroundColor: Colors.red,
                            borderRadius: 12,
                            snackPosition: SnackPosition.BOTTOM,
                          );
                        } else if (registerController
                                .passwordLogin.value.text ==
                            registerController.repasswordLogin.value.text) {
                          try {
                            UserCredential userCredential = await FirebaseAuth
                                .instance
                                .createUserWithEmailAndPassword(
                                    email: registerController
                                        .emailLogin.value.text,
                                    password: registerController
                                        .passwordLogin.value.text);

                            String imageUrl = '';
                            if (registerController.imageFile != null) {
                              Reference ref = FirebaseStorage.instance
                                  .ref()
                                  .child('images/${DateTime.now().toString()}');
                              await ref.putFile(registerController.imageFile!);
                              imageUrl = await ref.getDownloadURL();
                            }

                            //parameters we are sending
                            await FirebaseFirestore.instance
                                .collection('Users')
                                .doc(userCredential.user!.email)
                                .set(
                              {
                                'uid': userCredential.user!.uid,
                                'email': userCredential.user!.email,
                                'username':
                                    registerController.userName.value.text,
                                'userImage': imageUrl,
                                'userCoverImage': imageUrl,
                                'bio': registerController.userBio.value.text,
                                'trainer': registerController.isTrainer.value,
                                'weight':
                                    registerController.userWeight.value.text,
                                'height':
                                    registerController.userHeight.value.text,
                                'dob': registerController
                                    .userDOBController.value.text,
                                'daysOfExercise': registerController
                                    .userDaysofExercise.value.text,
                                // 'age': userage.text,
                                // ignore: unrelated_type_equality_checks
                                'gender':
                                    registerController.selectedGender.value ==
                                            Gender.male
                                        ? 'Male'
                                        : 'Female',
                                'goals':
                                    registerController.selectedGoals.join(', '),
                                'level': registerController.selectedLevel.value,
                                'healthCondition':
                                    registerController.isCheckedHealth.value,
                              },
                            );

                            // Authentication and user data storage successful, navigate to HomeView
                            Get.off(() => const HomeView());
                          } catch (error) {
                            registerController.controller.stop();
                            print(error);
                            Get.snackbar(
                              'Sign-Up Error',
                              error.toString(),
                              margin: const EdgeInsets.only(
                                  bottom: 10, left: 10, right: 10),
                              backgroundColor: Colors.red,
                              borderRadius: 12,
                              snackPosition: SnackPosition.BOTTOM,
                            );
                          }
                        } else {
                          registerController.controller.stop();
                          Get.snackbar(
                            'Sign-Up Error',
                            'Password is not matched!',
                            margin: const EdgeInsets.only(
                                bottom: 10, left: 10, right: 10),
                            backgroundColor: Colors.red,
                            borderRadius: 12,
                            snackPosition: SnackPosition.BOTTOM,
                          );
                        }
                      },
                      child: Text(
                        'Sign Up',
                        style: GoogleFonts.poppins(
                            fontSize: 15, color: Colors.white),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 30),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Already\'ve an account?',
                            style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w400, fontSize: 12)),
                        GestureDetector(
                          onTap: () {
                            Get.back();
                          },
                          child: Text(' Login',
                              style: GoogleFonts.poppins(
                                  color: const Color(0xff00C1AA),
                                  fontWeight: FontWeight.w800,
                                  fontSize: 12)),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

enum Gender { male, female }
