import 'package:flutter/material.dart';

class TopPanel extends StatefulWidget {
  const TopPanel({super.key});

  @override
  State<TopPanel> createState() => _TopPanelState();
}

class _TopPanelState extends State<TopPanel> {
  @override
  Widget build(BuildContext context) {
    return Container(
      // color: Colors.blue[300],
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircleAvatar(
            backgroundColor: Colors.blueAccent,
            child: Text('1',
                style: TextStyle(fontSize: 27, fontWeight: FontWeight.bold)),
          )
        ],
      ),
    );
  }
}
