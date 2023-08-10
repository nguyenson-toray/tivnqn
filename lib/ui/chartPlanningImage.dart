import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tivnqn/myFuntions.dart';
import 'package:tivnqn/global.dart';
import 'package:tivnqn/ui/chartPlanningUI.dart';

class ChartPlanningImage extends StatefulWidget {
  const ChartPlanningImage({super.key});

  @override
  State<ChartPlanningImage> createState() => _ChartPlanningImageState();
}

class _ChartPlanningImageState extends State<ChartPlanningImage> {
  final scrollController = ScrollController();
  double offset = 0.0;
  @override
  void initState() {
    // TODO: implement initState
    offset = g.screenWidth / 4;
    Timer(const Duration(seconds: 6), () async {
      // scrollController.jumpTo(offset);
    });
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
            Text(
              g.todayString,
              style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            )
          ],
          leading: Image.asset(
            'assets/logo_white.png',
          ),
          centerTitle: true,
          title: const Text(
            'PRODUCTION PLANNING',
            style: TextStyle(
                fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          // leading: InkWell(
          //     onTap: () {
          //       Navigator.pushReplacement(
          //         context,
          //         MaterialPageRoute(builder: (context) => ChartPlanningUI()),
          //       );
          //     },
          //     child: Icon(
          //       Icons.change_circle,
          //       color: Colors.white,
          //     )),
        ),
        body: Stack(children: [
          RawKeyboardListener(
            focusNode: FocusNode(),
            autofocus: true,
            onKey: (event) {
              if (event.isKeyPressed(LogicalKeyboardKey.arrowRight)) {
                if (scrollController.offset <
                    scrollController.position.maxScrollExtent) {
                  offset = offset + 250.0;
                } else {
                  offset = scrollController.position.maxScrollExtent;
                }
              }
              if (event.isKeyPressed(LogicalKeyboardKey.arrowLeft)) {
                if (scrollController.offset >
                    scrollController.position.minScrollExtent) {
                  offset = offset - 250.0;
                } else {
                  offset = 0;
                }
              }
              scrollController.jumpTo(offset);
            },
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              controller: scrollController,
              child: Container(
                  child: Image.network(
                      height: g.screenHeight - 24,
                      MyFuntions.getLinkImage(g.appSetting.planningURL),
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
                            color: Colors.teal,
                            value: loadingProgress.expectedTotalBytes != null
                                ? loadingProgress.cumulativeBytesLoaded /
                                    loadingProgress.expectedTotalBytes!
                                : null,
                          ),
                        );
                      },
                      errorBuilder: (context, error, stackTrace) =>
                          Text('Load failed !'))),
            ),
          ),
          Container(
              color: Colors.white,
              child: Image.network(
                  alignment: Alignment.centerLeft,
                  fit: BoxFit.fitHeight,
                  height: g.screenHeight - 24,
                  width: 28,
                  MyFuntions.getLinkImage(g.appSetting.planningURL),
                  errorBuilder: (context, error, stackTrace) =>
                      Text('Load failed !'))),
          Align(
              alignment: Alignment.bottomCenter,
              child: Text(
                'Use the LEFT - RIGHT arrow buttons on the remote to scroll.',
                style: TextStyle(
                    fontSize: 8,
                    color: Colors.black,
                    fontWeight: FontWeight.normal),
              )),
        ]));
  }
}
