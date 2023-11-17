import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tivnqn/global.dart';
import 'package:tivnqn/myFuntions.dart';

class DashboardImage extends StatefulWidget {
  const DashboardImage({super.key});

  @override
  State<DashboardImage> createState() => _DashboardImageState();
}

class _DashboardImageState extends State<DashboardImage> {
  String linkImage = '';
  late Image imageDashboard;
  late bool refresh = false;
  late Uri uriFS;
  late File file;

  @override
  void initState() {
    // TODO: implement initState
    initImage(g.imgDashboardLink);
    Timer.periodic(Duration(minutes: 1), (timer) async {
      if (mounted) {
        setState(() {
          refresh = true;
          updateImmage();
          refresh = false;
        });

        if (DateTime.now().hour > 16 && DateTime.now().minute > 55) exit(0);
      }
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          toolbarHeight: 24,
          backgroundColor: Colors.blue,
          elevation: 6.0,
          leadingWidth: 95,
          actions: [
            Padding(
              padding: const EdgeInsets.all(2.0),
              child: Text(
                g.todayString,
                style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
            )
          ],
          leading: Image.asset(
            'assets/logo_white.png',
          ),
          centerTitle: true,
          // title: const Text(
          //   'PRODUCTION PLANNING',
          //   style: TextStyle(
          //       fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
          // ),
        ),
        body: Stack(alignment: Alignment.topCenter, children: [
          imageDashboard,
          Container(
            height: refresh ? 5 : 0,
            width: g.screenWidth,
            child: LinearProgressIndicator(),
          )
        ]));
  }

  updateImmage() async {
    print('updateImmage');
    Uint8List bytes = (await NetworkAssetBundle(
      Uri.parse(g.imgDashboardLink),
    ).load(g.imgDashboardLink))
        .buffer
        .asUint8List();
    if (bytes.isNotEmpty) {
      imageDashboard = Image.memory(bytes,
          fit: BoxFit.fill,
          alignment: Alignment.center,
          height: g.screenHeight - 24,
          width: g.screenWidth);
    }
  }

  Future<void> initImage(String url) async {
    print("initImage from url : $url");
    imageDashboard = Image.network(
        key: Key(url),
        fit: BoxFit.fill,
        alignment: Alignment.center,
        height: g.screenHeight - 24,
        width: g.screenWidth,
        url,
        loadingBuilder: (BuildContext context, Widget child,
            ImageChunkEvent? loadingProgress) {
          if (loadingProgress == null) {
            return child;
          }
          return Container(
            width: g.screenWidth,
            height: 5,
            child: LinearProgressIndicator(
              backgroundColor: Colors.white,
              color: Colors.tealAccent,
              value: loadingProgress.expectedTotalBytes != null
                  ? loadingProgress.cumulativeBytesLoaded /
                      loadingProgress.expectedTotalBytes!
                  : null,
            ),
          );
        },
        errorBuilder: (context, error, stackTrace) =>
            Text('Load failed ! Check URL & restart App'));
  }
}
