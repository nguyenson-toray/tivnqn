import 'dart:async';

import 'package:flu_wake_lock/flu_wake_lock.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
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
  String debugText = '';
  bool isPlaying = false;
  String linkDoExercise =
      'https://www.youtube.com/watch?v=Sv7bkD9t9zU&t=8s&ab_channel=%E6%9D%B1%E6%80%A5%E5%BB%BA%E8%A8%AD%E5%85%AC%E5%BC%8F';

  String videoID = '';
  late DateTime playerReadyTime;
  bool playerIsReady = false;

  late DateTime exceriseBegin;
  late DateTime exceriseEnd;
  int timerPeriodic = 50;
  late DateTime currentTime;
  @override
  void initState() {
    exceriseBegin = DateTime.parse("${g.todayString} " + "07:45:00.500");
    exceriseEnd = exceriseBegin.add(Duration(seconds: 215));
    videoID = YoutubePlayer.convertUrlToId(linkDoExercise)!;
    fluWakeLock.enable();
    controller = YoutubePlayerController(
      initialVideoId: videoID,
      flags: YoutubePlayerFlags(
        loop: false,
        mute: true,
        autoPlay: false,
      ),
    );
    currentTime = DateTime.now();

    if (currentTime.isAfter(exceriseEnd)) {
      Future.delayed(const Duration(microseconds: 200)).then((val) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const StartPage()),
        );
      });
    } else {
      debugText = "Start app: ${currentTime} - Set play time: ${exceriseBegin}";

      Timer.periodic(Duration(milliseconds: timerPeriodic), (timer) {
        currentTime = DateTime.now();
        if (currentTime.isAfter(exceriseBegin) &&
            currentTime.isBefore(exceriseEnd) &&
            !isPlaying &&
            playerIsReady) {
          {
            print("---------Jump to second :" +
                Duration(
                        seconds:
                            playerReadyTime.difference(exceriseBegin).inSeconds)
                    .toString());
            playerReadyTime.isAfter(exceriseBegin)
                ? controller.seekTo(Duration(
                    seconds:
                        playerReadyTime.difference(exceriseBegin).inSeconds))
                : controller.play();
            isPlaying = true;
            setState(() {
              currentTime = DateTime.now();
              debugText += " - Actual play at: ${currentTime}";
            });
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

  String getSystemTime() {
    var now = DateTime.now();
    return DateFormat("H:m:s").format(now);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          YoutubePlayer(
            controller: controller,
            showVideoProgressIndicator: true,
            progressIndicatorColor: Colors.amber,
            progressColors: ProgressBarColors(
              playedColor: Colors.amber,
              handleColor: Colors.amberAccent,
            ),
            onReady: () {
              print('Player is ready.');
              playerReadyTime = DateTime.now();
              setState(() {
                playerIsReady = true;
                debugText += " - Player ready at: ${playerReadyTime}";
              });
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
          Text(
            (currentTime.day <= 26 && currentTime.year == 2023)
                ? debugText
                : "",
            style: TextStyle(fontSize: 10),
          ),
        ],
      ),
    );
  }
}
