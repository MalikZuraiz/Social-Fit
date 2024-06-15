import 'package:flutter/material.dart';
import 'package:on_audio_query/on_audio_query.dart';

// ignore: must_be_immutable
class BuildSonglistView extends StatefulWidget {
  // ignore: prefer_typing_uninitialized_variables
  var musicProvider ;

  BuildSonglistView({super.key, required this.musicProvider});


  @override
  State<BuildSonglistView> createState() => _SonglistViewState();
}

class _SonglistViewState extends State<BuildSonglistView> {
  
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: widget.musicProvider.songs.length,
      itemBuilder: (context, index) {
        SongModel song = widget.musicProvider.songs[index];
        return Container(
          margin: const EdgeInsets.only(top: 7, left: 7, right: 7),
          padding: const EdgeInsets.only(top: 3, bottom: 3),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(7),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.shade600,
                spreadRadius: -4,
                blurRadius: 15,
                offset: const Offset(0, 5),
                blurStyle: BlurStyle.solid,
              ),
              const BoxShadow(
                color: Colors.white,
                offset: Offset(-5, 0),
              ),
            ],
          ),
          child: ListTile(
            title: Text(
              song.title,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            subtitle: Text(song.artist ?? 'Unknown Artist',
                style: const TextStyle(color: Colors.blue)),
            trailing: const Icon(Icons.more_vert, color: Colors.blue),
            leading: QueryArtworkWidget(
              id: widget.musicProvider.songs[index].id,
              type: ArtworkType.AUDIO,
            ),
            onTap: () async {
              widget.musicProvider.currentindex = index;
              widget.musicProvider
                  .playSongAtIndex(index); //change it to currentindex to check whether the glitch of playing previous showing net song resolves or not
              widget.musicProvider.changeplayervisibilty();
            },
          ),
        );
      },
    );
  }
}