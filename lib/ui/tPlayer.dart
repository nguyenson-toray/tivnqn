import 'dart:async';

import 'package:flu_wake_lock/flu_wake_lock.dart';
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
  FluWakeLock fluWakeLock = FluWakeLock();
  late YoutubePlayerController controller;
  bool isPlaying = false;
  String linkDoExercise =
      'https://www.youtube.com/watch?v=Sv7bkD9t9zU&t=8s&ab_channel=%E6%9D%B1%E6%80%A5%E5%BB%BA%E8%A8%AD%E5%85%AC%E5%BC%8F';

  String videoID = '';
  late DateTime exceriseBegin;
  late DateTime exceriseEnd;
  int timerPeriodic = 100;
  @override
  void initState() {
    fluWakeLock.enable();
    DateTime currentTime = DateTime.now();
    exceriseBegin = DateTime.parse("${g.todayString} " + "07:44:57");
    exceriseEnd = exceriseBegin.add(Duration(seconds: 215));
    videoID = YoutubePlayer.convertUrlToId(linkDoExercise)!;
    controller = YoutubePlayerController(
      initialVideoId: videoID,
      flags: YoutubePlayerFlags(
        loop: false,
        mute: true,
        autoPlay: false,
      ),
    );
    if (currentTime.isAfter(exceriseEnd)) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => StartPage()),
      );
    } else {
      Timer.periodic(Duration(milliseconds: timerPeriodic), (timer) {
        currentTime = DateTime.now();
        if (currentTime.isAfter(exceriseBegin) &&
            currentTime.isBefore(exceriseEnd) &&
            !isPlaying) {
          {
            controller.play();
            isPlaying = true;
            print('PLAY AT : ' + DateTime.now().toString());
          }
        }
      });
    }

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
        onEnded: (metaData) {
          controller.pause();
          controller.dispose();
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => StartPage()),
          );
        },
      ),
    );
  }
}
