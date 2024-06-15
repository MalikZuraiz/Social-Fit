// ignore_for_file: avoid_print

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_advanced_drawer/flutter_advanced_drawer.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

import 'package:fluentui_system_icons/fluentui_system_icons.dart';

import 'package:get/get.dart';
import 'package:social_fit/Music/music.dart';
import 'package:social_fit/exercise/gym_visuals.dart';
import 'package:social_fit/home/landing/layout.dart';
import 'package:social_fit/meal_plan/homeformealandwater.dart';
import 'package:social_fit/posturefit/widgets/main_screen.dart';
import 'package:social_fit/settings/screens/account_screen.dart';
import 'package:social_fit/social_module/auth/login_view.dart';
import 'package:social_fit/social_module/home/home_view.dart';
import 'package:social_fit/wrm/build_wrm_tab.dart';

import 'package:camera/camera.dart';

const apiKey = "AIzaSyAdOKrqXhf35Xy1aDPLRQuldLrnRINh_Sk";
// const apiKey = "AIzaSyAdOKrqXhf35Xy1aDPLRQuldLrnRINh_Sk";

List<CameraDescription>? cameras;

class GeminiBot extends StatefulWidget {
  const GeminiBot({
    super.key,
  });

  @override
  State<GeminiBot> createState() => _GeminiBotState();
}

class _GeminiBotState extends State<GeminiBot> {
  bool loading = false;
  List textChat = [];
  final TextEditingController _textController = TextEditingController();
  final ScrollController _controller = ScrollController();
  final _advancedDrawerController = AdvancedDrawerController();

  // ignore: prefer_typing_uninitialized_variables
  var chat;

      @override
  void initState() async {
    
    super.initState();
    try {
      cameras = await availableCameras();
    } on Exception catch (e) {
      print('Error: $e.code\nError Message: $e.message');
    }
     _initChat();
  }

  Future<void> _initChat() async {
    final model = GenerativeModel(
      model: 'gemini-pro',
      apiKey: apiKey,
      generationConfig: GenerationConfig(maxOutputTokens: 100000),
    );

    chat = model.startChat(history: [
      Content.text(
          'your Role: Home Workout Trainer /  Diet Expert / Injury Specialist / rehabiliation Expert. Any Question Reated to Home Workout / '),
      Content.model([
        TextPart(
            'ok, Ask me any Question I will asnwer in 1 to 2 lines only, if and only if explicitly not asked for detailed answer')
      ])
    ]);
  }

  Future<void> _sendMessage(String text) async {
    var content = Content.text(text);

    setState(() {
      textChat.add({
        "role": "User",
        "text": text,
      });
    });
    var response = await chat.sendMessage(content);
    loading = !loading;
    setState(() {
      textChat.add({
        "role": "Gemini",
        "text": response.text ?? 'Error Occured From Server Side',
      });
    });
    scrollToTheEnd();
  }

  void scrollToTheEnd() {
    _controller.jumpTo(_controller.position.maxScrollExtent);
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
        child: Scaffold(
            // extendBodyBehindAppBar: true,
            // backgroundColor: Colors.grey[300],
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
            body: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: <Widget>[
                  Expanded(
                    child: ListView.builder(
                      controller: _controller,
                      itemCount: textChat.length,
                      padding: const EdgeInsets.all(8.0),
                      itemBuilder: (context, index) {
                        bool isUserMessage = textChat[index]["role"] == "User";

                        return Column(
                          children: [
                            Row(
                              mainAxisAlignment: isUserMessage
                                  ? MainAxisAlignment.end
                                  : MainAxisAlignment.start,
                              children: [
                                isUserMessage
                                    ? const SizedBox() // Empty space for chatbot icon
                                    : const CircleAvatar(
                                        child: Icon(Icons.align_vertical_top),
                                      ),
                                ConstrainedBox(
                                  constraints: BoxConstraints(
                                    maxWidth: MediaQuery.of(context)
                                            .size
                                            .width *
                                        0.75, // Set the maximum width to 75% of the screen width
                                  ),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(15),
                                      color: isUserMessage
                                          ? Colors.blue
                                          : Colors.grey,
                                    ),
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 12, vertical: 8),
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 8, vertical: 4),
                                    child: Text(
                                      textChat[index]["text"],
                                      textAlign: TextAlign.left,
                                    ),
                                  ),
                                ),
                                !isUserMessage
                                    ? const SizedBox() // Empty space for user icon
                                    : const CircleAvatar(
                                        child: Icon(Icons.person),
                                      ),
                              ],
                            ),
                            const SizedBox(height: 10),
                          ],
                        );
                      },
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width * 0.80,
                        padding: const EdgeInsets.only(
                            left: 10, right: 10, top: 5, bottom: 5),
                        child: TextFormField(
                          controller: _textController,
                          decoration: const InputDecoration(
                            focusColor: Color.fromRGBO(144, 202, 249, 1),
                            contentPadding: EdgeInsets.all(8.0),
                            border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(8))),
                            hintText: 'Enter Your Query',
                          ),
                        ),
                      ),
                      IconButton(
                        color: Colors.blue,
                        icon: loading
                            ? const CircularProgressIndicator(
                                color: Colors.blue,
                              )
                            : const Icon(Icons.send),
                        onPressed: () {
                          setState(() {
                            loading = !loading;
                            _sendMessage(_textController.text);
                            _textController
                                .clear(); // Clear the text field after sending the message
                            FocusScope.of(context).unfocus();
                          });
                        },
                      ),
                    ],
                  ),
                ],
              ),
            )));
  }

  void _handleMenuButtonPressed() {
    // NOTICE: Manage Advanced Drawer state through the Controller.
    // _advancedDrawerController.value = AdvancedDrawerValue.visible();
    _advancedDrawerController.showDrawer();
  }
}
