// ignore_for_file: use_build_context_synchronously, duplicate_ignore

import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_advanced_drawer/flutter_advanced_drawer.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:lottie/lottie.dart';
import 'package:social_fit/Music/music.dart';
import 'package:social_fit/chatbot/gemini_screen.dart';
import 'package:social_fit/exercise/gym_visuals.dart';
import 'package:social_fit/home/landing/layout.dart';
import 'package:social_fit/meal_plan/homeformealandwater.dart';
import 'package:social_fit/posturefit/widgets/main_screen.dart';
import 'package:social_fit/settings/screens/account_screen.dart';
import 'package:social_fit/social_module/auth/login_view.dart';
import 'package:social_fit/social_module/home/home_view.dart';
import 'package:social_fit/wrm/recommend.dart';
import 'package:camera/camera.dart';

const apiKey = "AIzaSyAdOKrqXhf35Xy1aDPLRQuldLrnRINh_Sk";
// const apiKey = "AIzaSyAdOKrqXhf35Xy1aDPLRQuldLrnRINh_Sk";

List<CameraDescription>? cameras;

class WrmTab extends StatefulWidget {
  const WrmTab({super.key});

  @override
  State<WrmTab> createState() => _WrmTabState();
}

class _WrmTabState extends State<WrmTab> {
  String url = '';
  var data = '';
  bool dataFetching = false;
  String query = '';
  final _advancedDrawerController = AdvancedDrawerController();

  Future<void> _logout() async {
    try {
      if (FirebaseAuth.instance.currentUser != null) {
        await FirebaseAuth.instance.signOut();
        Get.off(() => const LoginView());
      } else {
        // No user is currently signed in
      }
    } catch (e) {
      // Handle logout errors
    }
  }


  @override
  Future<void> initState() async {
    super.initState();
     try {
      cameras = await availableCameras();
    } on Exception catch (e) {
      print('Error: $e.code\nError Message: $e.message');
    }    
  }

