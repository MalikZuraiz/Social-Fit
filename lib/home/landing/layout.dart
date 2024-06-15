import 'dart:async';

import 'package:action_slider/action_slider.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_advanced_drawer/flutter_advanced_drawer.dart';
import 'package:social_fit/Music/music.dart';
import 'package:social_fit/chatbot/gemini_screen.dart';
import 'package:social_fit/home/activity/choice.dart';
import 'package:social_fit/home/database.dart' as db;
import 'package:social_fit/home/excercise.dart';
import 'package:social_fit/home/landing/calories.dart';
import 'package:social_fit/home/landing/charts.dart';
import 'package:social_fit/home/landing/goals.dart';
import 'package:social_fit/home/landing/profiling.dart';
import 'package:social_fit/home/landing/recent.dart';
import 'package:social_fit/home/landing/schedule.dart';
import 'package:social_fit/home/landing/steps.dart';
import 'package:social_fit/home/session.dart' as s;
import 'package:health/health.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:get/get.dart';
import 'package:social_fit/exercise/gym_visuals.dart';
import 'package:social_fit/meal_plan/homeformealandwater.dart';
import 'package:social_fit/posturefit/widgets/main_screen.dart';
import 'package:social_fit/settings/screens/account_screen.dart';
import 'package:social_fit/social_module/auth/login_view.dart';
import 'package:social_fit/social_module/home/home_view.dart';
import 'package:social_fit/wrm/build_wrm_tab.dart';

import '../database.dart';
import 'package:social_fit/main.dart';
import 'daily.dart';


import 'package:camera/camera.dart';

const apiKey = "AIzaSyAdOKrqXhf35Xy1aDPLRQuldLrnRINh_Sk";
// const apiKey = "AIzaSyAdOKrqXhf35Xy1aDPLRQuldLrnRINh_Sk";

List<CameraDescription>? cameras;

const types = [
  HealthDataType.STEPS,
  HealthDataType.ACTIVE_ENERGY_BURNED,
  HealthDataType.MOVE_MINUTES,
  HealthDataType.DISTANCE_DELTA,
  HealthDataType.WORKOUT
];
const permissions = [
  HealthDataAccess.READ_WRITE,
  HealthDataAccess.READ_WRITE,
  HealthDataAccess.READ_WRITE,
  HealthDataAccess.READ_WRITE,
  HealthDataAccess.READ_WRITE,
];

class LayoutLanding extends StatefulWidget {
  const LayoutLanding({super.key});

  @override
  State<LayoutLanding> createState() => _LayoutLandingState();
  static const routeName = '/home';
}

class SessionReturned {
  final OnGoingSession? onGoingSession;
  final Session? session;
  final bool finished;
  SessionReturned(
      {required this.onGoingSession,
      required this.session,
      required this.finished});
}

class OnGoingSession {
  final DateTime startTime;
  final Duration duration;
  final List<ExcerciseInfo> excerciseInfo;
  final List<String> selectedBodyParts;
  OnGoingSession(
      {required this.startTime,
      required this.duration,
      required this.excerciseInfo,
      required this.selectedBodyParts});
}

class _LayoutLandingState extends State<LayoutLanding> {
  List<Session> sessionsCurrent = [];
  HealthFactory? health;
  bool refresh = false;
  OnGoingSession? onGoingSession;
  final DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
  @override
  Future<void> initState() async {
    super.initState();
    setState(() {
      sessionsCurrent = sessions;
    });
    requestPermissions();

     try {
      cameras = await availableCameras();
    } on Exception catch (e) {
      print('Error: $e.code\nError Message: $e.message');
    }
  }

