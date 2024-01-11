import 'dart:async';

import 'package:flu_wake_lock/flu_wake_lock.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tivnqn/myFuntions.dart';
import 'package:tivnqn/ui/startPage.dart';
import 'package:youtube_player_flutter_quill/youtube_player_flutter_quill.dart';
import 'package:tivnqn/global.dart';
import 'package:cron/cron.dart';

class TPlayer extends StatefulWidget {
  const TPlayer({super.key});

  @override
  State<TPlayer> createState() => _TPlayerState();
}

class _TPlayerState extends State<TPlayer> {
  FluWakeLock fluWakeLock = FluWakeLock();
  late YoutubePlayerController controller;
  var cron = new Cron();
  String debugText = '';
  bool isPlaying = false;
  String linkDoExercise =
      'https://www.youtube.com/watch?v=Sv7bkD9t9zU&t=8s&ab_channel=%E6%9D%B1%E6%80%A5%E5%BB%BA%E8%A8%AD%E5%85%AC%E5%BC%8F';

  String videoID = '';
  late DateTime playerReadyTime;
  bool playerIsReady = false;

  late DateTime exceriseBegin;
  late DateTime exceriseEnd;
  late DateTime currentTime;
  Duration seekTime = Duration(milliseconds: 0);
  late int hour;
  late int minute;
  String hourString = "07";
  String minuteString = "45";
  @override
  void initState() {
    hour = int.parse(hourString);
    minute = int.parse(minuteString);
    exceriseBegin =
        DateTime.parse("${g.todayString} " + "$hourString:$minuteString:00");
    exceriseEnd = exceriseBegin.add(Duration(seconds: 215));
    videoID = YoutubePlayer.convertUrlToId(linkDoExercise)!;
    fluWakeLock.enable();
    controller = YoutubePlayerController(
      initialVideoId: videoID,
      flags: YoutubePlayerFlags(
        hideControls: true,
        loop: false,
        mute: false,
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
      debugText = "Start app: ${currentTime}   Set play at $hour: $minute";
      cron.schedule(Schedule.parse("${minute} $hour * * * "), () async {
        //30 2 * * * [command]This will run once a day, at 2:30 am.

        if (!isPlaying && playerIsReady) {
          controller.play();
          setState(() {
            currentTime = DateTime.now();
            isPlaying = true;
            currentTime = DateTime.now();
            debugText += " - Actual play at: ${currentTime}";
          });
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
              debugText += " - Player Ready at: ${playerReadyTime}";
              setState(() {
                playerIsReady = true;
                if (playerReadyTime.isAfter(exceriseBegin)) {
                  seekTime = Duration(
                      milliseconds: playerReadyTime
                          .difference(exceriseBegin)
                          .inMilliseconds);
                  debugText +=
                      " - seekTime (inMilliseconds): ${seekTime.inMilliseconds}  (inSeconds): ${seekTime.inSeconds}";
                  controller.seekTo(seekTime);
                  setState(() {
                    currentTime = DateTime.now();
                    isPlaying = true;
                    currentTime = DateTime.now();
                    debugText += " - Actual play at: ${currentTime}";
                  });
                }
              });
            },
            onEnded: (metaData) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const StartPage()),
              );
            },
          ),
          Positioned(
              top: 10,
              left: 10,
              child: Text(
                debugText,
                style: TextStyle(fontSize: 10),
              )),
          Positioned(
              bottom: 10, right: 10, child: MyFuntions.getClock(context)),
        ],
      ),
    );
  }
}
