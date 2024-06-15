// ignore_for_file: avoid_print

import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class SpeedWidget extends StatefulWidget {
  const SpeedWidget({super.key});

  @override
  State<SpeedWidget> createState() => _SpeedWidgetState();
}

class _SpeedWidgetState extends State<SpeedWidget> {
  double speed = 0;
  double speedAcurancy = 0;

  bool paused = false;
  bool started = false;

  double latitude = 0;
  double longtitude = 0;

  double movement = 0;

  double distance = 0.0;
  int duration = 0;
  int durationFilter = 0;

  Timer? timer;

  Position? latestPosition;

  StreamSubscription<Position>? _speedStream;

  final distanceTimeout = 2000;

  late final androidSettings = AndroidSettings(
    forceLocationManager: true,
    intervalDuration: Duration(milliseconds: distanceTimeout),
    accuracy: LocationAccuracy.bestForNavigation,
    timeLimit: const Duration(seconds: 60),
  );

  Future<void> trackSpeed() async {
    if (timer != null && timer?.isActive == false) {
      timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        if (paused) return;
        if (latestPosition != null &&
            ((latestPosition!.timestamp.millisecondsSinceEpoch +
                    distanceTimeout) <
                DateTime.now().millisecondsSinceEpoch)) {
          setState(() {
            speedAcurancy = 0;
          });
        }
        setState(() {
          duration++;
          durationFilter++;
        });
      });
    }
    timer ??= Timer.periodic(const Duration(seconds: 1), (timer) {
      if (paused) return;
      if (latestPosition != null &&
          ((latestPosition!.timestamp.millisecondsSinceEpoch + 2000) <
              DateTime.now().millisecondsSinceEpoch)) {
        setState(() {
          speedAcurancy = 0;
        });
      }
      setState(() {
        duration++;
        durationFilter++;
      });
    });
    LocationPermission permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      return;
    }
    _speedStream =
        Geolocator.getPositionStream(locationSettings: androidSettings).listen(
      (position) {
        setState(() {
          speedAcurancy = position.speedAccuracy;
          // speed = position.speed;
        });
        if (paused || latestPosition == null) {
          latestPosition = position;
          distance += position.speedAccuracy;
          return;
        }
        setState(() {
          longtitude = latestPosition!.longitude - position.longitude;
          latitude = latestPosition!.latitude - position.latitude;
          if (durationFilter < 20) {
            distance += position.speedAccuracy;
          }
          distance += Geolocator.distanceBetween(latestPosition!.latitude,
              latestPosition!.longitude, position.latitude, position.longitude);
          speed = (Geolocator.distanceBetween(
                  latestPosition!.latitude,
                  latestPosition!.longitude,
                  position.latitude,
                  position.longitude) /
              2);
        });
        latestPosition = position;
      },
    );
    _speedStream?.onError((err) async {
      print('error: $err');
      setState(() {
        speed = 0;
        speedAcurancy = 0;
        durationFilter = 0;
        movement = 0;
      });
      await _speedStream?.cancel();
      await trackSpeed();
    });
  }

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  void dispose() {
    _speedStream?.cancel();
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text('Your Run'),
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(
              height: 100,
            ),
            Column(
              children: [
                Text(
                  (distance / 1000).toStringAsFixed(3),
                  style: const TextStyle(
                      fontSize: 84, fontWeight: FontWeight.bold),
                ),
                Text(
                  'Distance (Km)',
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.blue[300]),
                ),
              ],
            ),
            const SizedBox(
              height: 50,
            ),
            Metrics(
                durationFilter: durationFilter,
                duration: duration,
                distance: distance,
                speed: speed,
                speedAcurancy: speed),
            const SizedBox(
              height: 100,
            ),
            SizedBox(
              height: 125,
              width: MediaQuery.of(context).size.width,
              child: Stack(
                alignment: AlignmentDirectional.center,
                children: [
                  (started && paused)
                      ? Positioned(
                          left: MediaQuery.of(context).size.width * 0.175,
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                started = false;
                                paused = false;
                                _speedStream?.cancel();
                                timer?.cancel();
                              });
                            },
                            child: Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                  color: Colors.blue[300],
                                  borderRadius: BorderRadius.circular(100)),
                              child: const Icon(
                                Icons.stop,
                                color: Colors.white,
                                size: 32,
                              ),
                            ),
                          ),
                        )
                      : const SizedBox(),
                  GestureDetector(
                    onTap: () async {
                      if (!started) {
                        setState(() {
                          started = true;
                          speed = 0;
                          speedAcurancy = 0;
                          durationFilter = 0;
                          duration = 0;
                          distance = 0;
                        });
                        await trackSpeed();
                        return;
                      }
                      setState(() {
                        paused = !paused;
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                          color: Colors.blue,
                          borderRadius: BorderRadius.circular(100)),
                      child: Icon(
                        (started && !paused) ? Icons.pause : Icons.play_arrow,
                        color: Colors.white,
                        size: started ? 48 : 72,
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ));
  }
}

