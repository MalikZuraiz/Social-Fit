// ignore_for_file: must_be_immutable, avoid_print, no_leading_underscores_for_local_identifiers

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:enefty_icons/enefty_icons.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_advanced_drawer/flutter_advanced_drawer.dart';

import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:social_fit/Music/music.dart';
import 'package:social_fit/chatbot/gemini_screen.dart';
import 'package:social_fit/exercise/gym_visuals.dart';
import 'package:social_fit/home/landing/layout.dart';
import 'package:social_fit/meal_plan/homeformealandwater.dart';
import 'package:social_fit/posturefit/widgets/main_screen.dart';
import 'package:social_fit/settings/screens/account_screen.dart';
import 'package:social_fit/social_module/auth/login_view.dart';


import 'package:social_fit/social_module/chat/all_users.dart';

import 'package:social_fit/social_module/post/post_wall.dart';
import 'package:social_fit/social_module/profile/profile_view.dart';
import 'package:social_fit/social_module/widgets/post_card.dart';
import 'package:social_fit/wrm/build_wrm_tab.dart';
import 'package:camera/camera.dart';

const apiKey = "AIzaSyAdOKrqXhf35Xy1aDPLRQuldLrnRINh_Sk";
// const apiKey = "AIzaSyAdOKrqXhf35Xy1aDPLRQuldLrnRINh_Sk";

