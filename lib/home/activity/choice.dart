// ignore_for_file: use_build_context_synchronously

import 'package:action_slider/action_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:social_fit/home/activity/speed.dart';
import 'package:social_fit/home/index.dart';
import 'package:vertical_card_pager/vertical_card_pager.dart';

class WorkoutChoice extends StatefulWidget {
  const WorkoutChoice({super.key});

  @override
  State<WorkoutChoice> createState() => _WorkoutChoiceState();
}

const workoutType = ['Outside Running', 'Gym Workout'];

class _WorkoutChoiceState extends State<WorkoutChoice> {
  String selectedWorkout = workoutType[0];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Choose your workout'),
        elevation: 0,
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: VerticalCardPager(
                titles: const ['', ''],
                images: const [
                  Image(
                    image: AssetImage('assets/running.png'),
                    fit: BoxFit.cover,
                  ),
                  Image(
                      image: AssetImage('assets/workout.png'),
                      fit: BoxFit.cover)
                ],
                align: ALIGN.CENTER,
                initialPage: 0,
                onPageChanged: (page) {
                  if (page == null) return;
                  setState(() {
                    selectedWorkout = workoutType[page.round()];
                  });
                },
                onSelectedItem: (index) {
                  if (index == 1) {
                    Navigator.push(
                      context,
                      CupertinoPageRoute(
                          builder: (context) => const BodyPartSelector()),
                    );
                    return;
                  }
                  Navigator.push(
                      context,
                      CupertinoPageRoute(
                          builder: (context) => const SpeedWidget()));
                },
              ),
            ),
            ActionSlider.standard(
              sliderBehavior: SliderBehavior.stretch,
              width: 300.0,
              backgroundColor: Colors.white,
              toggleColor: Colors.blue,
              icon: const Icon(Icons.arrow_forward_ios, color: Colors.white),
              loadingIcon: const CircularProgressIndicator(
                  color: Colors.white, strokeWidth: 2),
              successIcon: const Icon(Icons.check, color: Colors.white),
              failureIcon: const Icon(Icons.close, color: Colors.white),
              action: (controller) async {
                controller.loading(); //starts loading animation
                await Future.delayed(const Duration(seconds: 2));
                controller.success();
                if (selectedWorkout == workoutType[1]) {
                  Navigator.push(
                    context,
                    CupertinoPageRoute(
                        builder: (context) => const BodyPartSelector()),
                  );
                } else {
                  Navigator.push(
                      context,
                      CupertinoPageRoute(
                          builder: (context) => const SpeedWidget()));
                }
            
                controller.reset();
              },
              child: Text(
                selectedWorkout,
                style: const TextStyle(
                    fontWeight: FontWeight.w500, fontSize: 18),
              ),
            ),
            const SizedBox(
              height: 40,
            ),
          ],
        ),
      ),
    );
  }
}