class Metrics extends StatefulWidget {
  const Metrics(
      {super.key,
      required this.duration,
      required this.durationFilter,
      required this.distance,
      required this.speedAcurancy,
      required this.speed});

  final int duration;
  final int durationFilter;
  final double speed;
  final double speedAcurancy;
  final double distance;

  @override
  State<Metrics> createState() => _MetricsState();
}

class _MetricsState extends State<Metrics> {
  double get speed => widget.speed;
  double get speedAccurancy => widget.speedAcurancy;
  double get distance => widget.distance;
  int get duration => widget.duration;
  List<double> speeds = [];
  List<double> speedsAccurancy = [];

  String getCurrentPaceAccurancy() {
    if (duration == 0 || distance == 0) return "--";
    double avgSpeed = speedsAccurancy.isNotEmpty
        ? speedsAccurancy.reduce((value, element) => value + element) /
            speedsAccurancy.length
        : speedAccurancy;
    if (avgSpeed <= 0.001) return "--";
    double pace = 1000 / avgSpeed;
    int minutes = (pace / 60).floor();
    if (minutes > 30) return "0'00''";
    int seconds = (pace % 60).floor();
    return "${minutes.toString().padLeft(2, '0')}'${seconds.toString().padLeft(2, '0')}''";
  }

  @override
  void didUpdateWidget(covariant Metrics oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.duration == oldWidget.duration) return;
    if (widget.durationFilter < 20) return;
    if (speedsAccurancy.length >= 10) {
      speedsAccurancy.removeAt(0);
    }
    speedsAccurancy.add(speedAccurancy);
  }

  String formatDuration() {
    int seconds = duration % 60;
    int minutes = (duration / 60).floor();
    int hours = (duration / 3600).floor();
    return '${hours >= 1 ? '${hours.toString().padLeft(2, '0')}:' : ''}${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  String getAvgPace() {
    if (duration == 0 || distance == 0 || distance < 0.1) return "--";
    double offset = 1000 / max(1, duration - 20);
    double pace = offset * duration;
    int minutes = (pace / 60).floor();
    if (minutes > 30) return "0'00''";
    int seconds = (pace % 60).floor();
    return "${minutes.toString().padLeft(2, '0')}'${seconds.toString().padLeft(2, '0')}''";
  }

  String getKMPerHour() {
    return (speed * 3.6).toStringAsFixed(1);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Column(
          children: [
            Text(
              getCurrentPaceAccurancy(),
              style: const TextStyle(fontSize: 36, fontWeight: FontWeight.bold),
            ),
            Text(
              'Your Pace',
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: Colors.grey[400]),
            ),
          ],
        ),
        Column(
          children: [
            Text(
              formatDuration(),
              style: const TextStyle(fontSize: 36, fontWeight: FontWeight.bold),
            ),
            Text(
              'Duration',
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: Colors.grey[400]),
            ),
          ],
        ),
        Column(
          children: [
            Text(
              getAvgPace(),
              style: const TextStyle(fontSize: 36, fontWeight: FontWeight.bold),
            ),
            Text(
              'AVG Pace',
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: Colors.grey[400]),
            ),
          ],
        ),
      ],
    );
  }
}