List<CameraDescription>? cameras;

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  String? imageUrl;
  String? userBio;
  String? userName;
  int? userPosts;
  int? userFriends;
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
    updateLastSeen();
  }

  void updateLastSeen() async {
    var user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      var userRef =
          FirebaseFirestore.instance.collection('Users').doc(user.email);
      await userRef.update({'lastSeen': FieldValue.serverTimestamp()});
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
          // backgroundColor: Colors.grey[400],
          resizeToAvoidBottomInset: false,

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
              title: const Text('Social Fit',
                  style: TextStyle(
                      fontFamily: 'Billabong',
                      fontWeight: FontWeight.bold,
                      fontSize: 32,
                      color: Color(0xff000221))),
              automaticallyImplyLeading: false,
              actions: [
                IconButton(
                    onPressed: () {
                      Get.to(() => const AllUsers());
                    },
                    icon: const Icon(
                      FluentIcons.chat_32_filled,
                      color: Colors.black,
                    )),
                FutureBuilder<Map<String, dynamic>>(
                    future: getUserDataFromFirestore(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Padding(
                          padding: EdgeInsets.all(4.0),
                          child: CircleAvatar(
                            radius: 12,
                            backgroundColor: Color(0xff000221),
                            child: Icon(Icons.person,
                                color: Colors.white), // Placeholder color
                          ),
                        );
                      } else if (snapshot.hasError) {
                        return const Icon(Icons.error);
                      } else {
                        final data = snapshot.data;
                        imageUrl = data?['userImage'];
                        userName = data?['username'];
                        userBio = data?['bio'];
                        userPosts = data?['totalPosts'];
                        userFriends = data?['totalFriends'];
                        if (imageUrl != null && imageUrl!.isNotEmpty) {
                          return Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: GestureDetector(
                              onTap: () {
                                Get.to(() => ProfileView(
                                      userPosts: userPosts ?? 0,
                                      userfriends: userFriends ?? 0,
                                    ));
                              },
                              child: CircleAvatar(
                                radius: 12,
                                backgroundImage: NetworkImage(imageUrl!),
                              ),
                            ),
                          );
                        } else {
                          return Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: GestureDetector(
                              onTap: () {
                                Get.to(() => ProfileView(
                                      userPosts: userPosts ?? 0,
                                      userfriends: userFriends ?? 0,
                                    ));
                              },
                              child: const CircleAvatar(
                                backgroundColor: Color(0xff000221),
                                child: Icon(Icons.person,
                                    color: Colors.white), // Placeholder color
                              ),
                            ),
                          );
                        }
                      }
                    }),
                // IconButton(
                //     onPressed: _logout,
                //     icon: const Icon(
                //       EneftyIcons.logout_outline,
                //       color: Colors.white,
                //     )),
              ]

              // leading: IconButton(
              //     onPressed: () {
              //       Get.to(() => ProfileView());
              //     },
              //     icon: const Icon(
              //       Icons.person,
              //       color: Colors.white,
              //     )),
              // actions: [
              //   IconButton(
              //       onPressed: () {
              //         Get.to(()=> const AllUsers());
              //       },
              //       icon: const Icon(
              //         Icons.messenger,
              //         color: Colors.white,
              //       )),
              //   IconButton(
              //       onPressed: () {
              //         FirebaseAuth.instance.signOut().then((value) {
              //           Get.to(() => const LoginView());
              //         });
              //       },
              //       icon: const Icon(
              //         Icons.logout_rounded,
              //         color: Colors.white,
              //       ))
              // ],
              ),
          floatingActionButton: FloatingActionButton(
            // backgroundColor: const Color.fromARGB(255, 30, 32, 69),
            backgroundColor: Colors.transparent,
            elevation: 0,
            onPressed: () {
              Get.to(() => MyPostView(
                    imageURL: imageUrl!,
                    userBio: userBio!,
                    userName: userName!,
                  ));
            },
            child: const Icon(
              EneftyIcons.additem_bold,
              color: Colors.black,
            ),
          ),
          body: Center(
            child: Column(
              children: [
                Expanded(
                  child: StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection('User Posts')
                        .orderBy('TimeStamp', descending: true)
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return ListView.builder(
                            itemCount: snapshot.data!.docs.length,
                            itemBuilder: (context, index) {
                              final post = snapshot.data!.docs[index];
                              final postTime =
                                  (post['TimeStamp'] as Timestamp).toDate();
                              final formattedTime =
                                  DateFormat.jm().format(postTime);
                              return PostCard(
                                  postID: post.id,
                                  likes: List<String>.from(post['Likes'] ?? []),
                                  imageofUser: post['UserImage'],
                                  userBio: post['Bio'],
                                  backgroundColor: post['backgroundColor'],
                                  postImage: post['imageUrl'], //empty value
                                  timeofPost: formattedTime, //hardcore value
                                  postText: post['Message'],
                                  userEmail: post['UserEmail'],
                                  userName: post['UserName']);

                              // WallPost(
                              //     message: post['Message'],
                              //     likes: List<String>.from(post['Likes'] ?? []),
                              //     postID: post.id,
                              //     user: post['UserEmail']);
                            });
                      } else if (snapshot.hasError) {
                        return const Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text('Unable to load data'),
                            ],
                          ),
                        );
                      } else {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ));
  }

  Future<Map<String, dynamic>> getUserDataFromFirestore() async {
    String? userId = FirebaseAuth.instance.currentUser?.uid;
    var currentUser = FirebaseAuth.instance.currentUser;
    if (userId != null) {
      DocumentSnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore
          .instance
          .collection('Users')
          .doc(currentUser!.email)
          .get();

      //node will be searched according to give criteria
      QuerySnapshot<Map<String, dynamic>> postSnapshot = await FirebaseFirestore
          .instance
          .collection('User Posts')
          .where('UserEmail', isEqualTo: currentUser.email)
          .get();

      //node will be searched without any criteria
      QuerySnapshot<Map<String, dynamic>> userSnapshot =
          await FirebaseFirestore.instance.collection('Users').get();

      return {
        'username': snapshot.data()?['username'],
        'bio': snapshot.data()?['bio'],
        'userImage': snapshot.data()?['userImage'],
        'totalPosts': postSnapshot.docs.length,
        'totalFriends': userSnapshot.docs.length
      };
    }
    return {
      'username': null,
      'bio': null,
      'userImage': null,
      'totalPosts': 0,
      'totalFriends': 0,
    };
  }

  void _handleMenuButtonPressed() {
    // NOTICE: Manage Advanced Drawer state through the Controller.
    // _advancedDrawerController.value = AdvancedDrawerValue.visible();
    _advancedDrawerController.showDrawer();
  }
}
