import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:anosh/models/project.dart';
import 'package:anosh/widgets/navbar.dart';
import 'package:anosh/widgets/project_card.dart';
import 'package:anosh/widgets/custom_cursor.dart';
import 'package:anosh/features/admin/project_repository.dart';
import 'package:anosh/features/admin/admin_provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'dart:io';
import 'package:flutter/foundation.dart';

enum PortfolioViewState { mainCategory, subCategory, grid, premium }

class PortfolioPage extends ConsumerStatefulWidget {
  final bool startWithPremium;

  const PortfolioPage({
    super.key,
    this.startWithPremium = false,
  });

  @override
  ConsumerState<PortfolioPage> createState() => _PortfolioPageState();
}

class _PortfolioPageState extends ConsumerState<PortfolioPage> {
  PortfolioViewState _viewState = PortfolioViewState.mainCategory;
  ProjectCategory? _selectedCategory;
  ProjectSubCategory? _selectedSubCategory;
  bool _isTransitioning = false;
  
  final ScrollController _gridScrollController = ScrollController();
  double _scrollOffset = 0;

  @override
  void initState() {
    super.initState();
    if (widget.startWithPremium) {
      _viewState = PortfolioViewState.premium;
    }
    _gridScrollController.addListener(() {
      if (mounted) setState(() => _scrollOffset = _gridScrollController.offset);
    });
  }

  @override
  void dispose() {
    _gridScrollController.dispose();
    super.dispose();
  }

  void _onCategorySelected(ProjectCategory category) {
    if (_isTransitioning) return;
    
    ref.read(cursorProvider.notifier).setLock(true);
    setState(() => _isTransitioning = true);

    Future.delayed(const Duration(milliseconds: 300), () {
      if (!mounted) return;
      setState(() {
        _selectedCategory = category;
        if (category == ProjectCategory.product) {
          _selectedSubCategory = ProjectSubCategory.none;
          _viewState = PortfolioViewState.grid;
          _scrollOffset = 0;
        } else {
          _viewState = PortfolioViewState.subCategory;
        }
        _isTransitioning = false;
      });
      ref.read(cursorProvider.notifier).setLock(false);
    });
  }

  void _onSubCategorySelected(ProjectSubCategory subCategory) {
    if (_isTransitioning) return;

    ref.read(cursorProvider.notifier).setLock(true);
    setState(() => _isTransitioning = true);

    Future.delayed(const Duration(milliseconds: 300), () {
      if (!mounted) return;
      setState(() {
        _selectedSubCategory = subCategory;
        _viewState = PortfolioViewState.grid;
        _scrollOffset = 0;
        _isTransitioning = false;
      });
      ref.read(cursorProvider.notifier).setLock(false);
    });
  }

  void _onBack() {
    if (_isTransitioning) return;

    ref.read(cursorProvider.notifier).setLock(true);
    setState(() => _isTransitioning = true);

    Future.delayed(const Duration(milliseconds: 300), () {
      if (!mounted) return;
      setState(() {
        if (_viewState == PortfolioViewState.premium) {
          _viewState = PortfolioViewState.mainCategory;
        } else if (_viewState == PortfolioViewState.grid) {
          if (_selectedCategory == ProjectCategory.product) {
            _viewState = PortfolioViewState.mainCategory;
            _selectedCategory = null;
            _selectedSubCategory = null;
          } else {
            _viewState = PortfolioViewState.subCategory;
            _selectedSubCategory = null;
          }
        } else if (_viewState == PortfolioViewState.subCategory) {
          _viewState = PortfolioViewState.mainCategory;
          _selectedCategory = null;
        }
        _scrollOffset = 0;
        _isTransitioning = false;
      });
      ref.read(cursorProvider.notifier).setLock(false);
    });
  }

