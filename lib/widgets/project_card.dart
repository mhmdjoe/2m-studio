import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:anosh/models/project.dart';
import 'package:anosh/theme/app_theme.dart';
import 'package:go_router/go_router.dart';
import 'package:anosh/widgets/universal_image.dart';

class ProjectCard extends StatefulWidget {
  final Project project;
  final double? aspectRatio;

  const ProjectCard({
    super.key, 
    required this.project, 
    this.aspectRatio,
  });

  @override
  State<ProjectCard> createState() => _ProjectCardState();
}

class _ProjectCardState extends State<ProjectCard> with SingleTickerProviderStateMixin {
  bool _isHovered = false;
  Offset _mousePosition = Offset.zero;

  void _onPositionChanged(PointerEvent event) {
    if (_isHovered) {
      setState(() {
        _mousePosition = event.localPosition;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 1024 || (defaultTargetPlatform == TargetPlatform.android || defaultTargetPlatform == TargetPlatform.iOS);

    final magneticOffset = (_isHovered && !isMobile)
      ? Offset(_mousePosition.dx / 60, _mousePosition.dy / 60)
      : Offset.zero;

    Widget content = Container(
      color: Colors.white.withValues(alpha: 0.02),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
        transform: Matrix4.translationValues(magneticOffset.dx, magneticOffset.dy, 0)
          ..multiply(Matrix4.diagonal3Values(_isHovered ? 1.02 : 1.0, _isHovered ? 1.02 : 1.0, 1.0)),
        child: Stack(
          fit: StackFit.expand,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.zero,
              child: Hero(
                tag: 'project-hero-${widget.project.id}-${widget.aspectRatio ?? "bento"}',
                child: UniversalImage(
                  path: widget.project.imageUrl,
                  fit: BoxFit.cover,
                  cacheWidth: 800, 
                  cacheHeight: 1200,
                ),
              ),
            ),
            
            AnimatedOpacity(
              duration: const Duration(milliseconds: 200),
              opacity: _isHovered ? 0.4 : 0.0,
              child: Container(color: Colors.black),
            ),
            
            Positioned(
              bottom: isMobile ? 15 : 20,
              left: isMobile ? 15 : 20,
              right: isMobile ? 15 : 20,
              child: AnimatedOpacity(
                duration: const Duration(milliseconds: 200),
                opacity: (isMobile || _isHovered) ? 1.0 : 0.0, 
                child: AppTheme.glassEffect(
                  blur: 4,
                  opacity: 0.1,
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: isMobile ? 12 : 15, 
                      vertical: isMobile ? 10 : 12
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          widget.project.title.toUpperCase(),
                          style: Theme.of(context).textTheme.titleLarge!.copyWith(
                            fontSize: isMobile ? 11 : 13,
                            letterSpacing: 1.5,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          widget.project.subCategory == ProjectSubCategory.none
                              ? widget.project.category.name.toUpperCase()
                              : '${widget.project.category.name.toUpperCase()} / ${widget.project.subCategory.name.toUpperCase()}',
                          style: Theme.of(context).textTheme.labelLarge!.copyWith(
                            fontSize: isMobile ? 9 : 10,
                            color: Theme.of(context).colorScheme.primary,
                            letterSpacing: 2,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            
            Positioned(
              top: isMobile ? 10 : 15,
              right: isMobile ? 10 : 15,
              child: AnimatedOpacity(
                duration: const Duration(milliseconds: 200),
                opacity: (isMobile || _isHovered) ? 1.0 : 0.0,
                child: const Icon(Icons.north_east, color: Colors.white, size: 18),
              ),
            ),
          ],
        ),
      ),
    );

    if (widget.aspectRatio != null) {
      content = AspectRatio(aspectRatio: widget.aspectRatio!, child: content);
    }

    return RepaintBoundary(
      child: MouseRegion(
        onEnter: (_) => setState(() => _isHovered = true),
        onExit: (_) => setState(() => _isHovered = false),
        onHover: isMobile ? null : _onPositionChanged,
        child: GestureDetector(
          onTap: () => context.push('/portfolio/${widget.project.id}'),
          behavior: HitTestBehavior.opaque,
          child: content,
        ),
      ),
    );
  }
}
