import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:anosh/widgets/navbar.dart';
import 'package:anosh/widgets/service_workflow.dart';
import 'package:anosh/widgets/scroll_animated_photo.dart';
import 'package:anosh/widgets/horizontal_reveal_wrapper.dart';
import 'package:anosh/widgets/bento_grid.dart';
import 'package:anosh/widgets/magnetic_wrapper.dart';
import 'package:anosh/models/project.dart';
import 'package:anosh/features/retouching_showcase/retouching_slider.dart';
import 'package:anosh/widgets/developer_signature.dart';
import 'package:anosh/widgets/premium_reveal.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  final ScrollController _scrollController = ScrollController();
  double _scrollOffset = 0.0;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      setState(() {
        _scrollOffset = _scrollController.offset;
      });
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 800;

    return Scaffold(
      body: Stack(
        children: [
          // 1. Scrollable Content
          SingleChildScrollView(
            controller: _scrollController,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Hero Section
                Stack(
                  children: [
                    // Parallax Background
                    Positioned(
                      top: -_scrollOffset * 0.4,
                      left: 0,
                      right: 0,
                      height: MediaQuery.of(context).size.height,
                      child: Container(
                        decoration: const BoxDecoration(
                          image: DecorationImage(
                            image: NetworkImage('https://images.unsplash.com/photo-1542038784456-1ea8e935640e?auto=format&fit=crop&q=80&w=2000'),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                    
                    // Dark Overlay
                    Container(
                      width: double.infinity,
                      height: MediaQuery.of(context).size.height,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.black.withValues(alpha: 0.3),
                            Colors.black.withValues(alpha: 1.0),
                          ],
                        ),
                      ),
                    ),
                    
                    SizedBox(
                      height: MediaQuery.of(context).size.height,
                      child: Center(
                        child: HeroSection(scrollOffset: _scrollOffset),
                      ),
                    ),
                  ],
                ),

                // Kinetic Ticker Text
                _KineticTicker(scrollOffset: _scrollOffset),

                const SizedBox(height: 10),

                // Editorial Portfolio Section 01
                _SectionHeader(
                  number: '01',
                  title: 'SELECTED\nARTWORKS.',
                  actionLabel: isMobile ? null : 'VIEW ARCHIVE',
                  onAction: () => context.go('/portfolio'),
                  scrollOffset: _scrollOffset,
                ),
                const SizedBox(height: 30),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: BentoGrid(projects: mockProjects),
                ),

                const SizedBox(height: 60),

                // Retouching Section 02
                PremiumReveal(
                  uniqueId: 'home-retouching-section',
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _SectionHeader(
                        number: '02',
                        title: 'MASTERED\nRETOUCH.',
                        scrollOffset: _scrollOffset,
                      ),
                      const SizedBox(height: 30),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: isMobile 
                          ? Column(
                              children: [
                                HorizontalScanReveal(
                                  uniqueId: 'retouching-slider-home-v2',
                                  child: const RetouchingSlider(
                                    beforeImageUrl: 'https://images.unsplash.com/photo-1522335789203-aabd1fc54bc9?auto=format&fit=crop&q=80&w=1000&grayscale=1',
                                    afterImageUrl: 'https://images.unsplash.com/photo-1522335789203-aabd1fc54bc9?auto=format&fit=crop&q=80&w=1000',
                                  ),
                                ),
                                const SizedBox(height: 40),
                                _RetouchingInfo(),
                              ],
                            )
                          : Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Expanded(
                                  flex: 3,
                                  child: HorizontalScanReveal(
                                    uniqueId: 'retouching-slider-home-v2',
                                    child: const RetouchingSlider(
                                      beforeImageUrl: 'https://images.unsplash.com/photo-1522335789203-aabd1fc54bc9?auto=format&fit=crop&q=80&w=1000&grayscale=1',
                                      afterImageUrl: 'https://images.unsplash.com/photo-1522335789203-aabd1fc54bc9?auto=format&fit=crop&q=80&w=1000',
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 80),
                                Expanded(
                                  flex: 2,
                                  child: _RetouchingInfo(),
                                ),
                              ],
                            ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 60),

                // Section 03
                PremiumReveal(
                  uniqueId: 'home-vision-section',
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _SectionHeader(
                        number: '03',
                        title: 'THE ART OF\nVISION.',
                        scrollOffset: _scrollOffset,
                      ),
                      const SizedBox(height: 30),
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20.0),
                        child: ScrollAnimatedPhoto(
                          imageUrl: 'https://images.unsplash.com/photo-1534528741775-53994a69daeb?auto=format&fit=crop&q=80&w=2000',
                          title: 'PREMIUM QUALITY',
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 60),
                
                // Workflow
                const PremiumReveal(
                  uniqueId: 'home-workflow-section',
                  child: ServiceWorkflow(),
                ),
                
                const SizedBox(height: 30),

                // Final CTA
                PremiumReveal(
                  uniqueId: 'home-final-cta',
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 80, horizontal: 20),
                    child: Column(
                      children: [
                        FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text(
                            'MAKE YOUR BRAND BETTER.',
                            style: Theme.of(context).textTheme.displayMedium!.copyWith(
                              fontSize: isMobile ? 32 : 56,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        const SizedBox(height: 40),
                        MagneticWrapper(
                          cursorHint: 'NOW',
                          child: ElevatedButton(
                            onPressed: () => context.go('/booking'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Theme.of(context).colorScheme.primary,
                              foregroundColor: Colors.black,
                              padding: EdgeInsets.symmetric(
                                horizontal: isMobile ? 60 : 120, 
                                vertical: isMobile ? 25 : 45
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: Text(
                              'BOOK A SESSION', 
                              style: TextStyle(
                                fontWeight: FontWeight.w900, 
                                letterSpacing: isMobile ? 4 : 10, 
                                fontSize: isMobile ? 14 : 18
                              )
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                
                const DeveloperSignature(),
              ],
            ),
          ),

          // 2. Floating Persistent NavBar
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: NavBar(scrollOffset: _scrollOffset),
          ),
        ],
      ),
    );
  }
}

class _RetouchingInfo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'BEYOND THE CAPTURE',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 30),
        Text(
          'We believe that photography is only half the journey. Our elite post-production suite transforms raw data into commercial excellence through precision color grading and skin mastering.',
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        const SizedBox(height: 40),
        MagneticWrapper(
          cursorHint: 'BOOK',
          child: OutlinedButton(
            onPressed: () => context.push('/contact'),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 25),
              side: const BorderSide(color: Colors.white10),
            ),
            child: const Text('START A PROJECT'),
          ),
        ),
      ],
    );
  }
}

