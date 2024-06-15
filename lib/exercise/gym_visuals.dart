import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_advanced_drawer/flutter_advanced_drawer.dart';
import 'package:social_fit/Music/music.dart';
import 'package:social_fit/chatbot/gemini_screen.dart';
import 'package:social_fit/exercise/shorts.dart';

import 'package:fluentui_system_icons/fluentui_system_icons.dart';

import 'package:get/get.dart';
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

class GymVisuals extends StatefulWidget {
  const GymVisuals({super.key});

  @override
  State<GymVisuals> createState() => _GymVisualsState();
}

class _GymVisualsState extends State<GymVisuals> with TickerProviderStateMixin {
  int isActiveTab = 0;
  TabController? _tabController;
  List<Map<String, String>> upperBodyMuscles = [
    {
      "name": "Biceps",
      "image": "assets/yt.png",
      "description":
          "Bicep curls are a classic exercise for building strength and definition in the biceps muscles. They primarily target the biceps brachii, but also engage the brachialis and brachioradialis muscles.",
      "link": "https://www.youtube.com/shorts/MCC0Wj9RErI"
    },
    {
      "name": "Triceps",
      "image": "assets/yt.png",
      "description":
          "Tricep dips are effective for targeting the triceps muscles. They also engage the chest, shoulders, and core for stabilization.",
      "link": "https://www.youtube.com/shorts/jKBfgYm81qs"
    },
    {
      "name": "Shoulders",
      "image": "assets/yt.png",
      "description":
          "Shoulder press exercises, such as overhead dumbbell press or barbell press, target the deltoid muscles, which consist of three heads: anterior, lateral, and posterior deltoids.",
      "link": "https://www.youtube.com/shorts/_Qi3UgMHA1M"
    },
    {
      "name": "Push-ups",
      "image": "assets/yt.png",
      "description":
          "Push-ups are a versatile exercise that targets the chest, shoulders, and triceps. They also engage the core for stabilization.",
      "link": "https://www.youtube.com/shorts/424ckSkfRcY"
    },
    {
      "name": "Pull-ups",
      "image": "assets/yt.png",
      "description":
          "Pull-ups primarily target the back muscles, including the latissimus dorsi, but also engage the biceps and shoulders as secondary muscles.",
      "link": "https://www.youtube.com/shorts/T6Li-5m11Tk"
    },
    {
      "name": "Dumbbell Rows",
      "image": "assets/yt.png",
      "description":
          "Dumbbell rows are effective for targeting the back muscles, particularly the latissimus dorsi and rhomboids. They also engage the biceps and shoulders.",
      "link": "https://www.youtube.com/shorts/LJtKiEas6xk"
    },
    {
      "name": "Chest Press",
      "image": "assets/yt.png",
      "description":
          "Chest press exercises, like bench press or dumbbell chest press, target the pectoralis major and minor muscles. They also engage the triceps and shoulders for stabilization.",
      "link": "https://www.youtube.com/shorts/_9DhZzvRxWc"
    },
    {
      "name": "Reverse Flyes",
      "image": "assets/yt.png",
      "description":
          "Reverse flyes target the rear deltoids and upper back muscles, helping to improve posture and shoulder stability. They also engage the trapezius and rhomboids.",
      "link": "https://www.youtube.com/shorts/2AwSvH7IVEs"
    },
    {
      "name": "Arnold Press",
      "image": "assets/yt.png",
      "description":
          "Arnold press is a shoulder exercise that involves rotating the palms during the press motion, engaging different parts of the deltoid muscles. It also works the trapezius and triceps.",
      "link": "https://www.youtube.com/shorts/Dzkc29DnLGo"
    },
    {
      "name": "Diamond Push-ups",
      "image": "assets/yt.png",
      "description":
          "Diamond push-ups target the triceps muscles more intensely compared to standard push-ups. They also engage the chest and shoulders for stabilization.",
      "link": "https://www.youtube.com/shorts/PPTj-MW2tcs"
    },
    {
      "name": "Barbell Curl",
      "image": "assets/yt.png",
      "description":
          "Barbell curls are effective for building bicep strength and size. They primarily target the biceps brachii and also engage the forearms and brachialis muscles.",
      "link": "https://www.youtube.com/shorts/-kzxQaUpxZk"
    },
    {
      "name": "Skull Crushers",
      "image": "assets/yt.png",
      "description":
          "Skull crushers, also known as lying triceps extensions, target the triceps muscles. They help improve elbow extension strength and size.",
      "link": "https://www.youtube.com/shorts/oUWxW6Sr8-8"
    },
    {
      "name": "Lateral Raises",
      "image": "assets/yt.png",
      "description":
          "Lateral raises target the lateral deltoid muscles, helping to improve shoulder width and definition. They also engage the trapezius and supraspinatus muscles.",
      "link": "https://www.youtube.com/shorts/Cllqrw_u1H8"
    },
    {
      "name": "Hammer Curls",
      "image": "assets/yt.png",
      "description":
          "Hammer curls target the brachialis and brachioradialis muscles, which lie underneath the biceps brachii. They also engage the forearms and wrists for stabilization.",
      "link": "https://www.youtube.com/shorts/4V2Q1lnMw28"
    },
    {
      "name": "chest Dips",
      "image": "assets/yt.png",
      "description":
          "Dips target the triceps, chest, and shoulders. They are an effective bodyweight exercise for building upper body strength and muscle mass.",
      "link": "https://www.youtube.com/shorts/RqOthRfbHDI"
    },
    {
      "name": "Front Raises",
      "image": "assets/yt.png",
      "description":
          "Front raises target the anterior deltoid muscles, helping to improve shoulder flexion strength and definition. They also engage the upper chest and serratus anterior muscles.",
      "link": "https://www.youtube.com/shorts/_6oXH8ZbB5M"
    },
    {
      "name": "Incline Bench Press",
      "image": "assets/yt.png",
      "description":
          "Incline bench press primarily targets the upper chest muscles, along with the anterior deltoids and triceps. It's an effective variation of the standard bench press.",
      "link": "https://www.youtube.com/shorts/Gruq177Psnk"
    },
    {
      "name": "Russian Twists",
      "image": "assets/yt.png",
      "description":
          "Russian twists target the obliques and core muscles, helping to improve rotational strength and stability. They can be performed with bodyweight or holding a weight.",
      "link": "https://www.youtube.com/shorts/-cPtvFdT8dc"
    },
    {
      "name": "Renegade Rows",
      "image": "assets/yt.png",
      "description":
          "Renegade rows are a compound exercise that targets the back, shoulders, and core muscles. They also improve stability and coordination.",
      "link": "https://www.youtube.com/shorts/rZVI3AQjhlo"
    },
    {
      "name": "Decline Push-ups",
      "image": "assets/yt.png",
      "description":
          "Decline push-ups target the lower chest muscles more intensely compared to standard push-ups. They also engage the shoulders, triceps, and core for stabilization.",
      "link": "https://www.youtube.com/shorts/dcV-ATSeryA"
    },
    {
      "name": "Chin-ups",
      "image": "assets/yt.png",
      "description":
          "Chin-ups primarily target the biceps and back muscles, but also engage the shoulders and core for stabilization. They are a challenging upper body exercise.",
      "link": "https://www.youtube.com/shorts/pt3UiHwzvqg"
    },
    {
      "name": "Dumbbell Shrugs",
      "image": "assets/yt.png",
      "description":
          "Dumbbell shrugs target the trapezius muscles, helping to improve upper back and shoulder strength. They also engage the forearms and grip.",
      "link": "https://www.youtube.com/shorts/6iWZWlJ8OnQ"
    },
    {
      "name": "Cable Flyes",
      "image": "assets/yt.png",
      "description":
          "Cable flyes target the chest muscles, providing a full range of motion and constant tension throughout the movement. They also engage the shoulders and triceps as secondary muscles.",
      "link": "https://www.youtube.com/shorts/Jz7oEmzhnfE"
    },
    {
      "name": "Close Grip Bench Press",
      "image": "assets/yt.png",
      "description":
          "Close grip bench press targets the triceps muscles more intensely compared to standard bench press variations. It also engages the chest and shoulders.",
      "link": "https://www.youtube.com/shorts/vB60qzJRQCo"
    },
    {
      "name": "Reverse Grip Rows",
      "image": "assets/yt.png",
      "description":
          "Reverse grip rows target the upper back and biceps muscles. They also engage the shoulders and forearms for stabilization.",
      "link": "https://www.youtube.com/shorts/gO_dGKSCasA"
    },
    {
      "name": "Standing Military Press",
      "image": "assets/yt.png",
      "description":
          "Standing military press is a compound shoulder exercise that targets the deltoid muscles. It also engages the triceps and core for stabilization.",
      "link": "https://www.youtube.com/shorts/wkrKnoC9aRk"
    },
    {
      "name": "Upright Rows",
      "image": "assets/yt.png",
      "description":
          "Upright rows primarily target the lateral deltoids and upper traps. They also engage the biceps, forearms, and upper back muscles.",
      "link": "https://www.youtube.com/shorts/9mDv1VSJYvo"
    },
    {
      "name": "Dumbbell Pullovers",
      "image": "assets/yt.png",
      "description":
          "Dumbbell pullovers target the chest, back, and triceps muscles. They are a versatile exercise that can be performed on a bench or stability ball.",
      "link": "https://www.youtube.com/shorts/yHn9WzQUsTs"
    },
    {
      "name": "Bent-over Rows",
      "image": "assets/yt.png",
      "description":
          "Bent-over rows target the upper and middle back muscles, along with the biceps and rear deltoids. They also engage the core for stabilization.",
      "link": "https://www.youtube.com/shorts/lOuhtsP7SIQ"
    },
    {
      "name": "Standing Bicep Curls",
      "image": "assets/yt.png",
      "description":
          "Standing bicep curls are effective for building bicep strength and size. They primarily target the biceps brachii and also engage the forearms.",
      "link": "https://www.youtube.com/shorts/rCiYrfaSeFA"
    },
    {
      "name": "Seated Shoulder Press",
      "image": "assets/yt.png",
      "description":
          "Seated shoulder press targets the deltoid muscles and triceps. It's an effective variation of the shoulder press that provides stability and support.",
      "link": "https://www.youtube.com/shorts/2yX8PoOjjzQ"
    },
    {
      "name": "Hammer Strength Chest Press",
      "image": "assets/yt.png",
      "description":
          "Hammer strength chest press is a machine-based exercise that targets the chest muscles. It provides a fixed range of motion and allows for unilateral training.",
      "link": "https://www.youtube.com/shorts/vnEHFpCuE-I"
    },
    {
      "name": "Machine Rows",
      "image": "assets/yt.png",
      "description":
          "Machine rows target the upper back and lats muscles. They provide a controlled movement and are suitable for beginners or those with limited mobility.",
      "link": "https://www.youtube.com/shorts/fPbfYDgzIgA"
    },
    {
      "name": "Seated Tricep Dips",
      "image": "assets/yt.png",
      "description":
          "Seated tricep dips target the triceps muscles and are performed using a bench or chair. They are a suitable alternative for individuals who find traditional dips challenging.",
      "link": "https://www.youtube.com/shorts/rbCB5OZw8kI"
    },
    {
      "name": "Front Dumbbell Raises",
      "image": "assets/yt.png",
      "description":
          "Front dumbbell raises target the anterior deltoids and upper chest muscles. They are effective for improving shoulder strength and definition.",
      "link": "https://www.youtube.com/shorts/rq5o2ehoELk"
    },
    {
      "name": "Lat Pullovers",
      "image": "assets/yt.png",
      "description":
          "Pullovers target the chest, back, and triceps muscles. They can be performed using dumbbells, a barbell, or a cable machine.",
      "link": "https://www.youtube.com/shorts/NUr8_anD1nM"
    },
    {
      "name": "Chest Machine Flyes",
      "image": "assets/yt.png",
      "description":
          "Machine flyes target the chest muscles and provide a controlled range of motion. They are suitable for beginners or as a finishing exercise after compound movements.",
      "link": "https://www.youtube.com/shorts/Jz7oEmzhnfE"
    },
    {
      "name": "Cable Seated Rows",
      "image": "assets/yt.png",
      "description":
          "Cable rows target the upper and middle back muscles, along with the biceps and rear deltoids. They provide constant tension throughout the movement.",
      "link": "https://www.youtube.com/shorts/YUiO_JcQflE"
    },
    {
      "name": "Dumbbell Lying Hammer Press",
      "image": "assets/yt.png",
      "description":
          "Dumbbell hammer press is a variation of the chest press that targets the pectoralis major muscles. It also engages the triceps and anterior deltoids.",
      "link": "https://www.youtube.com/shorts/SO6FPpVJANo"
    },
    {
      "name": "Reverse Grip Tricep Pushdowns",
      "image": "assets/yt.png",
      "description":
          "Reverse grip tricep pushdowns target the triceps muscles, particularly the lateral and long heads. They provide an effective burnout exercise for the triceps.",
      "link": "https://www.youtube.com/shorts/sCyM_iTxUK0"
    },
    {
      "name": "Dumbbell Lateral Raises",
      "image": "assets/yt.png",
      "description":
          "Dumbbell lateral raises target the lateral deltoid muscles, helping to improve shoulder width and definition. They can be performed standing or seated.",
      "link": "https://www.youtube.com/shorts/C7YH4jIJB-I"
    },
    {
      "name": "Incline Dumbbell Flyes",
      "image": "assets/yt.png",
      "description":
          "Incline dumbbell flyes target the upper chest muscles and provide a greater stretch compared to flat bench flyes. They also engage the anterior deltoids and triceps.",
      "link": "https://www.youtube.com/shorts/x7zZPlsqlZo"
    },
    {
      "name": "Chest Supported Rows",
      "image": "assets/yt.png",
      "description":
          "Chest supported rows target the upper and middle back muscles, along with the rear deltoids and biceps. They provide stability and reduce lower back strain.",
      "link": "https://www.youtube.com/shorts/rknGG-14zkI"
    },
    {
      "name": "Standing Cable Curls",
      "image": "assets/yt.png",
      "description":
          "Standing cable curls target the biceps muscles and provide constant tension throughout the movement. They are effective for improving arm strength and size.",
      "link": "https://www.youtube.com/shorts/rZUUHCF9-x4"
    },
  ];
//done till here
  List<Map<String, String>> lowerBodyMuscles = [
    {
      "name": "Squats",
      "image": "assets/yt.png",
      "description":
          "Squats are a compound exercise that targets the quadriceps, hamstrings, and glutes. They also engage the core and lower back for stabilization."
    },
    {
      "name": "Lunges",
      "image": "assets/yt.png",
      "description":
          "Lunges target the quadriceps, hamstrings, and glutes, while also engaging the calves and core for balance and stabilization."
    },
    {
      "name": "Deadlifts",
      "image": "assets/yt.png",
      "description":
          "Deadlifts are a compound exercise that targets the hamstrings, glutes, lower back, and traps. They also engage the forearms and grip strength."
    },
    {
      "name": "Calf Raises",
      "image": "assets/yt.png",
      "description":
          "Calf raises primarily target the gastrocnemius and soleus muscles of the calves. They help improve ankle stability and lower leg strength."
    },
    {
      "name": "Leg Press",
      "image": "assets/yt.png",
      "description":
          "Leg press exercises target the quadriceps, hamstrings, and glutes, providing a safe and effective way to build lower body strength and muscle mass."
    },
    {
      "name": "Step-ups",
      "image": "assets/yt.png",
      "description":
          "Step-ups target the quadriceps, hamstrings, and glutes, while also engaging the calves and core muscles for stabilization and balance."
    },
    {
      "name": "Romanian Deadlifts",
      "image": "assets/yt.png",
      "description":
          "Romanian deadlifts primarily target the hamstrings and glutes, while also engaging the lower back and core for stability. They improve hip mobility and posterior chain strength."
    },
    {
      "name": "Glute Bridges",
      "image": "assets/yt.png",
      "description":
          "Glute bridges target the gluteus maximus muscles, helping to improve hip extension strength and stability. They also engage the hamstrings and lower back."
    },
    {
      "name": "Leg Curls",
      "image": "assets/yt.png",
      "description":
          "Leg curls target the hamstrings, helping to improve knee flexion strength and muscle balance. They also engage the glutes and calves for stabilization."
    },
    {
      "name": "Hack Squats",
      "image": "assets/yt.png",
      "description":
          "Hack squats target the quadriceps, hamstrings, and glutes, providing a variation to traditional squats. They also engage the calves and core for stabilization."
    },
    {
      "name": "Bulgarian Split Squats",
      "image": "assets/yt.png",
      "description":
          "Bulgarian split squats are a unilateral exercise that target the quadriceps, hamstrings, and glutes. They also engage the calves and core for balance and stabilization."
    },
    {
      "name": "Box Jumps",
      "image": "assets/yt.png",
      "description":
          "Box jumps are plyometric exercises that target the quadriceps, hamstrings, and glutes. They also improve explosive power and lower body coordination."
    },
    {
      "name": "Sprints",
      "image": "assets/yt.png",
      "description":
          "Sprints are high-intensity cardio exercises that engage the quadriceps, hamstrings, glutes, and calves. They also improve cardiovascular endurance and lower body strength."
    },
    {
      "name": "Curtsy Lunges",
      "image": "assets/yt.png",
      "description":
          "Curtsy lunges target the inner and outer thighs, along with the quadriceps, hamstrings, and glutes. They also engage the core for balance and stabilization."
    },
    {
      "name": "Reverse Lunges",
      "image": "assets/yt.png",
      "description":
          "Reverse lunges target the quadriceps, hamstrings, and glutes, while also engaging the calves and core for stability. They provide a variation to traditional lunges."
    },
    {
      "name": "Sumo Squats",
      "image": "assets/yt.png",
      "description":
          "Sumo squats target the inner thighs, quadriceps, hamstrings, and glutes. They also engage the calves and core for balance and stabilization."
    },
    {
      "name": "Walking Lunges",
      "image": "assets/yt.png",
      "description":
          "Walking lunges are dynamic exercises that target the quadriceps, hamstrings, and glutes, while also engaging the calves and core for stability. They improve lower body strength and coordination."
    },
    {
      "name": "Side Lunges",
      "image": "assets/yt.png",
      "description":
          "Side lunges target the inner and outer thighs, quadriceps, hamstrings, and glutes. They also engage the calves and core for balance and stabilization."
    },
    {
      "name": "Stiff Leg Deadlifts",
      "image": "assets/yt.png",
      "description":
          "Stiff leg deadlifts primarily target the hamstrings and glutes, while also engaging the lower back and core for stability. They improve hip hinge mobility and posterior chain strength."
    },
    {
      "name": "Jump Squats",
      "image": "assets/yt.png",
      "description":
          "Jump squats are plyometric exercises that target the quadriceps, hamstrings, and glutes. They also improve explosive power and lower body coordination."
    },
    {
      "name": "Side Leg Raises",
      "image": "assets/yt.png",
      "description":
          "Side leg raises target the abductors, which include the gluteus medius and minimus muscles. They help improve hip stability and prevent injury."
    },
    {
      "name": "Hip Thrusts",
      "image": "assets/yt.png",
      "description":
          "Hip thrusts target the gluteus maximus muscles, helping to improve hip extension strength and power. They also engage the hamstrings and lower back."
    },
    {
      "name": "Single Leg Deadlifts",
      "image": "assets/yt.png",
      "description":
          "Single leg deadlifts are unilateral exercises that target the hamstrings, glutes, and lower back. They also improve balance, coordination, and hip stability."
    },
    {
      "name": "Step Lunges",
      "image": "assets/yt.png",
      "description":
          "Step lunges combine the benefits of lunges and step-ups, targeting the quadriceps, hamstrings, and glutes, while also engaging the calves and core for balance and stabilization."
    },
    {
      "name": "Fire Hydrants",
      "image": "assets/yt.png",
      "description":
          "Fire hydrants target the gluteus medius and minimus muscles, which help with hip abduction and rotation. They also engage the core for stabilization."
    },
    {
      "name": "Jumping Lunges",
      "image": "assets/yt.png",
      "description":
          "Jumping lunges are plyometric exercises that target the quadriceps, hamstrings, and glutes, while also engaging the calves and core for stabilization. They improve lower body power and explosiveness."
    },
    {
      "name": "Wall Sits",
      "image": "assets/yt.png",
      "description":
          "Wall sits are isometric exercises that target the quadriceps, hamstrings, and glutes. They also engage the core and lower back for stability and endurance."
    },
    {
      "name": "Cossack Squats",
      "image": "assets/yt.png",
      "description":
          "Cossack squats target the inner and outer thighs, quadriceps, hamstrings, and glutes. They also engage the calves and core for balance and stabilization."
    },
    {
      "name": "Side Step-ups",
      "image": "assets/yt.png",
      "description":
          "Side step-ups target the quadriceps, hamstrings, and glutes, while also engaging the calves and core for balance and stabilization. They provide a lateral movement pattern."
    },
    {
      "name": "Hamstring Curls",
      "image": "assets/yt.png",
      "description":
          "Hamstring curls target the hamstrings, helping to improve knee flexion strength and muscle balance. They also engage the glutes and calves for stabilization."
    },
    {
      "name": "Single Leg Box Squats",
      "image": "assets/yt.png",
      "description":
          "Single leg box squats are unilateral exercises that target the quadriceps, hamstrings, and glutes. They also engage the core for balance and stabilization."
    },
    {
      "name": "Clamshells",
      "image": "assets/yt.png",
      "description":
          "Clamshells target the hip abductors, including the gluteus medius and minimus muscles. They help improve hip stability and prevent knee injuries."
    },
    {
      "name": "Plie Squats",
      "image": "assets/yt.png",
      "description":
          "Plie squats target the inner thighs, quadriceps, hamstrings, and glutes. They also engage the calves and core for balance and stabilization."
    },
    {
      "name": "Reverse Hyperextensions",
      "image": "assets/yt.png",
      "description":
          "Reverse hyperextensions target the lower back, glutes, and hamstrings. They help improve lower back strength and stability."
    },
    {
      "name": "Box Squats",
      "image": "assets/yt.png",
      "description":
          "Box squats target the quadriceps, hamstrings, and glutes, while also engaging the lower back and core for stabilization. They provide a variation to traditional squats."
    },
    {
      "name": "Donkey Kicks",
      "image": "assets/yt.png",
      "description":
          "Donkey kicks target the gluteus maximus muscles, helping to improve hip extension strength and power. They also engage the lower back and core."
    },
    {
      "name": "Side Plank Leg Lifts",
      "image": "assets/yt.png",
      "description":
          "Side plank leg lifts target the gluteus medius and minimus muscles, along with the obliques and core. They help improve hip stability and prevent injury."
    },
    {
      "name": "Kettlebell Swings",
      "image": "assets/yt.png",
      "description":
          "Kettlebell swings target the posterior chain muscles, including the hamstrings, glutes, lower back, and shoulders. They improve power, explosiveness, and cardiovascular endurance."
    },
  ];

