// ignore_for_file: no_leading_underscores_for_local_identifiers, avoid_print

import 'package:enefty_icons/enefty_icons.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter_advanced_drawer/flutter_advanced_drawer.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:social_fit/Music/music.dart';
import 'package:social_fit/chatbot/gemini_screen.dart';
import 'package:social_fit/meal_plan/homeformealandwater.dart';
import 'package:social_fit/posturefit/widgets/main_screen.dart';
import 'package:social_fit/settings/screens/contact_us.page.dart';
import 'package:social_fit/settings/screens/help_screen.dart';

import 'package:social_fit/settings/screens/notifications/notification_service.dart';
import 'package:social_fit/settings/screens/privacy_screen.dart';
import 'package:social_fit/settings/screens/terms.dart';

import 'package:social_fit/settings/widgets/setting_item.dart';
import 'package:social_fit/settings/widgets/setting_switch.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:social_fit/exercise/gym_visuals.dart';
import 'package:social_fit/social_module/auth/forgetpassword_view.dart';
import 'package:social_fit/social_module/auth/login_view.dart';
import 'package:social_fit/social_module/home/home_view.dart';
import 'package:social_fit/wrm/build_wrm_tab.dart';
import 'package:camera/camera.dart';

const apiKey = "AIzaSyAdOKrqXhf35Xy1aDPLRQuldLrnRINh_Sk";
// const apiKey = "AIzaSyAdOKrqXhf35Xy1aDPLRQuldLrnRINh_Sk";

List<CameraDescription>? cameras;

