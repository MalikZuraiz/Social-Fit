// ignore_for_file: file_names, library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:social_fit/meal_plan/water/manager/dataManager.dart';

class TabCalculator extends StatefulWidget {
  const TabCalculator({super.key});

  @override
  _TabCalculatorState createState() => _TabCalculatorState();
}

class _TabCalculatorState extends State<TabCalculator> {
  TextEditingController? _txtWeight;

  double _userShouldDrink = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          const SizedBox(
            height: 10,
          ),
          const Padding(
              padding: EdgeInsets.only(left: 20, right: 20),
              child: FittedBox(
                fit: BoxFit.fill,
                child: Text(
                  "Daily Water Intake Calculator",
                  style: TextStyle(fontSize: 24),
                ),
              )),
          const SizedBox(
            height: 10,
          ),
          const Padding(
            padding: EdgeInsets.only(left: 20, right: 20),
            child: Text(
              """Use this hydration calculator to learn how much water you should drink daily based on your weight.""",
              style: TextStyle(fontSize: 16, color: Colors.black87),
            ),
          ),
          const SizedBox(
            height: 30,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20, right: 20),
            child: TextField(
              keyboardType: TextInputType.number,
              onChanged: _onChangedTextWeightField,
              onSubmitted: _onChangedTextWeightField,
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.digitsOnly
              ],
              decoration: InputDecoration(
                labelText: 'Weight (Kg)',
                prefixIcon: const Icon(Icons.edit),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              controller: _txtWeight,
            ),
          ),
          if (_userShouldDrink > 0)
            Padding(
              padding: const EdgeInsets.all(20),
              child: Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Text("You should drink", style: TextStyle(fontSize: 14)),
                    Text("${_userShouldDrink.toStringAsFixed(0)} ml",
                        style: const TextStyle(fontSize: 24)),
                    const Text("per day", style: TextStyle(fontSize: 11)),
                    const SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: _onClickSetNewGoal,
                      child: const Wrap(
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: [
                          Icon(Icons.save),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            "use this number as my goal",
                            style: TextStyle(fontSize: 14),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            )
        ],
      ),
    );
  }

  void _onClickSetNewGoal() {
    if (_userShouldDrink > 0) {
      DataManager.instance?.setUserData(goal: _userShouldDrink.toInt());
      Navigator.of(context)
          .pushNamedAndRemoveUntil('/', (route) => false, arguments: 0);
    }
  }

  void _onChangedTextWeightField(String txtValue) {
    setState(() {
      if (txtValue.isEmpty) {
        _userShouldDrink = 0;
        return;
      }

      final int numWeight = int.parse(txtValue);
      if (numWeight <= 0) {
        _userShouldDrink = 0;
        return;
      }

      _userShouldDrink = (numWeight.toDouble() * 0.033) * 1000;
    });
  }
}
