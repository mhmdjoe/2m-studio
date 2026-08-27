import 'package:flutter/material.dart';
import 'package:anosh/widgets/navbar.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:anosh/widgets/developer_signature.dart';

class ContactPage extends StatefulWidget {
  const ContactPage({super.key});

  @override
  State<ContactPage> createState() => _ContactPageState();
}

class _ContactPageState extends State<ContactPage> {
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
          // 1. Scrollable Content
          Positioned.fill(
            child: SingleChildScrollView(
              controller: _scrollController,
              child: Center(
                child: Container(
                  constraints: const BoxConstraints(maxWidth: 1200),
                  padding: EdgeInsets.symmetric(horizontal: isMobile ? 20 : 40),
                  child: Column(
                    children: [
                      SizedBox(height: isMobile ? 120 : 180),
                      FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          'CONTACT',
                          style: Theme.of(context).textTheme.displayMedium!.copyWith(
                            fontSize: isMobile ? 32 : 64,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        'Ways to get in touch with 2M studio.',
                        style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                          fontSize: isMobile ? 14 : 16,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: isMobile ? 60 : 100),
                      if (isMobile) ...[
                        _ContactInfoSection(
                          icon: Icons.mobile_screen_share_outlined,
                          title: 'PHONE',
                          content: '01033397672 & 01023707477',
                        ),
                        const SizedBox(height: 40),
                        _ContactInfoSection(
                          icon: Icons.location_on_outlined,
                          title: 'STUDIO',
                          content: 'NASRCITY, Cairo, Egypt',
                        ),
                      ] else ...[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _ContactInfoSection(
                              icon: Icons.mobile_screen_share_outlined,
                              title: 'PHONE',
                              content: '01033397672 & 01023707477',
                            ),
                            const SizedBox(width: 150),
                            _ContactInfoSection(
                              icon: Icons.location_on_outlined,
                              title: 'STUDIO',
                              content: 'NasrCity, Cairo, Egypt',
                            ),
                          ],
                        ),
                      ],
                      SizedBox(height: isMobile ? 60 : 100),
                      Text(
                        'FOLLOW US',
                        style: Theme.of(context).textTheme.labelLarge,
                      ),
                      const SizedBox(height: 40),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _SocialButton(
                            icon: FontAwesomeIcons.instagram,
                            url: 'https://www.instagram.com/2mstudio88?igsh=Nm8xMTd1YTkwcHZl',
                          ),
                          SizedBox(width: isMobile ? 20 : 40),
                          _SocialButton(
                            icon: FontAwesomeIcons.facebookF,
                            url: 'https://www.facebook.com/2mstudio88?mibextid=wwXIfr&rdid=OLkfDGzZddy5jANG&share_url=https%3A%2F%2Fwww.facebook.com%2Fshare%2F1DfTMHGPg1%2F%3Fmibextid%3DwwXIfr#',
                          ),
                          SizedBox(width: isMobile ? 20 : 40),
                          _SocialButton(
                            icon: FontAwesomeIcons.whatsapp,
                            url: 'https://wa.me/201033397672',
                          ),
                        ],
                      ),

                      const DeveloperSignature(),

                      const SizedBox(height: 150),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // 2. Floating NavBar
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

class _ContactInfoSection extends StatelessWidget {
  final IconData icon;
  final String title;
  final String content;

  const _ContactInfoSection({
    required this.icon,
    required this.title,
    required this.content,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 800;

    return Column(
      children: [
        Icon(icon, color: Theme.of(context).colorScheme.primary, size: isMobile ? 32 : 40),
        const SizedBox(height: 20),
        Text(
          title,
          style: Theme.of(context).textTheme.labelLarge,
        ),
        const SizedBox(height: 10),
        Text(
          content,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodyLarge,
        ),
      ],
    );
  }
}

class _SocialButton extends StatelessWidget {
  final dynamic icon;
  final String url;

  const _SocialButton({required this.icon, required this.url});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        final uri = Uri.parse(url);
        if (await canLaunchUrl(uri)) {
          await launchUrl(uri);
        }
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.white24),
          borderRadius: BorderRadius.circular(8),
        ),
        child: icon is IconData
            ? Icon(icon as IconData, size: 24, color: Colors.white)
            : FaIcon(icon as FaIconData, size: 24, color: Colors.white),
      ),
    );
  }
}
