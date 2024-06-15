// ignore_for_file: avoid_print

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'package:social_fit/social_module/auth/forgetpassword_view.dart';
import 'package:social_fit/social_module/auth/register_view.dart';
import 'package:social_fit/social_module/home/home_view.dart';
import 'package:social_fit/social_module/state_management/login_widget_handling.dart';
import 'package:social_fit/social_module/utils/reuse_textfield.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  LoginWidgetsHandling loginWidgetsHandlingcontroller =
      Get.put(LoginWidgetsHandling());

  @override
  Widget build(BuildContext context) {
    final double buttonwidth = MediaQuery.of(context).size.width * 1;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        // backgroundColor: const Color(0xff000221),
        title: const Text('Social Fit',
            style: TextStyle(
                fontFamily: 'Billabong',
                fontWeight: FontWeight.bold,
                fontSize: 32,
                color: Color(0xff000221))),

        automaticallyImplyLeading: false,
      ),
      body: Column(
        children: [
          const SizedBox(height: 30),
          Padding(
            padding: const EdgeInsets.all(28),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text('Sign-in to the Social Fit App ',
                        style: GoogleFonts.poppins(
                            fontWeight: FontWeight.bold, fontSize: 18)),
                    // SizedBox(
                    //     height: 40,
                    //     width: 30,
                    //     child: Image.asset('assets/login.png'))
                  ],
                ),
                Text('Enter the Email & \nPassword to Login',
                    style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w500, fontSize: 18)),
                Padding(
                    padding: const EdgeInsets.only(top: 30),
                    child: Obx(
                      () => ReuseTextField(
                        emailLabel: 'Enter Email',
                        emailLogin:
                            loginWidgetsHandlingcontroller.userEmail.value,
                        isObscure: false,
                        prefixIcon: const Icon(Icons.alternate_email),
                        suffixIcon: false,
                        onSuffixIconChange: false,
                      ),
                    )),
                Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: Obx(
                      () => ReuseTextField(
                        emailLabel: 'Enter Password',
                        emailLogin:
                            loginWidgetsHandlingcontroller.userPassword.value,
                        isObscure: loginWidgetsHandlingcontroller
                            .isObscureChange.value,
                        prefixIcon: const Icon(Icons.lock),
                        suffixIcon: true,
                        onSuffixIconChange: loginWidgetsHandlingcontroller
                            .isSuffixIconChange.value,
                        isSuffixChange: () {
                          loginWidgetsHandlingcontroller.isObscureChange.value =
                              !loginWidgetsHandlingcontroller
                                  .isObscureChange.value;
                          loginWidgetsHandlingcontroller
                                  .isSuffixIconChange.value =
                              !loginWidgetsHandlingcontroller
                                  .isSuffixIconChange.value;
                        },
                      ),
                    )),
                GestureDetector(
                  onTap: () {
                    // Navigator.of(context).push(MaterialPageRoute(builder: (context)=>
                    //       const ForgetPasswordView()));
                    Get.to(() => const ForgetPasswordView());
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(top: 15),
                    child: Text('Forget Password?',
                        style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w400, fontSize: 12)),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 25),
                  child: RoundedLoadingButton(
                    width: buttonwidth * 0.8,
                    color: const Color(0xff00C1AA),
                    controller: loginWidgetsHandlingcontroller.controller,
                    animateOnTap: true,
                    errorColor: Colors.red,
                    failedIcon: Icons.error,
                    onPressed: () async {
                      loginWidgetsHandlingcontroller.controller.start();
                      var connectivityResult =
                          await (Connectivity().checkConnectivity());

                      if (loginWidgetsHandlingcontroller
                              .userEmail.value.text.isEmpty ||
                          loginWidgetsHandlingcontroller
                              .userPassword.value.text.isEmpty) {
                        loginWidgetsHandlingcontroller.controller.stop();

                        Get.snackbar(
                            'Empty Credentials', 'Email or Passwod is Empty',
                            margin: const EdgeInsets.only(
                              bottom: 10,
                              left: 10,
                              right: 10,
                            ),
                            backgroundColor: Colors.red,
                            borderRadius: 12,
                            snackPosition: SnackPosition.BOTTOM);
                      } else if (connectivityResult ==
                          ConnectivityResult.none) {
                        loginWidgetsHandlingcontroller.controller.stop();
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
                      } else {
                        await FirebaseAuth.instance
                            .signInWithEmailAndPassword(
                                email: loginWidgetsHandlingcontroller
                                    .userEmail.value.text,
                                password: loginWidgetsHandlingcontroller
                                    .userPassword.value.text)
                            .then((value) {
                          Get.to(() => const HomeView());
                        }).onError((error, stackTrace) {
                          loginWidgetsHandlingcontroller.controller.stop();
                          print(error);
                          Get.snackbar('Login Error', error.toString(),
                              margin: const EdgeInsets.only(
                                bottom: 10,
                                left: 10,
                                right: 10,
                              ),
                              backgroundColor: Colors.red,
                              borderRadius: 12,
                              snackPosition: SnackPosition.BOTTOM);
                        });
                      }
                    },
                    child: Text(
                      'Login',
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
                      Text('Don\'t have an account?',
                          style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w400, fontSize: 12)),
                      GestureDetector(
                        onTap: () {
                          // Navigator.of(context).push(MaterialPageRoute(builder: (context)=>
                          // const RegisterView()));
                          Get.to(() => const RegisterView());
                        },
                        child: Text(' Register Account',
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
    );
  }
}
