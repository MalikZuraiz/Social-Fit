// ignore_for_file: avoid_unnecessary_containers, duplicate_import, avoid_print


import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:camera/camera.dart';
import 'package:flutter_advanced_drawer/flutter_advanced_drawer.dart';
import 'package:get/get.dart';

import 'package:social_fit/Music/music.dart';
import 'package:social_fit/chatbot/gemini_screen.dart';
import 'package:social_fit/exercise/gym_visuals.dart';
import 'package:social_fit/home/landing/layout.dart';
import 'package:social_fit/meal_plan/meal/meal_plan.dart';
import 'package:social_fit/settings/screens/account_screen.dart';
import 'package:social_fit/social_module/auth/login_view.dart';
import 'package:social_fit/social_module/home/home_view.dart';
import 'package:social_fit/wrm/build_wrm_tab.dart';
import 'pushed_pageA.dart';
import 'pushed_pageS.dart';
import 'pushed_pageY.dart';

List<CameraDescription>? cameras;


class MainScreen extends StatefulWidget {
  final List<CameraDescription> cameras;
  const MainScreen(this.cameras, {super.key});
  

  static const String id = 'main_screen';

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
    final _advancedDrawerController = AdvancedDrawerController();


    @override
  void initState() async {
    
    super.initState();
    try {
      cameras = await availableCameras();
    } on Exception catch (e) {
      print('Error: $e.code\nError Message: $e.message');
    }
  }


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
  Widget build(BuildContext context) {
    // ignore: unused_local_variable
    Size screen = MediaQuery.of(context).size;
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
                    Get.off(() => const MealPlan());
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
            title: const Text('Fit Posture',
                style: TextStyle(
                    fontFamily: 'Billabong',
                    fontWeight: FontWeight.bold,
                    fontSize: 32,
                    color: Color(0xff000221))),
            automaticallyImplyLeading: false,
            elevation: 0.0,
          ),
          // appBar: AppBar(
          //   title: Text('Align.AI'),
          //   backgroundColor: Colors.blueAccent,
          // ),
          body: SingleChildScrollView(
            child: Column(
              //mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 50),
                Container(
                  padding: const EdgeInsets.only(left: 16.0, right: 16.0),
                  child: const Text(
                    'Fit Posture',
                    style: TextStyle(
                      color: Color(0xFFFE7C7C),
                      fontWeight: FontWeight.bold,
                      fontSize: 28.0,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.only(left: 16.0, right: 16.0),
                  child: const Text(
                    'Master Your Body Alignment',
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w400,
                      fontSize: 18.0,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Image.asset('images/align.PNG'),
                const SizedBox(height: 10),
                // Container(
                //   padding: const EdgeInsets.only(left: 16.0, right: 16.0),
                //   child: SizedBox(
                //     child: asd.SearchBar('What pose do you wish to align?'),
                //   ),
                // ),
                const SizedBox(height: 20),
                Container(
                  padding: const EdgeInsets.only(left: 16.0, right: 16.0),
                  child: const Text(
                    'Select the Exercise',
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w600,
                      fontSize: 24.0,
                    ),
                  ),
                ),

                // Container(
                //   padding: const EdgeInsets.symmetric(horizontal: 16.0),
                //   child: VerticalCardPager(
                //     textStyle: const TextStyle(color: Colors.black),
                //     titles: const ['Arm Press', 'Squat', 'Yoga'],
                //     align: ALIGN.CENTER,
                //     initialPage: 0,
                //     images: [
                //       Image.asset('images/arm_press.PNG', fit: BoxFit.cover),
                //       Image.asset('images/squat.PNG', fit: BoxFit.cover),
                //       Image.asset('images/yoga4.PNG', fit: BoxFit.cover),
                //     ],
                //     onPageChanged: (page) {
                //       if (page == 0) {
                //         onSelectA(context: context, modelName: 'posenet');
                //       } else if (page == 1) {
                //         onSelectS(context: context, modelName: 'posenet');
                //       } else if (page == 2) {
                //         onSelectY(context: context, modelName: 'posenet');
                //       }
                //     },
                //   ),
                // ),

                Container(
                  child: SizedBox(
                    height: 150,
                    child: ListView(
                      padding: const EdgeInsets.symmetric(vertical: 5.0),
                      scrollDirection: Axis.horizontal,
                      children: [
                        Stack(
                          children: <Widget>[
                            Container(
                              width: 140,
                              height: 140,
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10.0),
                              child: ElevatedButton(
                                child: Container(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Image.asset('images/arm_press.PNG')),
                                onPressed: () => onSelectA(
                                    context: context, modelName: 'posenet'),
                              ),
                            ),
                          ],
                        ),
                        Stack(
                          children: <Widget>[
                            Container(
                              width: 140,
                              height: 140,
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10.0),
                              child: ElevatedButton(
                                child: Container(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Image.asset('images/squat.PNG')),
                                onPressed: () => onSelectS(
                                    context: context, modelName: 'posenet'),
                              ),
                            ),
                          ],
                        ),
                        Stack(
                          children: <Widget>[
                            Container(
                              width: 140,
                              height: 140,
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10.0),
                              child: ElevatedButton(
                                child: Container(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Image.asset('images/yoga4.PNG')),
                                onPressed: () => onSelectY(
                                    context: context, modelName: 'posenet'),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

                // Container(
                //   child: RaisedButton(
                //     child: Text('Pose Estimation'),
                //     onPressed: () =>
                //         onSelectY(context: context, modelName: 'posenet'),
                //   ),
                // ),
              ],
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





void onSelectA(
    {required BuildContext context, required String modelName}) async {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => PushedPageA(
        cameras: cameras!,
        title: modelName,
      ),
    ),
  );
}

void onSelectS(
    {required BuildContext context, required String modelName}) async {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => PushedPageS(
        cameras: cameras!,
        title: modelName,
      ),
    ),
  );
}

void onSelectY({BuildContext? context, String? modelName}) async {
  Navigator.push(
    context!,
    MaterialPageRoute(
      builder: (context) => PushedPageY(
        cameras: cameras!,
        title: modelName!,
      ),
    ),
  );
}
