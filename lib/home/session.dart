// ignore_for_file: unused_local_variable

import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:social_fit/home/bodyPart.dart';
import 'package:social_fit/home/database.dart' as db;
import 'package:social_fit/home/excercise.dart';

import 'landing/layout.dart';
import 'landing/results.dart';

class Session extends StatefulWidget {
  const Session(
      {super.key,
      required this.selectedBodyParts,
      required this.onGoingSession});

  final List<String> selectedBodyParts;

  final OnGoingSession? onGoingSession;

  @override
  State<Session> createState() => _SessionState();
}

String strDigits(int n) => n.toString().padLeft(2, '0');

class _SessionState extends State<Session> {
  List<String> get selectedBodyParts => widget.onGoingSession == null
      ? widget.selectedBodyParts
      : widget.onGoingSession!.selectedBodyParts;
  List<BodyPartData> bodyPartData = [];
  List<ExcerciseInfo> excerciseInfo = [];
  Timer? timer;
  DateTime? startTime;
  bool dialogOpen = false;
  Duration duration = const Duration(seconds: 0);
  @override
  void initState() {
    super.initState();
    if (widget.onGoingSession != null) {
      startTime = widget.onGoingSession!.startTime;
      duration = widget.onGoingSession!.duration;
      setState(() {
        excerciseInfo = widget.onGoingSession!.excerciseInfo;
      });
      setUpTimer();
      return;
    }
    startTime = DateTime.now();
    duration = const Duration(seconds: 0);
    setUpTimer();
  }

  void setUpTimer() {
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        duration = DateTime.now().difference(startTime!);
      });
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  void addExcerciseInfo(ExcerciseInfo newExcerciseInfo, bool cancel) {
    setState(() {
      int index = excerciseInfo.indexWhere(
          (element) => element.excercise == newExcerciseInfo.excercise);
      if (index != -1) {
        if (cancel == true) {
          excerciseInfo.removeAt(index);
          return;
        }
        excerciseInfo[index] = newExcerciseInfo;
        return;
      }
      if (cancel == true) return;
      excerciseInfo.add(newExcerciseInfo);
    });
  }

  void addBodyPartData(BodyPartData newBodyPartData) {
    if (bodyPartData.contains(newBodyPartData)) {
      return;
    }
    bodyPartData.add(newBodyPartData);
  }

  List<Widget> getTabs() {
    List<Widget> tabs = [];
    for (var i = 0; i < selectedBodyParts.length; i++) {
      int totalExcercises = 0;
      if (bodyPartData.length > i) {
        for (var element in bodyPartData[i].excercises) {
          if (excerciseInfo.any((excerciseInfo) =>
              excerciseInfo.excercise.name == element.name)) {
            totalExcercises++;
          }
        }
      }
      String addon = '';
      if (totalExcercises > 0) {
        addon = '($totalExcercises)';
      }
      tabs.add(Tab(
        text: '${selectedBodyParts[i]} $addon',
      ));
    }
    return tabs;
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: selectedBodyParts.length,
      animationDuration: const Duration(milliseconds: 500),
      initialIndex: 0,
      child: Scaffold(
          appBar: AppBar(
            toolbarHeight: 100,
            elevation: 0,
            centerTitle: true,
            title: Column(
              children: [
                const Text(
                  "Session has started",
                  style: TextStyle(color: Colors.white),
                ),
                Text(
                  "${strDigits(duration.inHours.remainder(60))}h ${strDigits(duration.inMinutes.remainder(60))}m ${strDigits(duration.inSeconds.remainder(60))}s",
                  style: const TextStyle(color: Colors.white, fontSize: 12),
                ),
              ],
            ),
            bottom: PreferredSize(
                preferredSize: const Size.fromHeight(45),
                child: Column(
                  children: [
                    TabBar(
                      tabs: <Widget>[
                        ...getTabs(),
                      ],
                      isScrollable: true,
                      labelPadding: EdgeInsets.symmetric(
                          horizontal:
                              (MediaQuery.of(context).size.width / 6) - 20),
                      indicatorColor: Colors.white,
                      dividerColor: Colors.transparent,
                      labelColor: Colors.white,
                      unselectedLabelColor: Colors.white.withOpacity(0.7),
                      indicator: UnderlineTabIndicator(
                        borderSide:
                            const BorderSide(color: Colors.white, width: 2.25),
                        insets: EdgeInsets.symmetric(
                            horizontal:
                                MediaQuery.of(context).size.width / 4 - 30,
                            vertical: 0),
                      ),
                    ),
                    Container(
                      alignment: Alignment.bottomCenter,
                      height: 10,
                      decoration: const BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(20),
                            bottomRight: Radius.circular(20)),
                      ),
                    )
                  ],
                )),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () {
                if (widget.onGoingSession == null) {
                  Navigator.of(context).pop();
                  Navigator.of(context).pop();
                } else if (selectedBodyParts.isEmpty || excerciseInfo.isEmpty) {
                  Navigator.of(context).pop();
                  Navigator.of(context).pop();
                  return;
                }
                dynamic ses;
                OnGoingSession s = OnGoingSession(
                    startTime: startTime ?? DateTime.now(),
                    duration: duration,
                    excerciseInfo: excerciseInfo,
                    selectedBodyParts: selectedBodyParts);
                SessionReturned r = SessionReturned(
                    onGoingSession: s, finished: false, session: null);
                Navigator.of(context).pop(r);
              },
            ),
            backgroundColor: Colors.blue,
          ),
          body: TabBarView(
            children: <Widget>[
              for (var bodyPart in selectedBodyParts)
                BodyPart(
                    bodyPartDataList: bodyPartData,
                    title: bodyPart,
                    onGoingSession: widget.onGoingSession != null,
                    duration: duration,
                    excerciseInfo: excerciseInfo,
                    addExcerciseInfo: addExcerciseInfo,
                    addBodyPartData: addBodyPartData,
                    bodyPartData: bodyPartData.firstWhere(
                        (element) => element.bodyPart == bodyPart,
                        orElse: () =>
                            BodyPartData(bodyPart: '', excercises: []))),
            ],
          )),
    );
  }

  showAlertDialog(
      BuildContext context, List<ExcerciseInfo> data, int duration) {
    // set up the buttons
    Widget cancelButton = TextButton(
      child: const Text("Cancel"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );
    Widget removeButton = TextButton(
      child: const Text("Remove"),
      onPressed: () {
        Navigator.of(context).pop();
        Navigator.of(context).pop();
      },
    );
    Widget saveButton = TextButton(
      child: const Text("finish"),
      onPressed: () {
        db.Session session = db.Session(
            date: DateTime.now().millisecondsSinceEpoch, duration: duration);
        session.excerciseInfo = data;
        Navigator.of(context).push(CupertinoPageRoute(
            builder: (context) => PostSessionResults(
                session: session,
                bodyParts: bodyPartData,
                onGoingSession: true)));
      },
    );
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: const Text("Session Workout"),
      content: const Text(
          "You can choose to save the workout or remove it from the history."),
      actions: [
        cancelButton,
        removeButton,
        saveButton,
      ],
    );
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
    // show the dialog
  }
}