  @override
  Widget build(BuildContext context) {
    final projects = ref.watch(projectsProvider);

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          _PortfolioBackground(
            category: _selectedCategory,
            subCategory: _selectedSubCategory,
            isPremiumView: _viewState == PortfolioViewState.premium,
          ),

          Positioned.fill(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 500),
              child: _buildCurrentView(projects),
            ),
          ),

          Positioned(
            top: 0, left: 0, right: 0,
            child: RepaintBoundary(child: NavBar(scrollOffset: _scrollOffset)),
          ),
        ],
      ),
    );
  }

  Widget _buildCurrentView(List<Project> projects) {
    final isAdmin = ref.watch(isAdminProvider);

    switch (_viewState) {
      case PortfolioViewState.mainCategory:
        return PortfolioMainSelection(
          key: const ValueKey('main-cat-view-v4'),
          onCategorySelected: _onCategorySelected,
          isLocked: _isTransitioning,
        );
      case PortfolioViewState.subCategory:
        return PortfolioSubSelection(
          key: ValueKey('sub-cat-view-v4-$_selectedCategory'),
          onSubCategorySelected: _onSubCategorySelected,
          onBack: _onBack,
          isLocked: _isTransitioning,
        );
      case PortfolioViewState.grid:
        return PortfolioGridView(
          key: ValueKey('grid-v4-$_selectedCategory-$_selectedSubCategory'),
          category: _selectedCategory ?? ProjectCategory.fashion,
          subCategory: _selectedSubCategory ?? ProjectSubCategory.none,
          onBack: _onBack,
          scrollController: _gridScrollController,
          projects: projects,
          isAdmin: isAdmin,
        );
      case PortfolioViewState.premium:
        return PortfolioPremiumView(
          key: const ValueKey('premium-grid-view-v4'),
          onBack: _onBack,
          scrollController: _gridScrollController,
          projects: projects,
        );
    }
  }
}

class _PortfolioBackground extends StatelessWidget {
  final ProjectCategory? category;
  final ProjectSubCategory? subCategory;
  final bool isPremiumView;

  const _PortfolioBackground({this.category, this.subCategory, this.isPremiumView = false});

  @override
  Widget build(BuildContext context) {
    String bgUrl = 'https://images.unsplash.com/photo-1492691527719-9d1e07e534b4?auto=format&fit=crop&q=80&w=2000';
    
    if (isPremiumView) {
      bgUrl = 'https://images.unsplash.com/photo-1534528741775-53994a69daeb?auto=format&fit=crop&q=80&w=2000';
    } else if (category == ProjectCategory.product) {
      bgUrl = 'https://images.unsplash.com/photo-1523275335684-37898b6baf30?auto=format&fit=crop&q=80&w=2000';
    } else if (category == ProjectCategory.fashion) {
      if (subCategory == ProjectSubCategory.indoor) {
        bgUrl = 'https://images.unsplash.com/photo-1515516089376-88db1e26e9c0?auto=format&fit=crop&q=80&w=2000';
      } else if (subCategory == ProjectSubCategory.outdoor) {
        bgUrl = 'https://images.unsplash.com/photo-1515886657613-9f3515b0c78f?auto=format&fit=crop&q=80&w=2000';
      } else if (subCategory == ProjectSubCategory.flatlay) {
        bgUrl = 'https://images.unsplash.com/photo-1522335789203-aabd1fc54bc9?auto=format&fit=crop&q=80&w=2000';
      } else if (subCategory == ProjectSubCategory.shoes) {
        bgUrl = 'https://images.unsplash.com/photo-1542291026-7eec264c27ff?auto=format&fit=crop&q=80&w=2000';
      } else if (subCategory == ProjectSubCategory.commercial) {
        bgUrl = 'https://images.unsplash.com/photo-1469334031218-e382a71b716b?auto=format&fit=crop&q=80&w=2000';
      } else {
        bgUrl = 'https://images.unsplash.com/photo-1490481651871-ab68de25d43d?auto=format&fit=crop&q=80&w=2000';
      }
    }

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 800),
      child: Container(
        key: ValueKey(bgUrl),
        decoration: BoxDecoration(
          image: DecorationImage(
            image: NetworkImage(bgUrl),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
              Colors.black.withValues(alpha: 0.7),
              BlendMode.darken,
            ),
          ),
        ),
      ),
    );
  }
}

class PortfolioMainSelection extends StatelessWidget {
  final Function(ProjectCategory) onCategorySelected;
  final bool isLocked;

