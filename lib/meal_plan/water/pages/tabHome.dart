// ignore_for_file: library_private_types_in_public_api, file_names

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:social_fit/meal_plan/water/models/CupModel.dart';
import 'package:social_fit/meal_plan/water/manager/dataManager.dart';
import 'package:social_fit/meal_plan/water/pages/goalPage.dart';
import 'package:social_fit/meal_plan/water/pages/tabCalculator.dart';

class TabHome extends StatefulWidget {
  const TabHome({super.key});

  @override
  _TabHomeState createState() => _TabHomeState();
}

class _TabHomeState extends State<TabHome> with TickerProviderStateMixin {
  int _currentDrank = 0;
  int _goalDrink = 0;
  double _progressBarPercent = 0;
  late final AnimationController _controller;

  List<CupModel> cupOptions = [];
  bool _isResetting = false;

  @override
  void initState() {
    super.initState();

    _currentDrank = DataManager.instance!.userCurrentProgress;
    _goalDrink = DataManager.instance!.userCurrentGoal;
    _progressBarPercent = _calculateProgressBar();

    // Set initial animation duration based on progress
    double initialDuration = _calculateAnimationDuration();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: initialDuration.toInt()),
    );

    // Add a status listener to the controller
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed && !_isResetting) {
        // Animation completed, reset the controller
        _isResetting = true;
        _controller.reset();
        // Update the animation duration based on progress
        double newDuration = _calculateAnimationDuration();
        _controller.duration = Duration(seconds: newDuration.toInt());
        // Start the animation with the new duration
        _controller.forward();
        _isResetting = false;
      }
    });

    // Start the animation
    _controller.forward();
  }

   @override
  void dispose() {
    _controller.dispose(); // Dispose of the animation controller
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20),
            Stack(
              children: [
                Center(
                  child: SizedBox(
                    height: 200,
                    width: 200,
                    child: CircularProgressIndicator(
                      value: _progressBarPercent,
                      backgroundColor: Colors.lightBlue.shade100,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        Colors.blue.withOpacity(0.4),
                      ),
                      strokeWidth: 15,
                      strokeCap: StrokeCap.round,
                    ),
                  ),
                ),
                Center(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 35.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "${(_progressBarPercent * 100).toInt()}%",
                          style: const TextStyle(fontSize: 24),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          "$_currentDrank ml / $_goalDrink ml",
                          style: const TextStyle(fontSize: 14),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 15),
            ElevatedButton(
                style: const ButtonStyle(),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const GoalPage(),
                      ));
                },
                child: const Text(
                  'Edit Goal',
                  style: TextStyle(color: Colors.blue),
                )),
            const SizedBox(height: 25),
            const Padding(
              padding: EdgeInsets.all(20.0),
              child: Text(
                "Tap one of these options below according with your last drink",
                style: TextStyle(
                  fontSize: 12,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 5),
            Padding(
              padding: const EdgeInsets.only(left: 10, right: 10),
              child: GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: DataManager.instance?.cupsAvailable.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                ),
                itemBuilder: buildGridItem,
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        elevation: 3,
        backgroundColor: Colors.white,
        child: const Icon(
          Icons.calculate_rounded,
          color: Colors.blue,
        ),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const TabCalculator()),
          );
        },
      ),
    );
  }


  double _calculateProgressBar() {
    if (DataManager.instance == null || _goalDrink == 0) {
      return 0.0;
    }
    final p = _currentDrank.toDouble() / _goalDrink.toDouble();
    return p > 1.0 ? 1.0 : p;
  }

  double _calculateAnimationDuration() {
    // Assuming the total duration is 10 seconds for 100%
    return (_calculateProgressBar() * 20.0); // Adjust the multiplier as needed
  }

  Widget buildGridItem(BuildContext context, int index) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: Card(
        color: Colors.white,
        elevation: 3,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: ElevatedButton(
          onPressed: () {
            _onClickAddDrinkOption(index);
          },
          child: Align(
            alignment: Alignment.center,
            child: Wrap(
              direction: Axis.vertical,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                (DataManager.instance!.cupsAvailable[index].mililiters >= 500
                    ? SvgPicture.asset(
                        'assets/img/water-bottle-sport.svg',
                        width: 28,
                      )
                    : SvgPicture.asset(
                        'assets/img/water-bottle-glass.svg',
                        width: 28,
                      )),
                const SizedBox(
                  height: 5,
                ),
                Text(
                  "${DataManager.instance!.cupsAvailable[index].mililiters}ml",
                  style: const TextStyle(color: Colors.blue),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _onClickAddDrinkOption(int index) {
    DataManager.instance
        ?.setUserData(
            progress: DataManager.instance!.userCurrentProgress +
                DataManager.instance!.cupsAvailable[index].mililiters)
        .then((value) {
      setState(() {
        _currentDrank = DataManager.instance!.userCurrentProgress;
        _progressBarPercent = _calculateProgressBar();
      });
    });
  }
}