class _KineticTicker extends StatelessWidget {
  final double scrollOffset;
  const _KineticTicker({required this.scrollOffset});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 800;

    return Container(
      height: isMobile ? 60 : 100,
      width: double.infinity,
      color: Colors.black,
      child: Stack(
        children: [
          Positioned(
            left: -scrollOffset * 0.3,
            child: Row(
              children: List.generate(10, (index) => Padding(
                padding: EdgeInsets.symmetric(horizontal: isMobile ? 20.0 : 40.0),
                child: Text(
                  'FASHION •COMMERCIAL • PRODUCT • FLATLAY • SHOES • INDOOR • OUTDOOR • ',
                  style: Theme.of(context).textTheme.displaySmall!.copyWith(
                    color: Theme.of(context).colorScheme.primary,
                    fontWeight: FontWeight.w900,
                    fontSize: isMobile ? 20 : 32,
                  ),
                ),
              )),
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String number;
  final String title;
  final String? actionLabel;
  final VoidCallback? onAction;
  final double scrollOffset;

  const _SectionHeader({
    required this.number,
    required this.title,
    this.actionLabel,
    this.onAction,
    required this.scrollOffset,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 800;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.baseline,
        textBaseline: TextBaseline.alphabetic,
        children: [
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.alphabetic,
              children: [
                Text(number, style: Theme.of(context).textTheme.labelLarge),
                const SizedBox(width: 20),
                Expanded(
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    alignment: Alignment.centerLeft,
                    child: Text(
                      title.replaceAll('\n', ' '),
                      style: Theme.of(context).textTheme.displayLarge!.copyWith(
                        fontSize: isMobile ? 28 : 60,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          if (actionLabel != null && !isMobile)
            MagneticWrapper(
              cursorHint: 'GO',
              child: TextButton(
                onPressed: onAction,
                child: Text(
                  actionLabel!,
                  style: Theme.of(context).textTheme.labelLarge!.copyWith(
                    color: Colors.white,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class HeroSection extends StatelessWidget {
  final double scrollOffset;
  const HeroSection({super.key, required this.scrollOffset});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 800;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Transform.scale(
          scale: (1.0 + (scrollOffset * 0.0004)).clamp(1.0, 1.2),
          child: Image.asset(
            'assets/images/logo.png',
            height: isMobile ? 200 : 450, 
            fit: BoxFit.contain,
          ),
        ),
        SizedBox(height: isMobile ? 40 : 80),
        Opacity(
          opacity: (1.0 - (scrollOffset * 0.003)).clamp(0.0, 1.0),
          child: Column(
            children: [
              Text(
                'EST. 2015 — BASED IN CAIRO',
                style: Theme.of(context).textTheme.labelLarge!.copyWith(
                  color: Colors.white38,
                  letterSpacing: isMobile ? 4 : 10,
                  fontSize: isMobile ? 10 : 12,
                ),
              ),
              const SizedBox(height: 20),
              FittedBox(
                fit: BoxFit.scaleDown,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    'MASTERING THE ART OF COMMERCIAL VISION',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.titleLarge!.copyWith(
                      fontSize: isMobile ? 10 : 12,
                      fontWeight: FontWeight.w300,
                      letterSpacing: isMobile ? 6 : 12,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
