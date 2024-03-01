// import 'package:flutter/material.dart';
// import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
// import 'package:tivnqn/global.dart';
// import 'package:tivnqn/myFuntions.dart';

// class Screen4EtsWorkLayer extends StatefulWidget {
//   const Screen4EtsWorkLayer({super.key});

//   @override
//   State<Screen4EtsWorkLayer> createState() => _Screen4EtsWorkLayerState();
// }

// class _Screen4EtsWorkLayerState extends State<Screen4EtsWorkLayer> {
//   @override
//   Widget build(BuildContext context) {
//     return g.workSummary.isEmpty
//         ? MyFuntions.noData()
//         : SizedBox(
//             height: g.screenHeight - g.appBarH,
//             width: g.screenWidth,
//             child: MasonryGridView.count(
//               padding: const EdgeInsets.all(2),
//               itemCount: g.chartUiWorkLayers.length,
//               itemBuilder: (BuildContext context, int index) {
//                 return Container(
//                     height: g.screenHeight / g.workLayerNames.length - 12,
//                     width: g.screenWidth / 2,
//                     child: g.chartUiWorkLayers[index]);
//               },
//               crossAxisCount: 1,
//             ),
//           );
//   }
// }
