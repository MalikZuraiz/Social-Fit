// ignore_for_file: file_names, library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:social_fit/meal_plan/water/manager/dataManager.dart';

class GoalPage extends StatefulWidget {
  const GoalPage({super.key});

  @override
  _GoalPageState createState() => _GoalPageState();
}

class _GoalPageState extends State<GoalPage> {
  TextEditingController txtGoal = TextEditingController();

  @override
  void initState() {
    super.initState();
    txtGoal.value = TextEditingValue(
        text: DataManager.instance!.userCurrentGoal.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text("Goal"),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Padding(
            padding: EdgeInsets.all(20),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Set your goal (ml)",
                style: TextStyle(fontSize: 12),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: TextField(
              keyboardType: TextInputType.number,
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.digitsOnly
              ],
              decoration: InputDecoration(
                labelText: 'Goal',
                prefixIcon: const Icon(Icons.edit),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              controller: txtGoal,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton(
                onPressed: _onClickSaveGoal,
                child: const Text(
                  "Save",
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  void _onClickSaveGoal() {
    final String val = txtGoal.text;
    if (val == "") return;

    final int iParseGoal = int.parse(val);
    if (iParseGoal <= 0) return;

    DataManager.instance?.setUserData(goal: iParseGoal);

    Navigator.of(context).pushNamedAndRemoveUntil("/", (route) => false);
  }
}
