import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CursorState {
  final bool isHovering;
  final String hintText;
  final bool isLocked;
  
  CursorState({
    this.isHovering = false, 
    this.hintText = '',
    this.isLocked = false,
  });
}

class CursorNotifier extends StateNotifier<CursorState> {
  CursorNotifier() : super(CursorState());

  void setHover(bool hovering, {String hint = ''}) {
    if (state.isLocked) return;
    state = CursorState(isHovering: hovering, hintText: hint, isLocked: false);
  }

  void setLock(bool locked) {
    state = CursorState(
      isHovering: false, 
      hintText: '', 
      isLocked: locked,
    );
  }
}

final cursorProvider = StateNotifierProvider<CursorNotifier, CursorState>((ref) {
  return CursorNotifier();
});

class CustomCursor extends ConsumerStatefulWidget {
  final Widget child;

  const CustomCursor({super.key, required this.child});

  @override
  ConsumerState<CustomCursor> createState() => _CustomCursorState();
}

class _CustomCursorState extends ConsumerState<CustomCursor> {
  final ValueNotifier<Offset> _pointerPosition = ValueNotifier(Offset.zero);
  final ValueNotifier<bool> _isInitialized = ValueNotifier(false);

  @override
  void dispose() {
    _pointerPosition.dispose();
    _isInitialized.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Disable custom cursor on mobile platforms or small screens
    final screenWidth = MediaQuery.of(context).size.width;
    final isTouchPlatform = defaultTargetPlatform == TargetPlatform.android || defaultTargetPlatform == TargetPlatform.iOS;
    
    if (screenWidth < 1024 || isTouchPlatform) {
      return widget.child;
    }

    final cursorState = ref.watch(cursorProvider);

    return MouseRegion(
      cursor: SystemMouseCursors.basic,
      onHover: (event) {
        if (cursorState.isLocked) return;
        _pointerPosition.value = event.position;
        if (!_isInitialized.value) {
          _isInitialized.value = true;
        }
      },
      child: Stack(
        children: [
          widget.child,
          
          ValueListenableBuilder<bool>(
            valueListenable: _isInitialized,
            builder: (context, initialized, _) {
              if (!initialized || cursorState.isLocked) return const SizedBox.shrink();
              
              return ValueListenableBuilder<Offset>(
                valueListenable: _pointerPosition,
                builder: (context, pos, _) {
                  return IgnorePointer(
                    child: Transform.translate(
                      offset: pos - (cursorState.isHovering ? const Offset(45, 45) : const Offset(12, 12)),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeOutQuart,
                        width: cursorState.isHovering ? 90 : 24,
                        height: cursorState.isHovering ? 90 : 24,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.white.withValues(alpha: cursorState.isHovering ? 0.9 : 0.4),
                            width: cursorState.isHovering ? 1.0 : 2.0,
                          ),
                          color: Colors.white.withValues(alpha: cursorState.isHovering ? 0.15 : 0.0),
                        ),
                        child: AnimatedOpacity(
                          duration: const Duration(milliseconds: 200),
                          opacity: (cursorState.isHovering && cursorState.hintText.isNotEmpty) ? 1.0 : 0.0,
                          child: Center(
                            child: Material(
                              color: Colors.transparent,
                              child: Text(
                                cursorState.hintText,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 10,
                                  fontWeight: FontWeight.w900,
                                  letterSpacing: 2,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