  @override
  Widget build(BuildContext context) {
    return AdvancedDrawer(
        backdrop: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Colors.blueGrey, Colors.blueGrey.withOpacity(0.2)],
            ),
          ),
        ),
        controller: _advancedDrawerController,
        animationCurve: Curves.easeInOut,
        animationDuration: const Duration(milliseconds: 300),
        animateChildDecoration: true,
        rtlOpening: false,
        // openScale: 1.0,
        disabledGestures: false,
        childDecoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(16)),
        ),
        drawer: SafeArea(
          child: ListTileTheme(
            textColor: Colors.white,
            iconColor: Colors.white,
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                Container(
                  width: 128.0,
                  height: 128.0,
                  margin: const EdgeInsets.only(
                    top: 24.0,
                    bottom: 64.0,
                  ),
                  clipBehavior: Clip.antiAlias,
                  decoration: const BoxDecoration(
                    color: Colors.black26,
                    shape: BoxShape.circle,
                  ),
                  child: Image.asset(
                    'assets/profile.png',
                  ),
                ),
                ListTile(
                  onTap: () {
                    Get.off(() => const LayoutLanding());
                  },
                  leading: const Icon(FluentIcons.home_32_filled),
                  title: const Text('Home'),
                ),
                ListTile(
                  onTap: () {
                    Get.off(() => const HomeView());
                  },
                  leading: const Icon(FluentIcons.people_32_filled),
                  title: const Text('Fit Connect'),
                ),
                ListTile(
                  onTap: () {
                    Get.off(() => MainScreen(cameras!));
                  },
                  leading: const Icon(FluentIcons.dumbbell_28_filled),
                  title: const Text('Fit Posture'),
                ),
                ListTile(
                  onTap: () {
                    Get.off(() => const GeminiBot());
                  },
                  leading: const Icon(FluentIcons.check_24_filled),
                  title: const Text('Fit Query'),
                ),
                ListTile(
                  onTap: () {
                    Get.off(() => const GymVisuals());
                  },
                  leading: const Icon(FluentIcons.play_32_filled),
                  title: const Text('Gym Visuals'),
                ),
                ListTile(
                  onTap: () {
                    Get.off(() => const WrmTab());
                  },
                  leading: const Icon(FluentIcons.receipt_32_filled),
                  title: const Text('Recommender'),
                ),
                ListTile(
                  onTap: () {
                    Get.off(() => const LandingPage());
                  },
                  leading: const Icon(FluentIcons.food_24_filled),
                  title: const Text('Meal Tracker'),
                ),
                ListTile(
                  onTap: () {
                    Get.off(() => const Music());
                  },
                  leading: const Icon(FluentIcons.music_note_2_20_filled),
                  title: const Text('Music'),
                ),
                ListTile(
                  onTap: () {
                    Get.off(() => const AccountScreen());
                  },
                  leading: const Icon(FluentIcons.settings_48_filled),
                  title: const Text('Settings'),
                ),
                const Spacer(),
                DefaultTextStyle(
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.white54,
                  ),
                  child: Container(
                    margin: const EdgeInsets.symmetric(
                      vertical: 16.0,
                    ),
                    child: ListTile(
                      onTap: () => _logout(),
                      leading: const Icon(
                        FluentIcons.sign_out_24_filled,
                        color: Colors.red,
                      ),
                      title: const Text('Logout'),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: Colors.white,
          appBar: AppBar(
            leading: IconButton(
              onPressed: _handleMenuButtonPressed,
              icon: ValueListenableBuilder<AdvancedDrawerValue>(
                valueListenable: _advancedDrawerController,
                builder: (_, value, __) {
                  return AnimatedSwitcher(
                    duration: const Duration(milliseconds: 250),
                    child: Icon(
                      value.visible ? Icons.clear : Icons.menu,
                      key: ValueKey<bool>(value.visible),
                    ),
                  );
                },
              ),
            ),
            // backgroundColor: const Color(0xff000221),
            title: const Text('Fit Query',
                style: TextStyle(
                    fontFamily: 'Billabong',
                    fontWeight: FontWeight.bold,
                    fontSize: 32,
                    color: Color(0xff000221))),
            automaticallyImplyLeading: false,

            elevation: 0.0,
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.only(left: 40.0, right: 40.0),
              child: Column(
                children: [
                  const SizedBox(height: 30),
                  const Text(
                    'Welcome To AI-Powered WRM',
                    style: TextStyle(fontSize: 20, fontStyle: FontStyle.italic),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 50),
                  Center(
                    child: Lottie.asset('animations/api.json',
                        width: 250, height: 200),
                  ),
                  const SizedBox(height: 40),
                  TextFormField(
                    decoration: const InputDecoration(
                      border: UnderlineInputBorder(),
                      labelText: 'Enter Your Query',
                    ),
                    onChanged: (value) {
                      query = value;
                    },
                  ),
                  const SizedBox(height: 4),
                  ElevatedButton(
                    onPressed: () async {
                      if (query.isEmpty) {
                        Fluttertoast.showToast(
                          msg: 'Empty Query',
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.BOTTOM,
                          timeInSecForIosWeb: 1,
                          backgroundColor: Colors.blue,
                          textColor: Colors.white,
                        );
                        return;
                      }

                      url = 'https://wrs.pythonanywhere.com/api?query=$query';
                      setState(() {
                        dataFetching =
                            true; // Show circular progress indicator when pressed
                      });

                      http.Response response = await http.get(Uri.parse(url));
                      setState(() {
                        dataFetching =
                            false; // Hide circular progress indicator after fetching
                      });
                      String data = response.body;
                      final responseData = json.decode(data);
                      if (response.statusCode == 200) {
                        if (responseData is Map &&
                            responseData.containsKey('error')) {
                          // Show toast for "Irrelevant Query"
                          Fluttertoast.showToast(
                            msg: 'Irrelevant / Invalid Query',
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.BOTTOM,
                            timeInSecForIosWeb: 1,
                            backgroundColor: Colors.blue,
                            textColor: Colors.white,
                          );
                        } else if (responseData is List) {
                          // Navigate to the second screen
                          // ignore: use_build_context_synchronously
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ExerciseScreen(data: data),
                            ),
                          );
                        } else {
                          // Handle unexpected response format
                          Fluttertoast.showToast(
                            msg: 'Unexpected response format from the server',
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.CENTER,
                            timeInSecForIosWeb: 1,
                            backgroundColor: Colors.blue,
                            textColor: Colors.white,
                          );
                        }
                      } else {
                        // Handle HTTP errors here
                        Fluttertoast.showToast(
                          msg: 'Error: Might Be Connection Issue',
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.CENTER,
                          timeInSecForIosWeb: 1,
                          backgroundColor: Colors.blue,
                          textColor: Colors.white,
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors
                          .blue, // Change this color to the desired background color
                    ),
                    child: const Text(
                      'Fetch',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  if (dataFetching)
                    const CircularProgressIndicator(color: Colors.blue),
                ],
              ),
            ),
          ),
        ));
  }

  void _handleMenuButtonPressed() {
    // NOTICE: Manage Advanced Drawer state through the Controller.
    // _advancedDrawerController.value = AdvancedDrawerValue.visible();
    _advancedDrawerController.showDrawer();
  }
}
