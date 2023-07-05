import 'package:flutter/material.dart';
import 'package:tivnqn/global.dart';

class ShowNotification extends StatelessWidget {
  const ShowNotification({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        g.setting.showNotification == 0
            ? Container()
            : Column(
                children: [
                  Text(
                    '${g.setting.getText}',
                    style: TextStyle(fontSize: 30),
                  ),
                  Container(
                      child: Image.network(
                    g.setting.getImgURL,
                    errorBuilder: (context, error, stackTrace) => Icon(
                      Icons.warning,
                    ),
                  )),
                ],
              ),
      ],
    );
  }
}
