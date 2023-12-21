import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:tivnqn/ui/startPage.dart';
import 'package:youtube_player_flutter_quill/youtube_player_flutter_quill.dart';
import 'package:tivnqn/global.dart';

class TPlayer extends StatefulWidget {
  const TPlayer({super.key});

  @override
  State<TPlayer> createState() => _TPlayerState();
}

class _TPlayerState extends State<TPlayer> {
  late YoutubePlayerController controller;
  bool isPlaying = false;
  String linkDoExercise =
      'https://www.youtube.com/watch?v=Sv7bkD9t9zU&t=8s&ab_channel=%E6%9D%B1%E6%80%A5%E5%BB%BA%E8%A8%AD%E5%85%AC%E5%BC%8F';

  String videoID = '';

  @override
  void initState() {
    DateTime currentTime = DateTime.now();
    videoID = YoutubePlayer.convertUrlToId(linkDoExercise)!;
    controller = YoutubePlayerController(
      initialVideoId: videoID,
      flags: YoutubePlayerFlags(
        mute: true,
        autoPlay: false,
      ),
    );
    Timer.periodic(Duration(milliseconds: 500), (timer) {
      currentTime = DateTime.now();
      print('currentTime : ' + currentTime.toIso8601String());
      print('isPlaying : ' + isPlaying.toString());
      if (currentTime.hour == 7) {
        if (currentTime.minute == 45 && !isPlaying) {
          {
            controller.play();
            isPlaying = true;
          }
        }
        if (currentTime.minute >= 49) {
          changeNextpage();
        }
      } else {
        changeNextpage();
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    controller.dispose();
    super.dispose();
  }

  void changeNextpage() {
    controller.pause();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => StartPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: YoutubePlayer(
        controller: controller,
        showVideoProgressIndicator: true,
        progressIndicatorColor: Colors.amber,
        progressColors: ProgressBarColors(
          playedColor: Colors.amber,
          handleColor: Colors.amberAccent,
        ),
        onReady: () {
          print('Player is ready.');
        },
      ),
    );
  }
}
