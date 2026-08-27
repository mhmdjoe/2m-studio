import 'package:anosh/features/admin/admin_provider.dart';
import 'package:anosh/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class NavBar extends ConsumerStatefulWidget {
  final double scrollOffset;

  const NavBar({
    super.key, 
    this.scrollOffset = 0.0,
  });

  @override
  ConsumerState<NavBar> createState() => _NavBarState();
}

class _NavBarState extends ConsumerState<NavBar> with SingleTickerProviderStateMixin {
  bool _isMenuOpen = false;
  late AnimationController _menuController;
  late Animation<double> _menuAnimation;
  
  @override
  void initState() {
    super.initState();
    _menuController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _menuAnimation = CurvedAnimation(
      parent: _menuController,
      curve: Curves.easeOutQuart,
    );
  }

  @override
  void dispose() {
    _menuController.dispose();
    super.dispose();
  }

  void _toggleMenu() {
    setState(() {
      _isMenuOpen = !_isMenuOpen;
      if (_isMenuOpen) {
        _menuController.forward();
      } else {
        _menuController.reverse();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final double shrinkFactor = (widget.scrollOffset / 300).clamp(0.0, 1.0);
    final double verticalMargin = 12.0 - (8.0 * shrinkFactor);
    final double innerPaddingVertical = 12.0 - (8.0 * shrinkFactor);
    final double logoHeight = 45.0 - (15.0 * shrinkFactor);
    final isAdmin = ref.watch(isAdminProvider);

    return LayoutBuilder(
      builder: (context, constraints) {
        final isMobile = constraints.maxWidth < 1100;

        return Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1400),
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                // 1. MOBILE DROPDOWN MENU (Placed behind the bar but expands below)
                if (isMobile)
                  Positioned(
                    top: verticalMargin + 50,
                    left: 15,
                    right: 15,
                    child: SizeTransition(
                      sizeFactor: _menuAnimation,
                      alignment: Alignment.topCenter,
                      child: FadeTransition(
                        opacity: _menuAnimation,
                        child: AppTheme.glassEffect(
                          opacity: 0.95,
                          borderRadius: BorderRadius.circular(24),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 30),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                _MobileNavButton(label: 'HOME', path: '/home', onTap: () { context.go('/home'); _toggleMenu(); }),
                                _MobileNavButton(label: 'ABOUT US', path: '/about', onTap: () { context.go('/about'); _toggleMenu(); }),
                                _MobileNavButton(label: 'PORTFOLIO', path: '/portfolio', onTap: () { context.go('/portfolio'); _toggleMenu(); }),
                                _MobileNavButton(label: 'CONTACT', path: '/contact', onTap: () { context.go('/contact'); _toggleMenu(); }),
                                if (isAdmin)
                                  _MobileNavButton(
                                    label: 'LOGOUT (ADMIN)', 
                                    path: '/logout', 
                                    onTap: () { 
                                      ref.read(adminNotifierProvider.notifier).logout(); 
                                      _toggleMenu(); 
                                    }
                                  ),
                                const SizedBox(height: 20),
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 40),
                                  child: SizedBox(
                                    width: double.infinity,
                                    child: ElevatedButton(
                                      onPressed: () { context.go('/booking'); _toggleMenu(); },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: AppTheme.accentColor,
                                        foregroundColor: Colors.black,
                                        padding: const EdgeInsets.symmetric(vertical: 20),
                                        shape: const StadiumBorder(),
                                      ),
                                      child: const Text('BOOK A SESSION', style: TextStyle(fontWeight: FontWeight.w900, letterSpacing: 2)),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),

                // 2. MAIN NAVBAR CAPSULE
                AnimatedContainer(
                  duration: const Duration(milliseconds: 400),
                  curve: Curves.easeOutCubic,
                  margin: EdgeInsets.symmetric(
                    horizontal: isMobile ? 15 : 20, 
                    vertical: verticalMargin
                  ),
                  child: AppTheme.glassEffect(
                    opacity: 0.4 + (0.4 * shrinkFactor),
                    borderRadius: BorderRadius.circular(100),
                    child: AnimatedPadding(
                      duration: const Duration(milliseconds: 200),
                      padding: EdgeInsets.symmetric(
                        horizontal: isMobile ? 15 : 30, 
                        vertical: isMobile ? 8 : innerPaddingVertical
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // Logo
                          GestureDetector(
                            onTap: () => context.go('/home'),
                            child: MouseRegion(
                              cursor: SystemMouseCursors.click,
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 200),
                                height: isMobile ? 32 : logoHeight,
                                child: Image.asset(
                                  'assets/images/logo_icon.png',
                                  fit: BoxFit.contain,
                                ),
                              ),
                            ),
                          ),
                          
                          // Desktop Nav Links
                          if (!isMobile)
                            const _DesktopNavLinks(),
    
                          // Mobile Hamburger
                          if (isMobile)
                            IconButton(
                              icon: AnimatedSwitcher(
                                duration: const Duration(milliseconds: 300),
                                child: Icon(
                                  _isMenuOpen ? Icons.close_rounded : Icons.grid_view_rounded,
                                  key: ValueKey(_isMenuOpen),
                                  color: Colors.white,
                                  size: 20,
                                ),
                              ),
                              onPressed: _toggleMenu,
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _DesktopNavLinks extends ConsumerStatefulWidget {
  const _DesktopNavLinks();

  @override
  ConsumerState<_DesktopNavLinks> createState() => _DesktopNavLinksState();
}

class _DesktopNavLinksState extends ConsumerState<_DesktopNavLinks> {
  final Map<String, GlobalKey> _keys = {
    '/home': GlobalKey(),
    '/about': GlobalKey(),
    '/portfolio': GlobalKey(),
    '/contact': GlobalKey(),
  };

  double _indicatorLeft = 0;
  double _indicatorWidth = 0;
  bool _initialized = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _updateIndicator());
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    WidgetsBinding.instance.addPostFrameCallback((_) => _updateIndicator());
  }

  void _updateIndicator() {
    if (!mounted) return;
    final String currentPath = GoRouterState.of(context).uri.path;
    
    String? activePath;
    for (var path in _keys.keys) {
      if (currentPath.startsWith(path)) {
        activePath = path;
        break;
      }
    }

    if (activePath == null) return;

    final key = _keys[activePath];
    final RenderBox? box = key?.currentContext?.findRenderObject() as RenderBox?;
    final RenderBox? stackBox = context.findRenderObject() as RenderBox?;

    if (box != null && stackBox != null) {
      final offset = box.localToGlobal(Offset.zero, ancestor: stackBox);
      if (_indicatorLeft != offset.dx || _indicatorWidth != box.size.width) {
        setState(() {
          _indicatorLeft = offset.dx;
          _indicatorWidth = box.size.width;
          _initialized = true;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isAdmin = ref.watch(isAdminProvider);

    return Stack(
      children: [
        if (_initialized)
          AnimatedPositioned(
            duration: const Duration(milliseconds: 350),
            curve: Curves.easeOutQuart,
            left: _indicatorLeft,
            width: _indicatorWidth,
            top: 0,
            bottom: 0,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(100),
                color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.12),
                border: Border.all(color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.2), width: 1),
              ),
            ),
          ),

        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _NavButton(key: _keys['/home'], label: 'HOME', path: '/home', onTap: () => context.go('/home')),
            _NavButton(key: _keys['/about'], label: 'ABOUT US', path: '/about', onTap: () => context.go('/about')),
            _NavButton(key: _keys['/portfolio'], label: 'PORTFOLIO', path: '/portfolio', onTap: () => context.go('/portfolio')),
            _NavButton(key: _keys['/contact'], label: 'CONTACT', path: '/contact', onTap: () => context.go('/contact')),
            if (isAdmin)
               Padding(
                 padding: const EdgeInsets.only(left: 10),
                 child: TextButton(
                   onPressed: () => ref.read(adminNotifierProvider.notifier).logout(),
                   child: const Text('LOGOUT', style: TextStyle(color: Colors.white24, fontSize: 9, letterSpacing: 2)),
                 ),
               ),
            const SizedBox(width: 20),
            ElevatedButton(
              onPressed: () => context.go('/booking'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.primary,
                foregroundColor: Colors.black,
                elevation: 0,
                padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 15),
                shape: const StadiumBorder(),
              ),
              child: const Text('BOOK A SESSION', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 11)),
            ),
          ],
        ),
      ],
    );
  }
}

class _NavButton extends StatelessWidget {
  final String label;
  final String path;
  final VoidCallback onTap;

  const _NavButton({
    super.key,
    required this.label, 
    required this.path,
    required this.onTap
  });

  @override
  Widget build(BuildContext context) {
    final String currentPath = GoRouterState.of(context).uri.path;
    final bool isActive = currentPath.startsWith(path);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4.0),
      child: InkWell(
        onTap: onTap,
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: AnimatedDefaultTextStyle(
            duration: const Duration(milliseconds: 200),
            style: Theme.of(context).textTheme.labelLarge!.copyWith(
              color: isActive ? Colors.white : Colors.white60,
              fontSize: 10,
              letterSpacing: 2,
              fontWeight: isActive ? FontWeight.w900 : FontWeight.w500,
            ),
            child: Text(label),
          ),
        ),
      ),
    );
  }
}

class _MobileNavButton extends StatelessWidget {
  final String label;
  final String path;
  final VoidCallback onTap;

  const _MobileNavButton({required this.label, required this.path, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final String currentPath = GoRouterState.of(context).uri.path;
    final bool isActive = currentPath.startsWith(path);

    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 30),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (isActive)
              Container(
                width: 8,
                height: 8,
                margin: const EdgeInsets.only(right: 15),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            Text(
              label,
              style: Theme.of(context).textTheme.labelLarge!.copyWith(
                color: isActive ? Colors.white : Colors.white70,
                fontSize: 16,
                letterSpacing: 6,
                fontWeight: isActive ? FontWeight.w900 : FontWeight.w300,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
