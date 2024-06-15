// ignore_for_file: unused_local_variable, library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:social_fit/meal_plan/meal/db_model.dart';

class ChartsPage extends StatefulWidget {
  final String mealTime;
  const ChartsPage({super.key, required this.mealTime});

  @override
  _ChartsPageState createState() => _ChartsPageState();
}

class _ChartsPageState extends State<ChartsPage> {
  List<Map<String, dynamic>>? mealFoods;

  @override
  void initState() {
    super.initState();
    fetchMealFoods();
  }

  Future<void> fetchMealFoods() async {
    mealFoods = await DBHelper().getMealFoods();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.mealTime} Charts',
            style: const TextStyle(
                fontFamily: 'Billabong',
                fontWeight: FontWeight.bold,
                fontSize: 32,
                color: Color(0xff000221))),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: mealFoods != null
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(
                      height: 50,
                    ),
                    SizedBox(
                      height: 300,
                      child: buildBarChart(),
                    ),
                    const SizedBox(
                      height: 50,
                    ),
                    SizedBox(
                      height: 300,
                      child: buildPieChart(),
                    ),
                  ],
                )
              : const CircularProgressIndicator(), // Show loading indicator if mealFoods is null
        ),
      ),
    );
  }

  Widget buildBarChart() {
    List<BarChartGroupData> barChartGroups = [];
    Map<String, List<int>> dateDataMap = {};

    // Aggregate proteins and calories for each date
    if (mealFoods != null) {
      for (var i = 0; i < mealFoods!.length; i++) {
        var data = mealFoods![i];
        String date = data['date'] ?? '';
        int proteins = data['proteins'] ?? 0;
        int calories = data['calories'] ?? 0;

        if (!dateDataMap.containsKey(date)) {
          dateDataMap[date] = [proteins, calories];
        } else {
          dateDataMap[date]![0] += proteins;
          dateDataMap[date]![1] += calories;
        }
      }
    }

    // Populate barChartGroups based on aggregated data
    int index = 0;
    dateDataMap.forEach((date, values) {
      int proteins = values[0];
      int calories = values[1];

      barChartGroups.add(BarChartGroupData(
        x: index,
        barRods: [
          BarChartRodData(
            y: proteins.toDouble(),
            colors: [Colors.blue],
          ),
          BarChartRodData(
            y: calories.toDouble(),
            colors: [Colors.red],
          ),
        ],
      ));
      index++;
    });

    return BarChart(
      BarChartData(
        groupsSpace: 20,
        barTouchData: BarTouchData(enabled: false),
        titlesData: FlTitlesData(
          show: true,
          bottomTitles: SideTitles(
            showTitles: true,
            getTitles: (double? value) {
              if (value != null &&
                  value.toInt() >= 0 &&
                  value.toInt() < dateDataMap.length) {
                return dateDataMap.keys.elementAt(value.toInt());
              }
              return '';
            },
          ),
          leftTitles: SideTitles(
            showTitles: true,
            // getTextStyles: (value) => TextStyle(color: Colors.black),
            margin: 20,
          ),
        ),
        borderData: FlBorderData(
          show: true,
          border: Border.all(color: Colors.black, width: 1),
        ),
        barGroups: barChartGroups,
      ),
    );
  }

  Widget buildPieChart() {
    List<PieChartSectionData> pieChartSections = [];
    Map<String, List<int>> dateDataMap = {};

    // Aggregate proteins and calories for each date
    if (mealFoods != null) {
      for (var i = 0; i < mealFoods!.length; i++) {
        var data = mealFoods![i];
        String date = data['date'] ?? '';
        int proteins = data['proteins'] ?? 0;
        int calories = data['calories'] ?? 0;

        if (!dateDataMap.containsKey(date)) {
          dateDataMap[date] = [proteins, calories];
        } else {
          dateDataMap[date]![0] += proteins;
          dateDataMap[date]![1] += calories;
        }
      }
    }

    // Populate pieChartSections based on aggregated data
    dateDataMap.forEach((date, values) {
      int proteins = values[0];
      int calories = values[1];

      pieChartSections.add(PieChartSectionData(
        value: proteins.toDouble(),
        color: Colors.blue,
        title: 'Proteins',
        radius: 40,
        titleStyle: const TextStyle(
            fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black),
        badgeWidget: Text('$proteins g'),
        badgePositionPercentageOffset: .98,
      ));
      pieChartSections.add(PieChartSectionData(
        value: calories.toDouble(),
        color: Colors.red,
        title: 'Calories',
        radius: 40,
        titleStyle: const TextStyle(
            fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black),
        badgeWidget: Text('$calories cal'),
        badgePositionPercentageOffset: .98,
      ));
    });

    return PieChart(
      PieChartData(
        sections: pieChartSections,
        centerSpaceRadius: 100,
        sectionsSpace: 0,
        startDegreeOffset: -90,
        borderData: FlBorderData(show: false),
        centerSpaceColor: Colors.white,
        // pieTouchData: PieTouchData(touchCallback: (pieTouchResponse) {}),
      ),
    );
  }

  // Widget buildLineChart() {
  //   List<FlSpot> lineChartData = [];
  //   Map<String, List<int>> dateDataMap = {};

  //   // Aggregate proteins and calories for each date
  //   if (mealFoods != null) {
  //     for (var i = 0; i < mealFoods!.length; i++) {
  //       var data = mealFoods![i];
  //       String date = data['date'] ?? '';
  //       int proteins = data['proteins'] ?? 0;
  //       int calories = data['calories'] ?? 0;

  //       if (!dateDataMap.containsKey(date)) {
  //         dateDataMap[date] = [proteins, calories];
  //       } else {
  //         dateDataMap[date]![0] += proteins;
  //         dateDataMap[date]![1] += calories;
  //       }
  //     }
  //   }

  //   // Populate lineChartData based on aggregated data
  //   int index = 0;
  //   dateDataMap.forEach((date, values) {
  //     int proteins = values[0];
  //     int calories = values[1];

  //     lineChartData.add(FlSpot(index.toDouble(), proteins.toDouble()));
  //     lineChartData.add(FlSpot(index.toDouble(), calories.toDouble()));
  //     index++;
  //   });

  //   return LineChart(
  //     LineChartData(
  //       lineBarsData: [
  //         LineChartBarData(
  //           spots: lineChartData,
  //           isCurved: true,
  //           colors: [Colors.blue, Colors.red],
  //           barWidth: 5,
  //           isStrokeCapRound: true,
  //           dotData: FlDotData(show: false),
  //           belowBarData: BarAreaData(show: false),
  //         ),
  //       ],
  //     ),
  //   );
  // }
}
