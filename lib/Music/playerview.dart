import 'package:social_fit/Music/music_provider.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';

// ignore: must_be_immutable
class BuildPlayerView extends StatefulWidget {
  // ignore: prefer_typing_uninitialized_variables
  var musicProvider;

  BuildPlayerView({super.key, required this.musicProvider});

  @override
  State<BuildPlayerView> createState() => _buildPlayerViewState();
}

// ignore: camel_case_types
class _buildPlayerViewState extends State<BuildPlayerView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.only(top: 50, right: 10, left: 10),
          decoration: const BoxDecoration(),
          child: Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                children: [
                  // Flexible(
                  //   child: InkWell(
                  //     onTap: () {
                  //       widget.musicProvider.updateCurrentPlayingSongDetails(
                  //           widget.musicProvider.currentindex);
                  //       widget.musicProvider.changeplayervisibilty();
                  //     },
                  //     child: Container(
                  //       padding: const EdgeInsets.all(10.0),
                  //     ),
                  //   ),
                  // ),
                  Flexible(
                    flex: 5,
                    child: Text(
                      widget.musicProvider
                          .songs[widget.musicProvider.currentindex].title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                  ),
                ],
              ),
              Container(
                width: 250,
                margin: const EdgeInsets.only(top: 50, bottom: 60),
                height: 250,
                decoration: getDecoration(
                  BoxShape.circle,
                  const Offset(2, 2),
                  2.0,
                  0.0,
                ),
                child: QueryArtworkWidget(
                  id: widget.musicProvider
                      .songs[widget.musicProvider.currentindex].id,
                  type: ArtworkType.AUDIO,
                  artworkBorder: BorderRadius.circular(200.0),
                ),
              ),
              Column(
                children: [
                  SizedBox(
                    height: 20,
                    child: StreamBuilder<DurationState>(
                      stream: widget.musicProvider.durationStateStream,
                      builder: (context, snapshot) {
                        final durationState = snapshot.data;
                        final progress =
                            durationState?.position ?? Duration.zero;
                        final total = durationState?.total ?? Duration.zero;

                        return ProgressBar(
                          progress: progress,
                          total: total,
                          barHeight: 3.0,
                          progressBarColor: Colors.blue,
                          thumbColor: Colors.blue,
                          thumbRadius: 5,
                          timeLabelTextStyle: const TextStyle(
                            fontSize: 0,
                            color: Colors.black,
                          ),
                          onSeek: (duration) {
                            widget.musicProvider.player.seek(duration);
                          },
                        );
                      },
                    ),
                  ),
                  StreamBuilder<DurationState>(
                    stream: widget.musicProvider.durationStateStream,
                    builder: (context, snapshot) {
                      final durationState = snapshot.data;
                      final progress = durationState?.position ?? Duration.zero;
                      final total = durationState?.total ?? Duration.zero;

                      return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Flexible(
                            child: Text(
                              progress.toString().split(".")[0],
                              style: const TextStyle(
                                color: Colors.black,
                                fontSize: 12,
                              ),
                            ),
                          ),
                          Flexible(
                            child: Text(
                              total.toString().split(".")[0],
                              style: const TextStyle(
                                color: Colors.black,
                                fontSize: 10,
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ],
              ),
              Container(
                margin: const EdgeInsets.only(top: 10, bottom: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Flexible(
                      child: InkWell(
                        onTap: () {
                          widget.musicProvider.player.loopMode == LoopMode.one
                              ? widget.musicProvider.player
                                  .setLoopMode(LoopMode.all)
                              : widget.musicProvider.player
                                  .setLoopMode(LoopMode.one);
                        },
                        child: StreamBuilder<LoopMode>(
                          stream: widget.musicProvider.player.loopModeStream,
                          builder: (context, snapshot) {
                            final loopMode = snapshot.data;
                            if (LoopMode.one == loopMode) {
                              return const Icon(
                                Icons.repeat_one,
                                color: Colors.blue,
                                size: 20,
                              );
                            }
                            return const Icon(
                              Icons.repeat,
                              color: Colors.blue,
                              size: 20,
                            );
                          },
                        ),
                      ),
                    ),
                    Flexible(
                      child: InkWell(
                        onTap: () {
                          if (widget.musicProvider.player.hasPrevious) {
                            int indexchanged =
                                widget.musicProvider.currentindex - 1;
                            widget.musicProvider
                                .updateCurrentPlayingSongDetails(indexchanged);
                            widget.musicProvider.player.seekToPrevious();
                          }
                        },
                        child: const Icon(
                          Icons.skip_previous,
                          color: Colors.blue,
                          size: 40,
                        ),
                      ),
                    ),
                    Flexible(
                      child: InkWell(
                        onTap: () {
                          if (widget.musicProvider.player.playing) {
                            widget.musicProvider.player.pause();
                          } else {
                            if (widget.musicProvider.player.currentIndex !=
                                null) {
                              widget.musicProvider.player.play();
                            }
                          }
                        },
                        child: StreamBuilder<bool>(
                          stream: widget.musicProvider.player.playingStream,
                          builder: (context, snapshot) {
                            bool? playingState = snapshot.data;
                            if (playingState != null && playingState) {
                              return const Icon(
                                Icons.pause,
                                size: 55,
                                color: Colors.blue,
                              );
                            }
                            return const Icon(
                              Icons.play_arrow,
                              size: 55,
                              color: Colors.blue,
                            );
                          },
                        ),
                      ),
                    ),
                    Flexible(
                      child: InkWell(
                        onTap: () {
                          if (widget.musicProvider.hasNext) {
                            int indexchanged =
                                widget.musicProvider.currentindex + 1;
                            widget.musicProvider
                                .updateCurrentPlayingSongDetails(indexchanged);
                            widget.musicProvider.player.seekToNext();
                          }
                        },
                        child: const Icon(
                          Icons.skip_next,
                          color: Colors.blue,
                          size: 40,
                        ),
                      ),
                    ),
                    Flexible(
                      child: InkWell(
                        onTap: () {
                          if (widget.musicProvider.shufflemode == false) {
                            widget.musicProvider.player
                                .setShuffleModeEnabled(true);
                            widget.musicProvider
                                .toast(context, "Shuffling enabled");
                          } else {
                            widget.musicProvider.player
                                .setShuffleModeEnabled(false);
                            widget.musicProvider
                                .toast(context, "Shuffling Dissabled");
                          }
                          widget.musicProvider.shufflemode =
                              !widget.musicProvider.shufflemode;
                        },
                        child: const Icon(
                          Icons.shuffle,
                          color: Colors.blue,
                          size: 20,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  BoxDecoration getDecoration(
      BoxShape shape, Offset offset, double blurRadius, double spreadRadius) {
    return BoxDecoration(
      shape: shape,
      boxShadow: [
        BoxShadow(
          offset: -offset,
          color: Colors.white24,
          blurRadius: blurRadius,
          spreadRadius: spreadRadius,
        ),
        BoxShadow(
          offset: offset,
          color: Colors.black,
          blurRadius: blurRadius,
          spreadRadius: spreadRadius,
        ),
      ],
    );
  }
}