  const PortfolioMainSelection({
    super.key,
    required this.onCategorySelected,
    required this.isLocked,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _LargeSelectionItem(
            title: 'FASHION',
            onTap: () => onCategorySelected(ProjectCategory.fashion),
            isLocked: isLocked,
          ),
          const SizedBox(height: 40),
          Text('— SELECT DIVISION —', style: Theme.of(context).textTheme.labelLarge?.copyWith(color: Colors.white12, letterSpacing: 10, fontSize: 10)),
          const SizedBox(height: 40),
          _LargeSelectionItem(
            title: 'PRODUCT',
            onTap: () => onCategorySelected(ProjectCategory.product),
            isLocked: isLocked,
          ),
        ],
      ),
    );
  }
}

class PortfolioSubSelection extends StatelessWidget {
  final Function(ProjectSubCategory) onSubCategorySelected;
  final VoidCallback onBack;
  final bool isLocked;

  const PortfolioSubSelection({
    super.key,
    required this.onSubCategorySelected,
    required this.onBack,
    required this.isLocked,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        constraints: const BoxConstraints(maxWidth: 1000),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _LargeSelectionItem(
              title: 'COMMERCIAL',
              onTap: () => onSubCategorySelected(ProjectSubCategory.commercial),
              isLocked: isLocked,
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: _LargeSelectionItem(
                    title: 'INDOOR',
                    onTap: () => onSubCategorySelected(ProjectSubCategory.indoor),
                    isLocked: isLocked,
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
                  ),
                ),
                Expanded(
                  child: _LargeSelectionItem(
                    title: 'OUTDOOR',
                    onTap: () => onSubCategorySelected(ProjectSubCategory.outdoor),
                    isLocked: isLocked,
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: _LargeSelectionItem(
                    title: 'FLATLAY',
                    onTap: () => onSubCategorySelected(ProjectSubCategory.flatlay),
                    isLocked: isLocked,
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
                  ),
                ),
                Expanded(
                  child: _LargeSelectionItem(
                    title: 'SHOES',
                    onTap: () => onSubCategorySelected(ProjectSubCategory.shoes),
                    isLocked: isLocked,
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 60),
            TextButton.icon(
              onPressed: onBack,
              icon: const Icon(Icons.arrow_back, size: 16),
              label: Text('BACK', style: Theme.of(context).textTheme.labelLarge?.copyWith(color: Colors.white38, letterSpacing: 5)),
            ),
          ],
        ),
      ),
    );
  }
}

class _LargeSelectionItem extends StatefulWidget {
  final String title;
  final VoidCallback onTap;
  final bool isLocked;
  final EdgeInsets? padding;

  const _LargeSelectionItem({
    required this.title,
    required this.onTap,
    required this.isLocked,
    this.padding,
  });

  @override
  State<_LargeSelectionItem> createState() => _LargeSelectionItemState();
}