class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key});

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  bool isDarkMode = false;
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

    _loadNotificationSetting();
  }

  void deleteUser() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      try {
        await user.delete();
        Get.off(() => const LoginView());
        // User deleted successfully
        // You can also navigate to the login screen or perform other actions
      } catch (e) {
        // An error occurred while deleting the user
        print('Failed to delete user: $e');
      }
    }
  }

  bool _enableNotifications = false;
  final String _notificationKey = 'enableNotifications';

  

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
                    Get.off(() => const HomeView());
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
            title: const Text('Settings',
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
              padding: const EdgeInsets.all(30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // const Text(
                  //   "Account",
                  //   style: TextStyle(
                  //     fontSize: 24,
                  //     fontWeight: FontWeight.w500,
                  //   ),
                  // ),
                  // const SizedBox(height: 20),
                  // SizedBox(
                  //   width: double.infinity,
                  //   child: Row(
                  //     children: [
                  //       Image.asset("assets/avatar.png", width: 70, height: 70),
                  //       const SizedBox(width: 20),
                  //       const Column(
                  //         crossAxisAlignment: CrossAxisAlignment.start,
                  //         children: [
                  //           Text(
                  //             "Social Fit",
                  //             style: TextStyle(
                  //               fontSize: 18,
                  //               fontWeight: FontWeight.w500,
                  //             ),
                  //           ),
                  //           SizedBox(height: 10),
                  //           Text(
                  //             "Mirza Asjad Basharat",
                  //             style: TextStyle(
                  //               fontSize: 14,
                  //               color: Colors.grey,
                  //             ),
                  //           )
                  //         ],
                  //       ),
                  //       const Spacer(),
                  //       ForwardButton(
                  //         onTap: () {
                  //           Navigator.push(
                  //             context,
                  //             MaterialPageRoute(
                  //               builder: (context) => const EditAccountScreen(),
                  //             ),
                  //           );
                  //         },
                  //       )
                  //     ],
                  //   ),
                  // ),
                  // const SizedBox(height: 40),
                  // const Text(
                  //   "Settings",
                  //   style: TextStyle(
                  //     fontSize: 24,
                  //     fontWeight: FontWeight.w500,
                  //   ),
                  // ),
                  // const SizedBox(height: 20),
                  // SettingItem(
                  //   title: "Language",
                  //   icon: Ionicons.earth,
                  //   bgColor: Colors.orange.shade100,
                  //   iconColor: Colors.orange,
                  //   value: "English",
                  //   onTap: () {},
                  // ),
                  // const SizedBox(height: 20),
                  // SettingItem(
                  //   title: "Notifications",
                  //   icon: Ionicons.notifications,
                  //   bgColor: Colors.blue.shade100,
                  //   iconColor: Colors.blue,
                  //   onTap: () {},
                  // ),
                  // const SizedBox(height: 20),
                  SettingSwitch(
                      title: "Notifications",
                      icon: Ionicons.notifications,
                      bgColor: Colors.purple.shade100,
                      iconColor: Colors.purple,
                      value: _enableNotifications,
                      onTap: _onChangedSwitchNotifications),
                  const SizedBox(height: 20),
                  SettingItem(
                    title: "Help",
                    icon: Ionicons.nuclear,
                    bgColor: Colors.red.shade100,
                    iconColor: Colors.red,
                    onTap: () {
                      Get.to(() => const HelpPage());
                    },
                  ),
                  const SizedBox(height: 20),
                  SettingItem(
                    title: "Delete Account",
                    icon: Ionicons.close_sharp,
                    bgColor: Colors.orange.shade100, // Change to desired color
                    iconColor: Colors.red,
                    onTap: () {
                      showOptionsforDelete();
                    },
                  ),
                  const SizedBox(height: 20),
                  SettingItem(
                    title: "Change Password",
                    icon: Ionicons.lock_closed,
                    bgColor: Colors.blue.shade100, // Change to desired color
                    iconColor: Colors.orange,
                    onTap: () {
                      Get.to(() => const ForgetPasswordView());
                    },
                  ),
                  const SizedBox(height: 20),
                  SettingItem(
                    title: "Privacy",
                    icon: Ionicons.person_remove_outline,
                    bgColor: Colors.green.shade100, // Change to desired color
                    iconColor: Colors.orange,
                    onTap: () {
                      Get.to(() => const PrivacyPolicyPage());
                    },
                  ),
                  const SizedBox(height: 20),
                  SettingItem(
                    title: "Terms & Conditions",
                    icon: Ionicons.book,
                    bgColor: Colors.purple.shade100, // Change to desired color
                    iconColor: Colors.orange,
                    onTap: () {
                      Get.to(() => const TermsAndConditionsPage());
                    },
                  ),
                  const SizedBox(height: 20),
                  SettingItem(
                    title: "Contact Us",
                    icon: Ionicons.call,
                    bgColor: Colors.yellow.shade100, // Change to desired color
                    iconColor: Colors.orange,
                    onTap: () {
                      Get.to(() => const ContactUsPage());
                    },
                  ),
                  const SizedBox(height: 20),
                  SettingItem(
                    title: "Logout",
                    icon: Ionicons.log_out,
                    bgColor: Colors.red.shade100, // Change to desired color
                    iconColor: Colors.red,
                    onTap: () {
                      showOptions();
                    },
                  ),
                ],
              ),
            ),
          ),
        ));
  }

  void showOptions() {
    showModalBottomSheet(
      backgroundColor: const Color(0xffE7E7F2),
      context: context,
      builder: (BuildContext context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ListTile(
              leading: const Icon(
                EneftyIcons.logout_2_outline,
                color: Colors.red,
              ),
              title: Text(
                'Logout',
                style: GoogleFonts.poppins(fontSize: 16, color: Colors.red),
              ),
              onTap: () {
                Navigator.pop(context);
                _logout();
              },
            ),
            ListTile(
              leading: const Icon(
                EneftyIcons.close_outline,
                color: Colors.red,
              ),
              title: Text(
                'Cancel',
                style: GoogleFonts.poppins(
                  fontSize: 16,
                ),
              ),
              onTap: () {
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  void showOptionsforDelete() {
    showModalBottomSheet(
      backgroundColor: const Color(0xffE7E7F2),
      context: context,
      builder: (BuildContext context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 4, left: 15),
              child: Text('Are You Sure ? ',
                  style: GoogleFonts.poppins(
                      fontSize: 20, fontWeight: FontWeight.bold)),
            ),
            ListTile(
              leading: const Icon(
                EneftyIcons.profile_delete_bold,
                color: Colors.red,
              ),
              title: Text(
                'Delete',
                style: GoogleFonts.poppins(fontSize: 16, color: Colors.red),
              ),
              onTap: () {
                Navigator.pop(context);
                deleteUser();
              },
            ),
            ListTile(
              leading: const Icon(
                EneftyIcons.close_outline,
                color: Colors.red,
              ),
              title: Text(
                'Cancel',
                style: GoogleFonts.poppins(
                  fontSize: 16,
                ),
              ),
              onTap: () {
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  void _onChangedSwitchNotifications(bool newValue) {
    setState(() {
      _enableNotifications = newValue;
      _saveNotificationSetting(newValue); // Save the state to SharedPreferences

      if (_enableNotifications) {
        // Invoke the asynchronous function

        _repeatNotification();
      }
    });
  }

  Future<void> _repeatNotification() async {
    await NotificationService.repeatNotification(
      title: "Fit Social App",
      body: "Exercise and Get Muscules Now !",
    );
  }

  // Load the notification setting from SharedPreferences
  Future<void> _loadNotificationSetting() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _enableNotifications = prefs.getBool(_notificationKey) ?? false;
    });
  }

  // Save the notification setting to SharedPreferences
  Future<void> _saveNotificationSetting(bool value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool(_notificationKey, value);
  }

  void _handleMenuButtonPressed() {
    // NOTICE: Manage Advanced Drawer state through the Controller.
    // _advancedDrawerController.value = AdvancedDrawerValue.visible();
    _advancedDrawerController.showDrawer();
  }
}