  void requestPermissions() async {
    if (defaultTargetPlatform == TargetPlatform.android) {
      final androidInfo = await deviceInfo.androidInfo;
      if (!androidInfo.isPhysicalDevice) return;
    }
    HealthFactory h = HealthFactory(useHealthConnectIfAvailable: true);
    await Permission.activityRecognition.request();
    await Permission.location.request();
    await Permission.notification.request();
    await h.requestAuthorization(types);
    await h.requestAuthorization(types, permissions: permissions);
    setState(() {
      health = h;
    });
  }

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
            title: const Text('Home',
                style: TextStyle(
                    fontFamily: 'Billabong',
                    fontWeight: FontWeight.bold,
                    fontSize: 32,
                    color: Color(0xff000221))),
            automaticallyImplyLeading: false,
            elevation: 0.0,
          ),
          backgroundColor: Colors.white,
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerDocked,
          floatingActionButton: onGoingSession != null
              ? Padding(
                  padding: const EdgeInsets.only(bottom: 32),
                  child: ActionSlider.dual(
                    borderWidth: 0,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset:
                            const Offset(0, 3), // changes position of shadow
                      ),
                    ],
                    actionThresholdType: ThresholdType.release,
                    backgroundBorderRadius: BorderRadius.circular(10.0),
                    foregroundBorderRadius: BorderRadius.circular(10.0),
                    width: MediaQuery.of(context).size.width * 0.6,
                    toggleColor: Colors.blue,
                    backgroundColor: Colors.white,
                    startChild: const Text('Stop',
                        style: TextStyle(fontWeight: FontWeight.w700)),
                    endChild: const Text('Continue',
                        style: TextStyle(fontWeight: FontWeight.w700)),
                    successIcon: const Icon(Icons.check, color: Colors.white),
                    failureIcon: const Icon(Icons.close, color: Colors.white),
                    icon: Padding(
                      padding: const EdgeInsets.only(right: 0.0),
                      child: Transform.rotate(
                          angle: 0.5 * 3.14,
                          child: const Icon(Icons.stop,
                              color: Colors.white, size: 18.0)),
                    ),
                    startAction: (controller) async {
                      controller.success(); //starts success animation
                      await Future.delayed(const Duration(seconds: 1));
                      setState(() {
                        onGoingSession = null;
                      });
                      controller.reset();
                    },
                    endAction: (controller) async {
                      controller.success(); //starts success animation
                      await Future.delayed(const Duration(seconds: 1));
                      // ignore: use_build_context_synchronously
                      Navigator.push(context, CupertinoPageRoute(
                        builder: (context) {
                          return s.Session(
                              selectedBodyParts: const [],
                              onGoingSession: onGoingSession);
                        },
                      )).then(handleSessionReturn);
                      controller.reset();
                    },
                  ),
                )
              : Container(),
          body: RefreshIndicator(
            onRefresh: () async {
              List<Session> li = await Session.sessions();
              setState(() {
                refresh = !refresh;
                if (li.isEmpty) {
                  sessionsCurrent = [];
                  sessions = [];
                  return;
                }
                if ((li.length > sessionsCurrent.length) ||
                    li.length > sessions.length) {
                  sessionsCurrent = li;
                  sessions = li;
                  return;
                }
                sessionsCurrent.setAll(0, li);
                sessions.setAll(0, li);
              });
              return Future.value();
            },
            child: Center(
                child: Stack(
              children: [
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
                  child: ListView(
                    cacheExtent: 2700,
                    addAutomaticKeepAlives: true,
                    scrollDirection: Axis.vertical,
                    children: [
                      ProfilingWidget(
                          sessionsCurrent: sessionsCurrent, health: health),
                      const SizedBox(
                        height: 30,
                      ),
                      RecentWorkouts(
                        sessionsCurrent: sessionsCurrent,
                        refresh: () {
                          setState(() {
                            refresh = !refresh;
                          });
                        },
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Button(
                          enabled: onGoingSession == null,
                          title: 'Start Workout',
                          clickHandler: () {
                            Navigator.push(
                              context,
                              CupertinoPageRoute(
                                  fullscreenDialog: true,
                                  builder: (context) => const WorkoutChoice()),
                            ).then(handleSessionReturn);
                          }),
                      const SizedBox(
                        height: 40,
                      ),
                      DailyStats(
                        health: health,
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      SparkWidget(refresh: refresh),
                      const SizedBox(
                        height: 20,
                      ),
                      WorkoutGoals(
                        health: health,
                        refresh: () {
                          setState(() {
                            refresh = !refresh;
                          });
                        },
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Button(
                          enabled: onGoingSession == null,
                          title: 'Add Goals',
                          clickHandler: () {
                            Navigator.push(
                              context,
                              CupertinoPageRoute(
                                  builder: (context) => GoalCreation(
                                        refresh: () {
                                          setState(() {
                                            refresh = !refresh;
                                          });
                                        },
                                      )),
                            );
                          }),
                      const SizedBox(
                        height: 40,
                      ),
                      StepsSparkLine(
                        health: health,
                      ),
                      const SizedBox(
                        height: 40,
                      ),
                      const Schedule(),
                      const SizedBox(
                        height: 40,
                      ),
                      CaloriesChart(health: health),
                      WorkoutsChart(refresh: refresh),
                      const SizedBox(
                        height: 40,
                      ),
                      ExcercisesChart(refresh: refresh),
                      const SizedBox(
                        height: 50,
                      ),
                    ],
                  ),
                ),
              ],
            )),
          ),
        ));
  }

  void _handleMenuButtonPressed() {
    // NOTICE: Manage Advanced Drawer state through the Controller.
    // _advancedDrawerController.value = AdvancedDrawerValue.visible();
    _advancedDrawerController.showDrawer();
  }

  void handleSessionReturn(dynamic sessionInfo) {
    if (sessionInfo == null) return;
    SessionReturned info = sessionInfo as SessionReturned;
    if (!(info.finished)) {
      if (info.onGoingSession == null) return;
      setState(() {
        onGoingSession = info.onGoingSession as OnGoingSession;
      });
      return;
    }
    if (info.session == null) return;
    setState(() {
      onGoingSession = null;
      db.Session.insertSession(info.session!);
      sessions.insert(0, info.session!);
      refresh = !refresh;
    });
  }
}

class Button extends StatelessWidget {
  const Button(
      {super.key,
      required this.title,
      required this.clickHandler,
      required this.enabled});
  final String title;
  final bool enabled;
  final Function clickHandler;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: 50,
      child: ElevatedButton(
          style: ButtonStyle(
            elevation: MaterialStateProperty.all<double>(3),
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                    side: const BorderSide(color: Colors.blue))),
            backgroundColor: MaterialStateProperty.all<Color>(Colors.blue),
          ),
          onPressed: () {
            if (!enabled) return;
            clickHandler();
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              const SizedBox(
                width: 10,
              ),
              Text(title,
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold)),
              const Icon(Icons.arrow_right_alt_outlined,
                  color: Colors.white, size: 32)
            ],
          )),
    );
  }
}
