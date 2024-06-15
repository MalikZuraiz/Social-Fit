// ignore_for_file: file_names, depend_on_referenced_packages, use_key_in_widget_constructors, library_private_types_in_public_api, prefer_interpolation_to_compose_strings, avoid_print, prefer_if_null_operators

import 'package:social_fit/posturefit/services/render_data_yoga.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'dart:math';

import 'package:social_fit/posturefit/services/camera.dart';
import 'package:tflite/tflite.dart';

class PushedPageY extends StatefulWidget {
  final List<CameraDescription> cameras;
  final String title;
  const PushedPageY({required this.cameras, required this.title});
  @override
  _PushedPageYState createState() => _PushedPageYState();
}

class _PushedPageYState extends State<PushedPageY> {
  late List<dynamic> _data = [];
  int _imageHeight = 0;
  int _imageWidth = 0;
  int x = 1;

  @override
  void initState() {
    super.initState();
    var res = loadModel();
    print('Model Response: ' + res.toString());
  }

  _setRecognitions(data, imageHeight, imageWidth) {
    if (!mounted || data == null) {
      return;
    }
    setState(() {
      _data = data;
      _imageHeight = imageHeight;
      _imageWidth = imageWidth;
    });
  }

  loadModel() async {
    return await Tflite.loadModel(
        model: "assets/posenet_mv1_075_float_from_checkpoints.tflite");
  }

  @override
  Widget build(BuildContext context) {
    Size screen = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: const Text('FitPosture Warrior Pose'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Stack(
        children: <Widget>[
          Camera(
            cameras: widget.cameras,
            setRecognitions: _setRecognitions,
          ),
          RenderDataYoga(
            // ignore: unnecessary_null_comparison
            data: _data == null ? [] : _data,
            previewH: max(_imageHeight, _imageWidth),
            previewW: min(_imageHeight, _imageWidth),
            screenH: screen.height,
            screenW: screen.width,
          ),
        ],
      ),
    );
  }
}
