import 'package:flutter/material.dart';
import 'package:visibility_detector/visibility_detector.dart';

// Optimized version using LayoutBuilder for precise line positioning
class HorizontalScanReveal extends StatefulWidget {
  final Widget child;
  final String uniqueId;

  const HorizontalScanReveal({
    super.key,
    required this.child,
    required this.uniqueId,
  });

  @override
  State<HorizontalScanReveal> createState() => _HorizontalScanRevealState();
}

class _HorizontalScanRevealState extends State<HorizontalScanReveal>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _revealAnimation;
  bool _isVisible = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    );

    _revealAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOutQuart),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return VisibilityDetector(
      key: Key('scan-reveal-${widget.uniqueId}'),
      onVisibilityChanged: (info) {
        if (info.visibleFraction > 0.3 && !_isVisible) {
          setState(() {
            _isVisible = true;
          });
          _controller.forward();
        }
      },
      child: LayoutBuilder(
        builder: (context, constraints) {
          return AnimatedBuilder(
            animation: _revealAnimation,
            builder: (context, child) {
              return Stack(
                children: [
                  // Revealed Child
                  ClipRect(
                    clipper: _HorizontalRevealClipper(_revealAnimation.value),
                    child: widget.child,
                  ),
                  
                  // Vertical Moving Line
                  if (_revealAnimation.value > 0 && _revealAnimation.value < 1)
                    Positioned(
                      left: _revealAnimation.value * constraints.maxWidth - 1,
                      top: 0,
                      bottom: 0,
                      child: Container(
                        width: 2,
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.primary,
                          boxShadow: [
                            BoxShadow(
                              color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.8),
                              blurRadius: 10,
                              spreadRadius: 2,
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              );
            },
          );
        },
      ),
    );
  }
}

class _HorizontalRevealClipper extends CustomClipper<Rect> {
  final double fraction;

  _HorizontalRevealClipper(this.fraction);

  @override
  Rect getClip(Size size) {
    return Rect.fromLTWH(0, 0, size.width * fraction, size.height);
  }

  @override
  bool shouldReclip(_HorizontalRevealClipper oldClipper) {
    return oldClipper.fraction != fraction;
  }
}
