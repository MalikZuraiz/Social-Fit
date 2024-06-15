// ignore_for_file: prefer_typing_uninitialized_variables


import 'package:flutter/material.dart';

import 'package:social_fit/meal_plan/meal/data.dart';
import 'package:social_fit/meal_plan/meal/foodDetails.dart';


class MealPlan extends StatefulWidget {
  const MealPlan({super.key});

  @override
  State<MealPlan> createState() => _MealPlanState();
}

class _MealPlanState extends State<MealPlan> with TickerProviderStateMixin {
 
  
  var getdatalist; 
  @override
  void initState() {
    super.initState();
    getdatalist = MealData().workArr;    
  }
 

  void _navigateToFoodScreen(
      String mealTime, List<Map<String, dynamic>> foods) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FoodScreen(mealTime: mealTime, foods: foods),
      ),
    );
  }



  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            Expanded(
              child: ListView.builder(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
                itemCount: getdatalist.length,
                itemBuilder: (context, index) {
                  var mealTime = getdatalist[index]["name"];
                  return Container(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    decoration: const BoxDecoration(color: Colors.white),
                    child: InkWell(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.asset(
                              getdatalist[index]["image"].toString(),
                              width: media.width,
                              height: media.width * 0.55,
                              fit: BoxFit.cover,
                            ),
                          ),
                          Center(
                            child: Text(
                              mealTime,
                              style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w700),
                            ),
                          ),
                        ],
                      ),
                      onTap: () {
                        _navigateToFoodScreen(
                          mealTime,
                          List<Map<String, dynamic>>.from(
                              getdatalist[index]["foods"]),
                        );
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
