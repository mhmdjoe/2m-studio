import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:visibility_detector/visibility_detector.dart';
import 'package:anosh/widgets/magnetic_wrapper.dart';

class ScrollAnimatedPhoto extends StatefulWidget {
  final String imageUrl;
  final String title;

  const ScrollAnimatedPhoto({
    super.key,
    required this.imageUrl,
    required this.title,
  });

  @override
  State<ScrollAnimatedPhoto> createState() => _ScrollAnimatedPhotoState();
}

class _ScrollAnimatedPhotoState extends State<ScrollAnimatedPhoto>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _revealAnimation;
  bool _isVisible = false;
  bool _isHovered = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    _revealAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 800;
    final double imageHeight = isMobile ? 400 : 600;
    
    final cleanTitle = widget.title.endsWith('.') 
        ? widget.title.substring(0, widget.title.length - 1) 
        : widget.title;

    final Color accentColor = Theme.of(context).colorScheme.primary;

    return VisibilityDetector(
      key: Key('photo-${widget.title}'),
      onVisibilityChanged: (info) {
        if (info.visibleFraction > 0.1 && !_isVisible) {
          setState(() {
            _isVisible = true;
          });
          _controller.forward();
        }
      },
      child: AnimatedBuilder(
        animation: _revealAnimation,
        builder: (context, child) {
          return Stack(
            children: [
              ClipRect(
                clipper: _RevealClipper(_revealAnimation.value),
                child: Image.network(
                  widget.imageUrl,
                  width: double.infinity,
                  height: imageHeight,
                  fit: BoxFit.cover,
                ),
              ),
              
              Positioned(
                bottom: isMobile ? 20 : 40,
                right: isMobile ? 20 : 40,
                child: AnimatedOpacity(
                  duration: const Duration(milliseconds: 800),
                  opacity: _isVisible ? 1.0 : 0.0,
                  child: MagneticWrapper(
                    cursorHint: 'VIEW',
                    child: MouseRegion(
                      onEnter: (_) => setState(() => _isHovered = true),
                      onExit: (_) => setState(() => _isHovered = false),
                      child: OutlinedButton(
                        onPressed: () => context.push('/portfolio?view=premium'),
                        style: OutlinedButton.styleFrom(
                          padding: EdgeInsets.symmetric(
                            horizontal: isMobile ? 30 : 40, 
                            vertical: isMobile ? 20 : 25
                          ),
                          // Shape: Sharp rectangular edges like "START A PROJECT"
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.zero,
                          ),
                          // Colors: Default Red text, Hover Red box/Black text
                          side: BorderSide(
                            color: _isHovered ? accentColor : Colors.white10,
                          ),
                          backgroundColor: _isHovered 
                              ? accentColor 
                              : Colors.black.withValues(alpha: 0.4),
                          foregroundColor: _isHovered ? Colors.black : accentColor,
                        ),
                        child: Text(
                          cleanTitle.toUpperCase(),
                          style: TextStyle(
                            fontSize: isMobile ? 11 : 13, 
                            fontWeight: FontWeight.w900,
                            letterSpacing: isMobile ? 3 : 5,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              
              Positioned(
                left: 0,
                right: 0,
                top: _revealAnimation.value * imageHeight - 2,
                child: Opacity(
                  opacity: _revealAnimation.value > 0 && _revealAnimation.value < 1 ? 1.0 : 0.0,
                  child: Container(
                    height: 4,
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: Colors.white.withValues(alpha: 0.8),
                          blurRadius: 10,
                          spreadRadius: 2,
                        ),
                      ],
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _RevealClipper extends CustomClipper<Rect> {
  final double fraction;

  _RevealClipper(this.fraction);

  @override
  Rect getClip(Size size) {
    return Rect.fromLTWH(0, 0, size.width, size.height * fraction);
  }

  @override
  bool shouldReclip(_RevealClipper oldClipper) {
    return oldClipper.fraction != fraction;
  }
}
