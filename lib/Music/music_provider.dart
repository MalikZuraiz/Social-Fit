import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:rxdart/rxdart.dart';

class MusicProvider extends ChangeNotifier {
  final OnAudioQuery audioQuery = OnAudioQuery();
  final AudioPlayer player = AudioPlayer();
  bool shufflemode = false;
  int currentindex = 0;

  List<SongModel> songs = [];
  bool isplayervisible = false;
  bool hasPermission = false;

  Stream<DurationState> get durationStateStream =>
      Rx.combineLatest2<Duration, Duration?, DurationState>(
        player.positionStream,
        player.durationStream,
        (position, duration) => DurationState(
          position: position,
          total: duration ?? Duration.zero,
        ),
      );

  void checkAndRequestPermissions({bool retry = false}) async {
    hasPermission = await audioQuery.checkAndRequest(
      retryRequest: retry,
    );
    notifyListeners();
  }

  void toast(BuildContext context, String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(msg),
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
    ));
  }

  ConcatenatingAudioSource createPlaylist(List<SongModel> songs) {
    List<AudioSource> sources = [];
    for (var song in songs) {
      sources.add(AudioSource.uri(Uri.parse(song.uri!)));
    }
    return ConcatenatingAudioSource(children: sources);
  }

  void changeplayervisibilty() {
    isplayervisible = !isplayervisible;
    notifyListeners();
  }

  void playSongAtIndex(int index) async {
    await player.setAudioSource(
      createPlaylist(songs),
      initialIndex: index,
    );
    await player.play();
    currentindex = index;
    notifyListeners();
  }

  void updateCurrentPlayingSongDetails(int index) {
    if (songs.isNotEmpty) {
      // currentsongTitle = songs[currentindex].title;
      currentindex = index;
      notifyListeners();
    }
  }
}

class DurationState {
  DurationState({this.position = Duration.zero, this.total = Duration.zero});
  Duration position, total;
}
