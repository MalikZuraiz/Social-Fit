import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class YoutubeScreen extends StatefulWidget {
  final String testURL;
  final String videoTitle;

  const YoutubeScreen({super.key, required this.testURL, required this.videoTitle});

  @override
  State<YoutubeScreen> createState() => _YoutubeScreenState();
}

class _YoutubeScreenState extends State<YoutubeScreen> {
  late YoutubePlayerController _controller;
  late bool isInternetAvailable = true;
  bool isPlaying = false;

  @override
  void initState() {
    super.initState();
    final videoID = YoutubePlayer.convertUrlToId(widget.testURL);
    checkInternetConnection();

    _controller = YoutubePlayerController(
      initialVideoId: videoID!,
      flags: const YoutubePlayerFlags(
        autoPlay: true,
        disableDragSeek: true,
        loop: true,
        controlsVisibleAtStart: true,
        enableCaption: true,
      ),
    )..addListener(listener);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void listener() {
    setState(() {
      isPlaying = _controller.value.isPlaying;
    });
  }

  Future<void> checkInternetConnection() async {
    var connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult == ConnectivityResult.none) {
      setState(() {
        isInternetAvailable = false;
      });
    } else {
      setState(() {
        isInternetAvailable = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.videoTitle),
          backgroundColor: Colors.blue,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ),
        body: GestureDetector(
          onTap: () {
            if (isPlaying) {
              _controller.pause();
            } else {
              _controller.play();
            }
          },
          child: Stack(
            alignment: Alignment.center,
            children: [
              YoutubePlayerBuilder(
            player: YoutubePlayer(
              controller: _controller,
              bottomActions: const [],
            ),
            builder: (context, player) {
              return SizedBox(
                height: MediaQuery.of(context).size.height, // Adjust the height as needed
                child: player,
              );
                }),
              if (!isInternetAvailable)
                Container(
                  color: Colors.black.withOpacity(0.5),
                  child: const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.signal_wifi_off,
                          size: 50,
                          color: Colors.red,
                        ),
                        SizedBox(height: 10),
                        Text(
                          'No Internet Connection',
                          style: TextStyle(fontSize: 18, color: Colors.red),
                        ),
                        SizedBox(height: 10),
                        Text(
                          'Please check your internet connection and try again.',
                          style: TextStyle(fontSize: 14, color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
