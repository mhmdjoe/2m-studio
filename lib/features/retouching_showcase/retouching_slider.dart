import 'package:flutter/material.dart';
import 'package:before_after_image_slider_nullsafty/before_after_image_slider_nullsafty.dart';

class RetouchingSlider extends StatelessWidget {
  final String beforeImageUrl;
  final String afterImageUrl;

  const RetouchingSlider({
    super.key,
    required this.beforeImageUrl,
    required this.afterImageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: AspectRatio(
            aspectRatio: 16 / 9,
            child: Stack(
              children: [
                BeforeAfter(
                  beforeImage: Image.network(beforeImageUrl, fit: BoxFit.cover),
                  afterImage: Image.network(afterImageUrl, fit: BoxFit.cover),
                ),
                
                // Overlay text in the bottom left corner
                Positioned(
                  bottom: 20,
                  left: 20,
                  child: IgnorePointer(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.4),
                        borderRadius: BorderRadius.circular(4),
                        border: Border.all(color: Colors.white10),
                      ),
                      child: const Text(
                        'DRAG THE SLIDER TO COMPARE',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 9,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 2,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
