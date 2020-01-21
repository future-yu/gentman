import 'package:flutter/material.dart';
import 'package:gentman/api/AppRemote.dart';
import 'package:gentman/route/AppRouter.dart';

class NetImage extends StatelessWidget {
  final String url;
  final Map<String, String> headers;
  final double height;
  final double width;
  final String detail_target;

  NetImage(
    this.url, {
    this.headers,
    this.width,
    this.height,
    this.detail_target,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      padding: EdgeInsets.zero,
      iconSize: width,
      icon: Image.network(
        url,
        loadingBuilder: (
          BuildContext context,
          Widget widget,
          ImageChunkEvent chunk,
        ) {
          if (chunk == null) {
            return widget;
          } else {
            return CircularProgressIndicator(
              backgroundColor: Colors.grey[200],
              valueColor: AlwaysStoppedAnimation(Colors.blue),
              value: chunk.expectedTotalBytes != null
                  ? chunk.cumulativeBytesLoaded / chunk.expectedTotalBytes
                  : null,
            );
          }
        },
        width: width,
        height: height,
        fit: BoxFit.cover,
        headers: headers,
      ),
      onPressed: () {
        if (this.detail_target != null) {
          AppRouter.router.navigateTo(
            context,
            "/image/detail?target=${Uri.encodeComponent(detail_target)}",
          );
        }
      },
    );
  }
}
