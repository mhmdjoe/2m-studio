import 'package:flutter/material.dart';

class ServiceWorkflow extends StatelessWidget {
  const ServiceWorkflow({super.key});

  @override
  Widget build(BuildContext context) {
    final steps = [
      {'title': 'ART DIRECTION', 'desc': 'Concept development and mood boarding.'},
      {'title': 'PRODUCTION', 'desc': 'Professional session in-studio or on-location.'},
      {'title': 'RETOUCHING', 'desc': 'High-end post-production and color grading.'},
      {'title': 'DELIVERY', 'desc': 'Fast, secure delivery via client portal.'},
    ];

    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 800;

    return Container(
      padding: EdgeInsets.symmetric(vertical: 40, horizontal: isMobile ? 20 : 40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              'OUR PROCESS',
              style: Theme.of(context).textTheme.displayMedium!.copyWith(
                fontSize: isMobile ? 32 : 56,
              ),
            ),
          ),
          const SizedBox(height: 30),
          if (isMobile)
            Column(
              children: steps.map((step) => _WorkflowStep(
                number: (steps.indexOf(step) + 1).toString().padLeft(2, '0'),
                title: step['title']!,
                description: step['desc']!,
                isMobile: true,
              )).toList(),
            )
          else
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: steps.map((step) => Expanded(
                child: _WorkflowStep(
                  number: (steps.indexOf(step) + 1).toString().padLeft(2, '0'),
                  title: step['title']!,
                  description: step['desc']!,
                  isMobile: false,
                ),
              )).toList(),
            ),
        ],
      ),
    );
  }
}

class _WorkflowStep extends StatelessWidget {
  final String number;
  final String title;
  final String description;
  final bool isMobile;

  const _WorkflowStep({
    required this.number,
    required this.title,
    required this.description,
    required this.isMobile,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        right: isMobile ? 0 : 30.0,
        bottom: isMobile ? 40.0 : 0,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            number,
            style: Theme.of(context).textTheme.displayMedium?.copyWith(
              color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.3),
              fontSize: isMobile ? 40 : 60,
            ),
          ),
          const SizedBox(height: 10),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              title,
              style: Theme.of(context).textTheme.titleLarge!.copyWith(
                fontSize: isMobile ? 18 : 22,
                letterSpacing: 2,
              ),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            description,
            style: Theme.of(context).textTheme.bodyMedium!.copyWith(
              fontSize: isMobile ? 13 : 14,
              height: 1.5,
              color: Colors.white70,
            ),
          ),
        ],
      ),
    );
  }
}
