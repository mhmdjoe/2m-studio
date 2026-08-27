import 'package:flutter/material.dart';
import 'package:visibility_detector/visibility_detector.dart';

class PremiumReveal extends StatefulWidget {
  final Widget child;
  final Duration delay;
  final Offset offset;
  final String? uniqueId;

  const PremiumReveal({
    super.key,
    required this.child,
    this.delay = Duration.zero,
    this.offset = const Offset(0, 20),
    this.uniqueId,
  });

  @override
  State<PremiumReveal> createState() => _PremiumRevealState();
}

class _PremiumRevealState extends State<PremiumReveal> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _opacity;
  late Animation<Offset> _slide;
  bool _isVisible = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _opacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeIn),
    );

    _slide = Tween<Offset>(begin: widget.offset, end: Offset.zero).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Use uniqueId if provided, otherwise fallback to a static-ish key 
    // to prevent VisibilityDetector resets during simple rebuilds
    final detectorKey = widget.uniqueId != null 
        ? Key('reveal-${widget.uniqueId}') 
        : ValueKey('reveal-static-${widget.child.runtimeType}');

    return VisibilityDetector(
      key: detectorKey,
      onVisibilityChanged: (info) {
        if (info.visibleFraction > 0.05 && !_isVisible) {
          if (mounted) {
            setState(() {
              _isVisible = true;
            });
            Future.delayed(widget.delay, () {
              if (mounted) _controller.forward();
            });
          }
        }
      },
      child: FadeTransition(
        opacity: _opacity,
        child: AnimatedBuilder(
          animation: _slide,
          builder: (context, child) {
            return Transform.translate(
              offset: _slide.value,
              child: widget.child,
            );
          },
        ),
      ),
    );
  }
}
