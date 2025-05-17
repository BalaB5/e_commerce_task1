import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class NetworkImageLoader extends StatelessWidget {
  const NetworkImageLoader(this.imageUrl,
      {super.key, this.fit, this.height, this.width});

  final String imageUrl;
  final BoxFit? fit;
  final double? width;
  final double? height;

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: imageUrl,
      width: width,
      height: height,
      fit: fit,
      progressIndicatorBuilder: (context, url, downloadProgress) => Center(
          child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: CircularProgressIndicator(
            color: Colors.black, value: downloadProgress.progress),
      )),
      errorWidget: (context, url, error) => const Icon(Icons.error),
    );
  }
}
