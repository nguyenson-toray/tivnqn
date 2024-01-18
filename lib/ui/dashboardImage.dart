import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:tivnqn/global.dart';
import 'package:tivnqn/myFuntions.dart';

class DashboardImage extends StatefulWidget {
  const DashboardImage(
      {super.key, required this.title, required this.linkImageDirectly});
  final String title;
  final String linkImageDirectly;
  @override
  State<DashboardImage> createState() => _DashboardImageState();
}

class _DashboardImageState extends State<DashboardImage> {
  late Image imageDashboard;

  @override
  void initState() {
    // TODO: implement initState
    initImage(widget.linkImageDirectly);
    Timer.periodic(Duration(seconds: g.config.getReloadSeconds), (timer) async {
      DateTime time = DateTime.now();
      if (time.hour == 16 && time.minute >= 55)
        exit(0);
      else {
        g.configs = await g.sqlApp.sellectConfigs();
      }
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          toolbarHeight: g.appBarH,
          backgroundColor: Colors.blue,
          elevation: 6.0,
          leadingWidth: 95,
          actions: [
            MyFuntions.clockAppBar(context),
            Text(
              DateFormat(g.dateFormat2).format(
                g.today,
              ),
              style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
            InkWell(
              child: Icon(
                Icons.refresh_sharp,
                color: Colors.amberAccent,
              ),
              onTap: () {
                updateImmage();
              },
            )
          ],
          leading: Image.asset(
            'assets/logo_white.png',
          ),
          centerTitle: true,
          title: Text(
            widget.title.toUpperCase(),
            style: TextStyle(
                fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
          ),
        ),
        body: Stack(
          children: [
            imageDashboard,
            Positioned(
                right: 2,
                bottom: 2,
                child: Text(
                  'Version : ${g.version}',
                  style: const TextStyle(
                      color: Colors.black,
                      fontSize: 6,
                      fontWeight: FontWeight.normal),
                ))
          ],
        ));
  }

  updateImmage() async {
    print('updateImmage');
    Uint8List bytes = (await NetworkAssetBundle(
      Uri.parse(widget.linkImageDirectly),
    ).load(widget.linkImageDirectly))
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
        errorBuilder: (context, error, stackTrace) => MyFuntions.loadFail());
  }
}
