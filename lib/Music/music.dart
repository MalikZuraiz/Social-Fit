import 'package:firebase_auth/firebase_auth.dart';
import 'package:social_fit/Music/music_provider.dart';
import 'package:social_fit/Music/songlist.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:provider/provider.dart';
import 'package:social_fit/chatbot/gemini_screen.dart';
import 'package:social_fit/meal_plan/homeformealandwater.dart';
import 'package:social_fit/posturefit/widgets/main_screen.dart';
import 'package:social_fit/social_module/auth/login_view.dart';

import 'playerview.dart';




import 'package:flutter_advanced_drawer/flutter_advanced_drawer.dart';


import 'package:fluentui_system_icons/fluentui_system_icons.dart';

import 'package:get/get.dart';

import 'package:social_fit/exercise/gym_visuals.dart';
import 'package:social_fit/home/landing/layout.dart';
import 'package:social_fit/settings/screens/account_screen.dart';
import 'package:social_fit/social_module/home/home_view.dart';
import 'package:social_fit/wrm/build_wrm_tab.dart';
import 'package:camera/camera.dart';

const apiKey = "AIzaSyAdOKrqXhf35Xy1aDPLRQuldLrnRINh_Sk";
// const apiKey = "AIzaSyAdOKrqXhf35Xy1aDPLRQuldLrnRINh_Sk";

List<CameraDescription>? cameras;

class Music extends StatefulWidget {
  const Music({super.key});

  @override
  State<Music> createState() => _AllSongsState();
}

class _AllSongsState extends State<Music> {
  bool isfirstime = true;
  final _advancedDrawerController = AdvancedDrawerController();

   @override
  Future<void> initState() async {
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
        child: Consumer<MusicProvider>(
          builder: (
            context,
            musicProvider,
            child,
          ) {
            return Scaffold(
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
              title: const Text('Music',
                  style: TextStyle(
                      fontFamily: 'Billabong',
                      fontWeight: FontWeight.bold,
                      fontSize: 32,
                      color: Color(0xff000221))),
              automaticallyImplyLeading: false,

              elevation: 0.0,
            ),
              floatingActionButton: FloatingActionButton(
                backgroundColor: Colors.blue,
                onPressed: () {
                  musicProvider.updateCurrentPlayingSongDetails(
                      musicProvider.currentindex);
                  musicProvider.changeplayervisibilty();
                },
                child: const Icon(Ionicons.musical_notes, color: Colors.white),
              ),

              //body part
              body: !musicProvider.hasPermission
                  ? Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Center(
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.blue,
                          ),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 35, vertical: 20),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Text(
                                "Application doesn't have access to the library\nClick Allow to Fetch songs",
                                style: TextStyle(color: Colors.white),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 10),
                              ElevatedButton(
                                  onPressed: () => musicProvider
                                      .checkAndRequestPermissions(),
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.white),
                                  child: const Text(
                                    "Allow",
                                    style: TextStyle(color: Colors.blue),
                                  )),
                            ],
                          ),
                        ),
                      ),
                    )
                  : FutureBuilder<List<SongModel>>(
                      future: musicProvider.audioQuery.querySongs(
                        sortType: SongSortType.TITLE,
                        orderType: OrderType.ASC_OR_SMALLER,
                        uriType: UriType.EXTERNAL,
                        ignoreCase: true,
                      ),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                              child: CircularProgressIndicator());
                        }

                        if (snapshot.error != null) {
                          return const Center(
                              child: Text('Error fetching songs'));
                        }

                        if (!snapshot.hasData || snapshot.data!.isEmpty) {
                          return const Center(child: Text('No Songs Found'));
                        }

                        musicProvider.songs = snapshot.data!;
                        return musicProvider.isplayervisible
                            ? BuildPlayerView(
                                musicProvider: musicProvider,
                              )
                            : BuildSonglistView(
                                musicProvider: musicProvider,
                              );
                      },
                    ),
            );
          },
        ));
        
  }
   void _handleMenuButtonPressed() {
    // NOTICE: Manage Advanced Drawer state through the Controller.
    // _advancedDrawerController.value = AdvancedDrawerValue.visible();
    _advancedDrawerController.showDrawer();
  }
}