  final TextEditingController _searchController = TextEditingController();
  String _searchText = '';
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
    _tabController = TabController(length: 2, vsync: this);
    _tabController!.addListener(() {
      setState(() {
        isActiveTab = _tabController!.index;
      });
    });

     try {
      cameras = await availableCameras();
    } on Exception catch (e) {
      print('Error: $e.code\nError Message: $e.message');
    }
  }

  @override
  void dispose() {
    _tabController!.dispose();
    super.dispose();
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
            elevation: 0,
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
            title: const Text('Gym Visuals',
                style: TextStyle(
                    fontFamily: 'Billabong',
                    fontWeight: FontWeight.bold,
                    fontSize: 32,
                    color: Color(0xff000221))),
            automaticallyImplyLeading: false,
          ),
          body: Column(
            children: [
              // TabBar(
              //   controller: _tabController,
              //   tabs: const [
              //     Tab(
              //       text: "Upper Body",
              //     ),
              //     Tab(
              //       text: "Lower Body",
              //     ),
              //   ],
              // ),
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: TextField(
                            controller: _searchController,
                            onChanged: (value) {
                              setState(() {
                                _searchText = value;
                              });
                            },
                            decoration: InputDecoration(
                              hintText: 'Search exercises...',
                              hintStyle: TextStyle(
                                  color: Colors.black.withOpacity(0.3)),
                              filled: true,
                              fillColor: Colors.white,
                              contentPadding: const EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 16),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                                borderSide: BorderSide(
                                    width: 0,
                                    color: Colors.grey.withOpacity(0.2)),
                              ),
                              prefixIcon:
                                  const Icon(Icons.search, color: Colors.grey),
                              suffixIcon: _searchText.isNotEmpty
                                  ? IconButton(
                                      icon: const Icon(Icons.clear),
                                      onPressed: () {
                                        setState(() {
                                          _searchController.clear();
                                          _searchText = '';
                                        });
                                      },
                                    )
                                  : null,
                            ),
                          ),
                        ),
                        Expanded(
                          child: ListView.builder(
                            padding: EdgeInsets.zero,
                            itemCount: upperBodyMuscles.length,
                            itemBuilder: (context, index) {
                              var muscle = upperBodyMuscles[index];
                              if (_searchText.isNotEmpty &&
                                  !muscle["name"]!
                                      .toLowerCase()
                                      .contains(_searchText.toLowerCase())) {
                                return const SizedBox.shrink();
                              }
                              return Card(
                                color: Colors.grey[300],
                                elevation: 3,
                                child: Padding(
                                  padding: const EdgeInsets.all(12.0),
                                  child: Column(
                                    children: [
                                      InkWell(
                                        onTap: () {
                                          String urlLink =
                                              muscle["link"].toString();
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      YoutubeScreen(
                                                        testURL: urlLink,
                                                        videoTitle:
                                                            muscle["name"]!,
                                                      )));
                                        },
                                        child: Stack(
                                          alignment: Alignment.center,
                                          children: [
                                            // Image.asset(
                                            //   muscle["image"]!,
                                            //   width: double.infinity,
                                            //   height: 200,
                                            //   fit: BoxFit.cover,
                                            // ),
                                            Image.asset(
                                              "assets/yt.png",
                                              width: 60,
                                              height: 60,
                                            ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      ListTile(
                                        title: Center(
                                          child: Text(
                                            muscle["name"]!,
                                            style: const TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                        subtitle: Text(
                                          muscle["description"]!,
                                          style: const TextStyle(fontSize: 12),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 8,
                                      )
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: TextField(
                            controller: _searchController,
                            onChanged: (value) {
                              setState(() {
                                _searchText = value;
                              });
                            },
                            decoration: InputDecoration(
                              hintText: 'Search exercises...',
                              hintStyle: TextStyle(
                                  color: Colors.black.withOpacity(0.3)),
                              filled: true,
                              fillColor: Colors.white,
                              contentPadding: const EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 16),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                                borderSide: BorderSide(
                                    width: 0,
                                    color: Colors.grey.withOpacity(0.2)),
                              ),
                              prefixIcon:
                                  const Icon(Icons.search, color: Colors.grey),
                              suffixIcon: _searchText.isNotEmpty
                                  ? IconButton(
                                      icon: const Icon(Icons.clear),
                                      onPressed: () {
                                        setState(() {
                                          _searchController.clear();
                                          _searchText = '';
                                        });
                                      },
                                    )
                                  : null,
                            ),
                          ),
                        ),
                        Expanded(
                          child: ListView.builder(
                            padding: EdgeInsets.zero,
                            itemCount: lowerBodyMuscles.length,
                            itemBuilder: (context, index) {
                              var muscle = lowerBodyMuscles[index];
                              if (_searchText.isNotEmpty &&
                                  !muscle["name"]!
                                      .toLowerCase()
                                      .contains(_searchText.toLowerCase())) {
                                return const SizedBox.shrink();
                              }
                              return Card(
                                color: Colors.grey[300],
                                elevation: 3,
                                child: Padding(
                                  padding: const EdgeInsets.all(12.0),
                                  child: Column(
                                    children: [
                                      InkWell(
                                        onTap: () {
                                          String urlLink =
                                              muscle["link"].toString();
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      YoutubeScreen(
                                                        testURL: urlLink,
                                                        videoTitle:
                                                            muscle["name"]!,
                                                      )));
                                        },
                                        child: Stack(
                                          alignment: Alignment.center,
                                          children: [
                                            // Image.asset(
                                            //   muscle["image"]!,
                                            //   width: double.infinity,
                                            //   height: 200,
                                            //   fit: BoxFit.cover,
                                            // ),
                                            Image.asset(
                                              "assets/yt.png",
                                              width: 60,
                                              height: 60,
                                            ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      ListTile(
                                        title: Center(
                                          child: Text(
                                            muscle["name"]!,
                                            style: const TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                        subtitle: Text(
                                          muscle["description"]!,
                                          style: const TextStyle(fontSize: 12),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 8,
                                      )
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ));
  }

  void _handleMenuButtonPressed() {
    // NOTICE: Manage Advanced Drawer state through the Controller.
    // _advancedDrawerController.value = AdvancedDrawerValue.visible();
    _advancedDrawerController.showDrawer();
  }
}
