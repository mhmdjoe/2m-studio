import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:anosh/widgets/custom_cursor.dart';

class MagneticWrapper extends ConsumerStatefulWidget {
  final Widget child;
  final double pullStrength;
  final String? cursorHint;

  const MagneticWrapper({
    super.key,
    required this.child,
    this.pullStrength = 15.0,
    this.cursorHint,
  });

  @override
  ConsumerState<MagneticWrapper> createState() => _MagneticWrapperState();
}

class _MagneticWrapperState extends ConsumerState<MagneticWrapper> {
  Offset _offset = Offset.zero;
  bool _isHovered = false;

  void _onHover(PointerEvent event) {
    final RenderBox? renderBox = context.findRenderObject() as RenderBox?;
    if (renderBox == null) return;
    
    final center = renderBox.size.center(Offset.zero);
    final localPosition = event.localPosition;
    
    final delta = Offset(
      (localPosition.dx - center.dx) / widget.pullStrength,
      (localPosition.dy - center.dy) / widget.pullStrength,
    );

    setState(() {
      _offset = delta;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Disable magnetic effect on mobile/tablets
    final screenWidth = MediaQuery.of(context).size.width;
    if (screenWidth < 1024 || (defaultTargetPlatform == TargetPlatform.android || defaultTargetPlatform == TargetPlatform.iOS)) {
      return widget.child;
    }

    return MouseRegion(
      onEnter: (_) {
        setState(() => _isHovered = true);
        ref.read(cursorProvider.notifier).setHover(true, hint: widget.cursorHint ?? '');
      },
      onExit: (_) {
        setState(() {
          _isHovered = false;
          _offset = Offset.zero;
        });
        ref.read(cursorProvider.notifier).setHover(false);
      },
      onHover: _onHover,
      child: AnimatedContainer(
        duration: Duration(milliseconds: _isHovered ? 50 : 500),
        curve: _isHovered ? Curves.linear : Curves.elasticOut,
        transform: Matrix4.translationValues(_offset.dx, _offset.dy, 0),
        child: widget.child,
      ),
    );
  }
}