class _LargeSelectionItemState extends State<_LargeSelectionItem> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 800;
    final effectiveHover = _isHovered && !widget.isLocked;

    final double desktopSize = 80.0;
    final double desktopHoverSize = 100.0;
    final double mobileSize = 40.0;
    final double mobileHoverSize = 48.0;

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: widget.isLocked ? null : widget.onTap,
        behavior: HitTestBehavior.opaque,
        child: Center(
          child: AnimatedDefaultTextStyle(
            duration: const Duration(milliseconds: 200),
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.displayLarge!.copyWith(
              fontSize: isMobile 
                  ? (effectiveHover ? mobileHoverSize : mobileSize)
                  : (effectiveHover ? desktopHoverSize : desktopSize),
              color: effectiveHover ? Colors.white : Colors.white54,
              letterSpacing: isMobile ? (effectiveHover ? 8 : 4) : (effectiveHover ? 15 : 5),
              height: 1.0,
            ),
            child: Padding(
              padding: widget.padding ?? EdgeInsets.symmetric(horizontal: isMobile ? 20 : 50, vertical: 12),
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(widget.title),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class PortfolioGridView extends ConsumerWidget {
  final ProjectCategory category;
  final ProjectSubCategory subCategory;
  final VoidCallback onBack;
  final ScrollController scrollController;
  final List<Project> projects;
  final bool isAdmin;

  const PortfolioGridView({
    super.key,
    required this.category,
    required this.subCategory,
    required this.onBack,
    required this.scrollController,
    required this.projects,
    required this.isAdmin,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filteredProjects = projects.where((p) => 
      p.category == category && p.subCategory == subCategory
    ).toList();

    final isMobile = MediaQuery.of(context).size.width < 800;

    return CustomScrollView(
      controller: scrollController,
      slivers: [
        const SliverToBoxAdapter(child: SizedBox(height: 140)),
        SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: isMobile ? 20 : 60),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextButton.icon(
                  onPressed: onBack,
                  icon: const Icon(Icons.arrow_back, size: 16),
                  label: const Text('BACK TO MENU'),
                  style: TextButton.styleFrom(foregroundColor: Colors.white60),
                ),
                const SizedBox(height: 20),
                FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.centerLeft,
                  child: Text(
                    category == ProjectCategory.product 
                        ? 'PRODUCT' 
                        : '${category.name.toUpperCase()} / ${subCategory.name.toUpperCase()}',
                    style: Theme.of(context).textTheme.displaySmall!.copyWith(
                      fontSize: isMobile ? 24 : 36,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        SliverPadding(
          padding: EdgeInsets.symmetric(horizontal: isMobile ? 20 : 60, vertical: 40),
          sliver: SliverMasonryGrid.count(
            crossAxisCount: isMobile ? 1 : 3,
            mainAxisSpacing: 30,
            crossAxisSpacing: 30,
            itemBuilder: (context, index) {
              if (isAdmin && index == filteredProjects.length) {
                return _AddSessionTile(category: category, subCategory: subCategory);
              }
              return ProjectCard(
                project: filteredProjects[index],
                aspectRatio: 0.8, 
              );
            },
            childCount: isAdmin ? filteredProjects.length + 1 : filteredProjects.length,
          ),
        ),
        if (!isAdmin && filteredProjects.isEmpty)
          const SliverToBoxAdapter(child: Center(child: Padding(
            padding: EdgeInsets.all(100.0),
            child: Text('NO PROJECTS FOUND', style: TextStyle(color: Colors.white24, letterSpacing: 4)),
          ))),
        const SliverToBoxAdapter(child: SizedBox(height: 100)),
      ],
    );
  }
}

class _AddSessionTile extends ConsumerStatefulWidget {
  final ProjectCategory category;
  final ProjectSubCategory subCategory;

  const _AddSessionTile({required this.category, required this.subCategory});

  @override
  ConsumerState<_AddSessionTile> createState() => _AddSessionTileState();
}

class _AddSessionTileState extends ConsumerState<_AddSessionTile> {
  void _startAddSession() {
    _showSessionDetailsDialog();
  }

  void _showSessionDetailsDialog() {
    final titleController = TextEditingController();
    final descController = TextEditingController();
    final yearController = TextEditingController(text: '2024');
    final studioController = TextEditingController(text: '2M STUDIO');
    final tagsController = TextEditingController();
    bool isPremium = false;
    
    Uint8List? coverBytes;
    List<XFile> gallery = [];
    bool isUploading = false;
    bool isPicking = false;
    double uploadProgress = 0.0;
    String? statusMessage;

    final picker = ImagePicker();

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          backgroundColor: const Color(0xFF0D0D0D),
          title: const Text('ADD NEW SESSION', style: TextStyle(color: Colors.white, letterSpacing: 2)),
          content: SizedBox(
            width: 500,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // COVER PICKER
                  if (coverBytes == null)
                    ElevatedButton.icon(
                      onPressed: (isPicking || isUploading) ? null : () async {
                        setDialogState(() => isPicking = true);
                        try {
                          final picked = await picker.pickImage(source: ImageSource.gallery);
                          if (picked != null) {
                            final bytes = await picked.readAsBytes();
                            setDialogState(() => coverBytes = bytes);
                          }
                        } finally {
                          setDialogState(() => isPicking = false);
                        }
                      },
                      icon: isPicking 
                        ? const SizedBox(width: 15, height: 15, child: CircularProgressIndicator(strokeWidth: 1))
                        : const Icon(Icons.image),
                      label: Text(isPicking ? 'OPENING...' : 'CHOOSE COVER PHOTO'),
                    )
                  else
                    Stack(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.memory(coverBytes!, height: 150, width: double.infinity, fit: BoxFit.cover),
                        ),
                        if (!isUploading)
                          Positioned(
                            right: 5, top: 5,
                            child: CircleAvatar(
                              backgroundColor: Colors.black54,
                              radius: 15,
                              child: IconButton(
                                icon: const Icon(Icons.close, size: 14, color: Colors.white),
                                onPressed: () => setDialogState(() => coverBytes = null),
                              ),
                            ),
                          ),
                      ],
                    ),
                  
                  const SizedBox(height: 20),

                  // GALLERY PICKER
                  OutlinedButton.icon(
                    onPressed: isUploading ? null : () async {
                      final picked = await picker.pickMultiImage();
                      if (picked.isNotEmpty) setDialogState(() => gallery = picked);
                    },
                    icon: const Icon(Icons.photo_library),
                    label: Text(gallery.isEmpty ? 'CHOOSE GALLERY PHOTOS' : '${gallery.length} PHOTOS SELECTED'),
                  ),

                  const Divider(height: 40, color: Colors.white10),

                  TextField(controller: titleController, decoration: const InputDecoration(labelText: 'TITLE'), enabled: !isUploading),
                  const SizedBox(height: 15),
                  TextField(controller: descController, decoration: const InputDecoration(labelText: 'DESCRIPTION'), maxLines: 3, enabled: !isUploading),
                  const SizedBox(height: 15),
                  TextField(controller: studioController, decoration: const InputDecoration(labelText: 'STUDIO'), enabled: !isUploading),
                  const SizedBox(height: 15),
                  TextField(controller: yearController, decoration: const InputDecoration(labelText: 'YEAR'), enabled: !isUploading),
                  const SizedBox(height: 15),
                  TextField(controller: tagsController, decoration: const InputDecoration(labelText: 'TAGS'), enabled: !isUploading),
                  const SizedBox(height: 15),
                  SwitchListTile(
                    title: const Text('PREMIUM QUALITY', style: TextStyle(fontSize: 12)),
                    value: isPremium,
                    onChanged: isUploading ? null : (v) => setDialogState(() => isPremium = v),
                  ),

                  if (isUploading) ...[
                    const SizedBox(height: 30),
                    LinearProgressIndicator(
                      value: uploadProgress,
                      backgroundColor: Colors.white12,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'UPLOADING: ${(uploadProgress * 100).toInt()}%',
                      style: const TextStyle(color: Colors.white54, fontSize: 10, letterSpacing: 1),
                    ),
                  ],

                  if (statusMessage != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 20),
                      child: Text(
                        statusMessage!,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: statusMessage!.contains('FAILED') ? Colors.red : Colors.green,
                          fontSize: 11,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context), 
              child: Text(isUploading ? 'RUN IN BACKGROUND' : 'CANCEL', style: const TextStyle(color: Colors.white38))
            ),
            if (!isUploading)
              ElevatedButton(
                onPressed: (coverBytes == null) ? null : () async {
                  setDialogState(() {
                     isUploading = true;
                     uploadProgress = 0.05;
                     statusMessage = "Starting upload...";
                  });
                  
                  try {
                    String coverUrl = '';
                    List<String> galleryUrls = [];

                    if (Firebase.apps.isNotEmpty) {
                      final storageRef = FirebaseStorage.instance.ref();
                      
                      // 1. Upload Cover
                      final coverRef = storageRef.child('portfolio/${DateTime.now().millisecondsSinceEpoch}_cover.jpg');
                      await coverRef.putData(coverBytes!);
                      coverUrl = await coverRef.getDownloadURL();
                      setDialogState(() {
                        uploadProgress = 0.2;
                        statusMessage = "Cover photo uploaded. Processing gallery...";
                      });

                      // 2. Upload Gallery
                      for (var i = 0; i < gallery.length; i++) {
                        final gRef = storageRef.child('portfolio/${DateTime.now().millisecondsSinceEpoch}_$i.jpg');
                        final bytes = await gallery[i].readAsBytes();
                        await gRef.putData(bytes);
                        final url = await gRef.getDownloadURL();
                        galleryUrls.add(url);
                        
                        setDialogState(() {
                          uploadProgress = 0.2 + ((i + 1) / gallery.length) * 0.7;
                          statusMessage = "Uploaded ${i + 1} of ${gallery.length} photos...";
                        });
                      }
                    } else {
                      // Fallback for Demo
                      coverUrl = Uri.dataFromBytes(coverBytes!, mimeType: 'image/jpeg').toString();
                      for (var file in gallery) {
                        final bytes = await file.readAsBytes();
                        galleryUrls.add(Uri.dataFromBytes(bytes, mimeType: 'image/jpeg').toString());
                      }
                      uploadProgress = 1.0;
                    }

                    final project = Project(
                      id: DateTime.now().millisecondsSinceEpoch.toString(),
                      title: titleController.text.trim(),
                      description: descController.text.trim(),
                      imageUrl: coverUrl,
                      galleryUrls: galleryUrls,
                      category: widget.category,
                      subCategory: widget.subCategory,
                      isPremium: isPremium,
                      studio: studioController.text.trim(),
                      year: yearController.text.trim(),
                      tags: tagsController.text.split(',').map((t) => t.trim()).where((t) => t.isNotEmpty).toList(),
                    );

                    await ref.read(projectsProvider.notifier).addProject(project);
                    if (mounted) Navigator.pop(context);
                  } catch (e) {
                    setDialogState(() {
                      isUploading = false;
                      statusMessage = "UPLOAD FAILED: $e";
                    });
                  }
                },
                child: const Text('UPLOAD SESSION'),
              ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _startAddSession,
      child: AspectRatio(
        aspectRatio: 0.8,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.05),
            border: Border.all(color: Colors.white10, width: 1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.cloud_upload_outlined, size: 40, color: Colors.white24),
              SizedBox(height: 20),
              Text(
                'UPLOAD NEW SESSION',
                style: TextStyle(
                  color: Colors.white24,
                  fontSize: 10,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 2,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class PortfolioPremiumView extends StatelessWidget {
  final VoidCallback onBack;
  final ScrollController scrollController;
  final List<Project> projects;

  const PortfolioPremiumView({
    super.key,
    required this.onBack,
    required this.scrollController,
    required this.projects,
  });

  @override
  Widget build(BuildContext context) {
    final premiumProjects = projects.where((p) => p.isPremium).toList();
    final isMobile = MediaQuery.of(context).size.width < 800;

    return CustomScrollView(
      controller: scrollController,
      slivers: [
        const SliverToBoxAdapter(child: SizedBox(height: 140)),
        SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: isMobile ? 20 : 60),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextButton.icon(
                  onPressed: onBack,
                  icon: const Icon(Icons.arrow_back, size: 16),
                  label: const Text('BACK TO MENU'),
                  style: TextButton.styleFrom(foregroundColor: Colors.white60),
                ),
                const SizedBox(height: 20),
                FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'PREMIUM QUALITY COLLECTIONS',
                    style: Theme.of(context).textTheme.displaySmall!.copyWith(
                      fontSize: isMobile ? 24 : 36,
                      letterSpacing: 2,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  'A curated selection of our finest high-end photographic works.',
                  style: TextStyle(color: Colors.white38, fontSize: isMobile ? 12 : 14),
                ),
              ],
            ),
          ),
        ),
        SliverPadding(
          padding: EdgeInsets.symmetric(horizontal: isMobile ? 20 : 60, vertical: 40),
          sliver: premiumProjects.isEmpty
            ? const SliverToBoxAdapter(child: Center(child: Padding(
                padding: EdgeInsets.all(100.0),
                child: Text('NO PREMIUM WORKS FOUND', style: TextStyle(color: Colors.white24, letterSpacing: 4)),
              )))
            : SliverMasonryGrid.count(
                crossAxisCount: isMobile ? 1 : 3,
                mainAxisSpacing: 30,
                crossAxisSpacing: 30,
                itemBuilder: (context, index) => ProjectCard(
                  project: premiumProjects[index],
                  aspectRatio: 0.8, 
                ),
                childCount: premiumProjects.length,
              ),
        ),
        const SliverToBoxAdapter(child: SizedBox(height: 100)),
      ],
    );
  }
}
