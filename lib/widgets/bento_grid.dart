import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:anosh/models/project.dart';
import 'package:anosh/widgets/project_card.dart';
import 'package:anosh/widgets/magnetic_wrapper.dart';

class BentoGrid extends StatelessWidget {
  final List<Project> projects;

  const BentoGrid({super.key, required this.projects});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final screenWidth = constraints.maxWidth;
        final isMobile = screenWidth < 800;
        final isTablet = screenWidth >= 800 && screenWidth < 1200;

        final crossAxisCount = isMobile ? 1 : (isTablet ? 2 : 4);
        final mainAxisSpacing = isMobile ? 15.0 : 30.0;
        final crossAxisSpacing = isMobile ? 15.0 : 30.0;

        return StaggeredGrid.count(
          crossAxisCount: crossAxisCount,
          mainAxisSpacing: mainAxisSpacing,
          crossAxisSpacing: crossAxisSpacing,
          children: [
            // Hero Tile
            if (projects.isNotEmpty)
              StaggeredGridTile.count(
                crossAxisCellCount: isMobile ? 1 : 2,
                mainAxisCellCount: isMobile ? 1.2 : 3.0,
                child: MagneticWrapper(
                  cursorHint: 'VIEW',
                  pullStrength: 30,
                  child: ProjectCard(project: projects[0]), 
                ),
              ),
            
            // Secondary Tile
            if (projects.length > 1)
              StaggeredGridTile.count(
                crossAxisCellCount: isMobile ? 1 : (isTablet ? 2 : 2),
                mainAxisCellCount: isMobile ? 1.0 : 1.5,
                child: MagneticWrapper(
                  cursorHint: 'VIEW',
                  pullStrength: 30,
                  child: ProjectCard(project: projects[1]),
                ),
              ),

            // Detail Tiles
            if (projects.length > 2)
              StaggeredGridTile.count(
                crossAxisCellCount: 1,
                mainAxisCellCount: 1.5,
                child: MagneticWrapper(
                  cursorHint: 'VIEW',
                  pullStrength: 30,
                  child: ProjectCard(project: projects[2]),
                ),
              ),
            
            if (projects.length > 3)
              StaggeredGridTile.count(
                crossAxisCellCount: 1,
                mainAxisCellCount: 1.5,
                child: MagneticWrapper(
                  cursorHint: 'VIEW',
                  pullStrength: 30,
                  child: ProjectCard(project: projects[3]),
                ),
              ),

            // Wide Tile
            if (projects.length > 4)
              StaggeredGridTile.count(
                crossAxisCellCount: isMobile ? 1 : 2,
                mainAxisCellCount: isMobile ? 0.8 : 2.0,
                child: MagneticWrapper(
                  cursorHint: 'VIEW',
                  pullStrength: 30,
                  child: ProjectCard(project: projects[4]),
                ),
              ),
            
            // Vertical Tile
            if (projects.length > 5)
              StaggeredGridTile.count(
                crossAxisCellCount: isMobile ? 1 : 2,
                mainAxisCellCount: isMobile ? 1.2 : 3.5,
                child: MagneticWrapper(
                  cursorHint: 'VIEW',
                  pullStrength: 30,
                  child: ProjectCard(project: projects[5]),
                ),
              ),
          ],
        );
      },
    );
  }
}
