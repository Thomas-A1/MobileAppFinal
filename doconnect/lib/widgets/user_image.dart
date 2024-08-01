import 'package:cached_network_image/cached_network_image.dart';
import 'package:doconnect/widgets/CustomShimmer.dart';
import 'package:flutter/material.dart';

class CircularImage extends StatelessWidget {
  const CircularImage(
      {
      super.key,
      this.fit,
      this.width = 56,
      this.isNetworkImage = false,
      this.overlayColor,
      this.backgroundColor,
      this.height = 56,
      required this.image,
      this.padding = 12});

  final BoxFit? fit;
  final String image;
  final bool isNetworkImage;
  final Color? overlayColor;
  final Color? backgroundColor;
  final double width, height, padding;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      padding: EdgeInsets.all(padding),
      decoration: BoxDecoration(
        color: backgroundColor ?? Colors.white,
        borderRadius: BorderRadius.circular(100),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(100),
        child: Center(
          child: isNetworkImage
          ? CachedNetworkImage(
            fit: fit,
            color: overlayColor,
            imageUrl: image,
            progressIndicatorBuilder: (context, url, downloadProgress) => const CustomShimmerEffect (width: 55, height: 55),
            errorWidget: (context, url, error) => const Icon(Icons.error),
          )
          :
          Image(
            fit: fit,
            image: AssetImage(image),
                color: overlayColor,
          ),
        ),
      ),
    );
  }
}
