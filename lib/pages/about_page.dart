import 'package:flutter/material.dart';
import 'package:anosh/widgets/navbar.dart';
import 'package:anosh/theme/app_theme.dart';
import 'package:anosh/widgets/developer_signature.dart';

class AboutPage extends StatefulWidget {
  const AboutPage({super.key});

  @override
  State<AboutPage> createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> {
  final ScrollController _scrollController = ScrollController();
  double _scrollOffset = 0;

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

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 800;

    return Scaffold(
      body: Stack(
        children: [
          // Background subtle texture or gradient
          Positioned.fill(
            child: Container(
              color: Colors.black,
              child: Opacity(
                opacity: 0.1,
                child: Image.network(
                  'https://images.unsplash.com/photo-1492691527719-9d1e07e534b4?auto=format&fit=crop&q=80&w=2000',
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),

          // Scrollable Content
          Positioned.fill(
            child: SingleChildScrollView(
              controller: _scrollController,
              child: Center(
                child: Container(
                  constraints: const BoxConstraints(maxWidth: 1200),
                  padding: EdgeInsets.symmetric(horizontal: isMobile ? 20 : 60),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 200),
                      
                      // Heading
                      Text(
                        'ABOUT 2M STUDIO',
                        style: Theme.of(context).textTheme.labelLarge,
                      ),
                      const SizedBox(height: 20),
                      FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          'A DECADE OF VISUAL\nEXCELLENCE.',
                          style: Theme.of(context).textTheme.displayLarge!.copyWith(
                            fontSize: isMobile ? 48 : 90,
                            height: 1.0,
                          ),
                        ),
                      ),

                      const SizedBox(height: 80),

                      // Intro Paragraphs
                      _buildEditorialRow(
                        context,
                        'WHO WE ARE',
                        'We are a premier photography firm specializing in apparel and fashion with over 10 years of professional experience, operating multiple branches across Cairo and beyond.',
                        isMobile,
                      ),
                      _buildEditorialRow(
                        context,
                        'OUR HERITAGE',
                        'Established 7 years ago in Tanta and the North Delta, we expanded our vision to the heart of Egypt, opening our Nasr City branch in Cairo in 2021.',
                        isMobile,
                      ),
                      _buildEditorialRow(
                        context,
                        'SERVICES',
                        'From high-end flat lay photography and professional model sessions to cinematic video production and reels, we provide a complete suite of visual solutions.',
                        isMobile,
                      ),

                      const SizedBox(height: 100),

                      // Team Section
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(60),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.03),
                          border: Border.all(color: Colors.white10),
                        ),
                        child: Column(
                          children: [
                            Text(
                              'ELITE PROFESSIONALS',
                              style: Theme.of(context).textTheme.labelLarge,
                            ),
                            const SizedBox(height: 30),
                            Text(
                              'Our team comprises specialized photographers, professional photo editors, video montage experts, apparel organizers, and interior design specialists dedicated to meeting our clients\' diverse needs.',
                              textAlign: TextAlign.center,
                              style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontSize: 18, height: 1.8),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 150),

                      // Process Section
                      Text(
                        'OUR WORKFLOW',
                        style: Theme.of(context).textTheme.displaySmall,
                      ),
                      const SizedBox(height: 60),
                      _buildProcessItem('01', 'CONCEPTUALIZATION', 'Initial communication to present photography ideas, determine the optimal destination, and perform a preliminary project evaluation.'),
                      _buildProcessItem('02', 'PREPARATION', 'Receiving and fully preparing photography samples to ensure they are session-ready.'),
                      _buildProcessItem('03', 'EXECUTION', 'Precision photography performed by our specialized professional team.'),
                      _buildProcessItem('04', 'REFINEMENT', 'High-end photo editing and video montage executed by our professional post-production suite.'),
                      _buildProcessItem('05', 'DELIVERY', 'Fast delivery via secure Drive links or direct studio pickup.'),
                      _buildProcessItem('06', 'FOLLOW-UP', 'Post-delivery communication to ensure market suitability and total client satisfaction.'),

                      const SizedBox(height: 150),

                      // Vision & Goal
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('THE GOAL', style: Theme.of(context).textTheme.labelLarge),
                                const SizedBox(height: 20),
                                Text(
                                  'Highlighting your products with maximum impact to drive sales and elevate your brand presence in the competitive market.',
                                  style: Theme.of(context).textTheme.bodyLarge,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 40),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('THE VISION', style: Theme.of(context).textTheme.labelLarge),
                                const SizedBox(height: 20),
                                Text(
                                  'With a portfolio of over 400 factories and brands, we aim to become Egypt\'s largest customer base within two years, expanding our presence to every governorate.',
                                  style: Theme.of(context).textTheme.bodyLarge,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 150),

                      // Trusted Brands Section
                      Text(
                        'TRUSTED BY ELITE BRANDS',
                        style: Theme.of(context).textTheme.displaySmall,
                      ),
                      const SizedBox(height: 40),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.02),
                          border: Border.all(color: Colors.white10),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: Image.network(
                            'https://images.unsplash.com/photo-1542038784456-1ea8e935640e?auto=format&fit=crop&q=80&w=2000', // Placeholder
                            fit: BoxFit.contain,
                            loadingBuilder: (context, child, loadingProgress) {
                              if (loadingProgress == null) return child;
                              return const Center(child: CircularProgressIndicator(strokeWidth: 1));
                            },
                            errorBuilder: (context, error, stackTrace) => const Center(
                              child: Padding(
                                padding: EdgeInsets.all(40.0),
                                child: Text('BRAND LOGOS IMAGE PLACEHOLDER', style: TextStyle(color: Colors.white24)),
                              ),
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 150),

                      // Features Grid
                      Text(
                        'WHY CHOOSE 2M STUDIO',
                        style: Theme.of(context).textTheme.displaySmall,
                      ),
                      const SizedBox(height: 60),
                      _buildFeaturesGrid(context, isMobile),

                      const DeveloperSignature(),

                      const SizedBox(height: 200),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // NavBar
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

  Widget _buildEditorialRow(BuildContext context, String title, String content, bool isMobile) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 60.0),
      child: isMobile 
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: Theme.of(context).textTheme.labelLarge?.copyWith(fontSize: 10, color: Colors.white38)),
              const SizedBox(height: 15),
              Text(content, style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontSize: 18)),
            ],
          )
        : Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: 200,
                child: Text(title, style: Theme.of(context).textTheme.labelLarge?.copyWith(fontSize: 10, color: Colors.white38)),
              ),
              const SizedBox(width: 40),
              Expanded(
                child: Text(content, style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontSize: 22, height: 1.6)),
              ),
            ],
          ),
    );
  }

  Widget _buildProcessItem(String number, String title, String desc) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 40.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(number, style: const TextStyle(color: AppTheme.accentColor, fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(width: 25),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.bold, letterSpacing: 2, fontSize: 14)),
                const SizedBox(height: 8),
                Text(desc, style: const TextStyle(color: Colors.white54, height: 1.6)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeaturesGrid(BuildContext context, bool isMobile) {
    final features = [
      'Fast 1-Week Delivery',
      '3–5 Photos Per Item',
      'High-End Equipment',
      'Specialized Video Team',
      'Bulk Session Expertise',
      'Child Model Base',
      'Custom Creative Direction',
      'In-House Set Workshop',
      'Apparel Coordination',
      'Stylist Follow-up',
      'Indoor & Outdoor Sets',
    ];

    return Wrap(
      spacing: 20,
      runSpacing: 20,
      children: features.map((f) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 15),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.white10),
          borderRadius: BorderRadius.circular(100),
        ),
        child: Text(
          f.toUpperCase(),
          style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1),
        ),
      )).toList(),
    );
  }
}
