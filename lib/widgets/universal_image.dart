import 'package:flutter/material.dart';

class UniversalImage extends StatelessWidget {
  final String path;
  final BoxFit fit;
  final double? width;
  final double? height;
  final int? cacheWidth;
  final int? cacheHeight;

  const UniversalImage({
    super.key,
    required this.path,
    this.fit = BoxFit.cover,
    this.width,
    this.height,
    this.cacheWidth,
    this.cacheHeight,
  });

  @override
  Widget build(BuildContext context) {
    // Determine Image Provider
    ImageProvider imageProvider;
    if (path.startsWith('http') || path.startsWith('blob:') || path.startsWith('data:')) {
      imageProvider = NetworkImage(path);
    } else {
      imageProvider = AssetImage(path);
    }

    return Image(
      image: imageProvider,
      fit: fit,
      width: width,
      height: height,
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) return child;
        return Container(
          width: width,
          height: height,
          color: Colors.white.withValues(alpha: 0.05),
          child: const Center(
            child: SizedBox(
              width: 24,
              height: 24,
              child: CircularProgressIndicator(
                strokeWidth: 1,
                color: Colors.white12,
              ),
            ),
          ),
        );
      },
      errorBuilder: (context, error, stackTrace) => Container(
        width: width,
        height: height,
        color: Colors.grey[900],
        child: const Icon(Icons.broken_image, color: Colors.white24, size: 24),
      ),
    );
  }
}
