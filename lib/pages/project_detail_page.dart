import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:anosh/models/project.dart';
import 'package:anosh/widgets/navbar.dart';
import 'package:anosh/widgets/magnetic_wrapper.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:anosh/widgets/universal_image.dart';
import 'package:anosh/features/admin/project_repository.dart';

class ProjectDetailPage extends ConsumerStatefulWidget {
  final String projectId;

  const ProjectDetailPage({super.key, required this.projectId});

  @override
  ConsumerState<ProjectDetailPage> createState() => _ProjectDetailPageState();
}

class _ProjectDetailPageState extends ConsumerState<ProjectDetailPage> {
  final ScrollController _scrollController = ScrollController();
  double _scrollOffset = 0.0;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      if (mounted) setState(() => _scrollOffset = _scrollController.offset);
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _openFullScreen(List<String> images, int index) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => FullScreenGallery(images: images, initialIndex: index),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 800;

    // IMPORTANT: Watch projectsProvider to include newly added sessions
    final projects = ref.watch(projectsProvider);
    final project = projects.firstWhere(
      (p) => p.id == widget.projectId,
      orElse: () => mockProjects.firstWhere(
        (p) => p.id == widget.projectId,
        orElse: () => mockProjects.first,
      ),
    );

    final List<String> allImages = [
      project.imageUrl,
      ...project.galleryUrls.isNotEmpty 
          ? project.galleryUrls 
          : List.generate(6, (i) => 'https://picsum.photos/seed/${project.id}${i + 1}/1200/1500')
    ];

    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: SingleChildScrollView(
              controller: _scrollController,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Luxury Header Section
                  Stack(
                    children: [
                      MagneticWrapper(
                        cursorHint: 'FULL',
                        child: GestureDetector(
                          onTap: () => _openFullScreen(allImages, 0),
                          child: SizedBox(
                            width: double.infinity,
                            height: MediaQuery.of(context).size.height * 0.9,
                            child: Stack(
                              fit: StackFit.expand,
                              children: [
                                UniversalImage(
                                  path: project.imageUrl,
                                  fit: BoxFit.cover,
                                ),
                                Container(
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter,
                                      colors: [
                                        Colors.black.withValues(alpha: 0.1),
                                        Colors.black,
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),

                      Positioned(
                        bottom: isMobile ? 40 : 100 - (_scrollOffset * 0.1),
                        left: isMobile ? 20 : 40,
                        right: isMobile ? 20 : 40,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              project.category.name.toUpperCase(),
                              style: Theme.of(context).textTheme.labelLarge!.copyWith(
                                fontSize: isMobile ? 10 : 11,
                              ),
                            ),
                            const SizedBox(height: 10),
                            FittedBox(
                              fit: BoxFit.scaleDown,
                              alignment: Alignment.centerLeft,
                              child: Text(
                                project.title.toUpperCase(),
                                style: Theme.of(context).textTheme.displayLarge!.copyWith(
                                  fontSize: isMobile ? 60 : 120,
                                  height: 0.9,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 60),

                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: isMobile ? 20.0 : 40.0),
                    child: isMobile 
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              project.description,
                              style: Theme.of(context).textTheme.displaySmall!.copyWith(
                                fontSize: 24,
                                fontWeight: FontWeight.w200,
                                height: 1.6,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 60),
                            _MetaSection(project: project),
                          ],
                        )
                      : Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(child: _MetaSection(project: project)),
                            const SizedBox(width: 120),
                            Expanded(
                              flex: 2,
                              child: Text(
                                project.description,
                                style: Theme.of(context).textTheme.displaySmall!.copyWith(
                                  fontSize: 32,
                                  fontWeight: FontWeight.w200,
                                  height: 1.6,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                  ),

                  SizedBox(height: isMobile ? 80 : 200),

                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: isMobile ? 20.0 : 40.0),
                    child: MasonryGridView.count(
                      crossAxisCount: isMobile ? 1 : 2,
                      mainAxisSpacing: isMobile ? 20 : 40,
                      crossAxisSpacing: isMobile ? 20 : 40,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: project.galleryUrls.isNotEmpty ? project.galleryUrls.length : 6,
                      itemBuilder: (context, index) {
                        final String imgUrl = project.galleryUrls.isNotEmpty 
                            ? project.galleryUrls[index] 
                            : 'https://picsum.photos/seed/${project.id}${index + 1}/1200/1500';
                            
                        return MagneticWrapper(
                          cursorHint: 'FULL',
                          child: GestureDetector(
                            onTap: () => _openFullScreen(allImages, index + 1),
                            child: UniversalImage(
                              path: imgUrl,
                              fit: BoxFit.cover,
                            ),
                          ),
                        );
                      },
                    ),
                  ),

                  SizedBox(height: 100),
                ],
              ),
            ),
          ),

          Positioned(
            top: 0, left: 0, right: 0,
            child: NavBar(scrollOffset: _scrollOffset),
          ),
        ],
      ),
    );
  }
}

class FullScreenGallery extends StatelessWidget {
  final List<String> images;
  final int initialIndex;

  const FullScreenGallery({super.key, required this.images, required this.initialIndex});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          PageView.builder(
            itemCount: images.length,
            controller: PageController(initialPage: initialIndex),
            itemBuilder: (context, index) {
              return InteractiveViewer(
                minScale: 0.5,
                maxScale: 4.0,
                child: Center(
                  child: UniversalImage(
                    path: images[index],
                    fit: BoxFit.contain,
                  ),
                ),
              );
            },
          ),
          Positioned(
            top: 40,
            right: 20,
            child: IconButton(
              icon: const Icon(Icons.close, color: Colors.white, size: 30),
              onPressed: () => Navigator.pop(context),
            ),
          ),
        ],
      ),
    );
  }
}

class _MetaSection extends StatelessWidget {
  final Project project;
  const _MetaSection({required this.project});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _MetaDetail(title: 'STUDIO', content: project.studio),
        _MetaDetail(title: 'YEAR', content: project.year),
        _MetaDetail(title: 'TYPE', content: project.subCategory == ProjectSubCategory.none ? 'PRODUCT' : project.subCategory.name.toUpperCase()),
      ],
    );
  }
}

class _MetaDetail extends StatelessWidget {
  final String title;
  final String content;
  const _MetaDetail({required this.title, required this.content});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 40.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: Theme.of(context).textTheme.labelLarge!.copyWith(fontSize: 10, color: Colors.white38)),
          const SizedBox(height: 8),
          Text(content, style: Theme.of(context).textTheme.bodyLarge!.copyWith(fontSize: 14, color: Colors.white)),
        ],
      ),
    );
  }
}
