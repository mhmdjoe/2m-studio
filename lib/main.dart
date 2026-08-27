import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:anosh/theme/app_theme.dart';
import 'package:anosh/pages/home_page.dart';
import 'package:anosh/pages/loading_page.dart';
import 'package:anosh/pages/portfolio_page.dart';
import 'package:anosh/pages/contact_page.dart';
import 'package:anosh/pages/booking_page.dart';
import 'package:anosh/pages/project_detail_page.dart';
import 'package:anosh/pages/about_page.dart';
import 'package:anosh/pages/admin/admin_login_page.dart';
import 'package:anosh/widgets/custom_cursor.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:anosh/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  bool firebaseInitialized = false;
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    firebaseInitialized = true;
    // ignore: avoid_print
    print('Firebase initialized successfully: ${Firebase.app().options.projectId}');
  } catch (e) {
    // ignore: avoid_print
    print('CRITICAL: Firebase failed to initialize: $e');
  }

  runApp(
    ProviderScope(
      overrides: [
        // We can pass the init status to a provider if needed later
      ],
      child: const PhotographerApp(),
    ),
  );
}

class PhotographerApp extends ConsumerWidget {
  const PhotographerApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final GoRouter router = GoRouter(
      initialLocation: '/',
      routes: [
        GoRoute(
          path: '/',
          builder: (context, state) => const LoadingPage(),
        ),
        GoRoute(
          path: '/home',
          builder: (context, state) => const HomePage(),
        ),
        GoRoute(
          path: '/portfolio',
          builder: (context, state) {
            final view = state.uri.queryParameters['view'];
            return PortfolioPage(startWithPremium: view == 'premium');
          },
        ),
        GoRoute(
          path: '/portfolio/:projectId',
          pageBuilder: (context, state) {
            final projectId = state.pathParameters['projectId']!;
            return CustomTransitionPage(
              key: state.pageKey,
              child: ProjectDetailPage(projectId: projectId),
              transitionsBuilder: (context, animation, secondaryAnimation, child) {
                return FadeTransition(
                  opacity: CurveTween(curve: Curves.easeInOutCirc).animate(animation),
                  child: child,
                );
              },
            );
          },
        ),
        GoRoute(
          path: '/about',
          builder: (context, state) => const AboutPage(),
        ),
        GoRoute(
          path: '/contact',
          builder: (context, state) => const ContactPage(),
        ),
        GoRoute(
          path: '/booking',
          builder: (context, state) => const BookingPage(),
        ),
        GoRoute(
          path: '/admin-login',
          builder: (context, state) => const AdminLoginPage(),
        ),
      ],
    );

    return MaterialApp.router(
      title: '2M STUDIO | ELITE PHOTOGRAPHY',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      routerConfig: router,
      builder: (context, child) {
        return CustomCursor(child: child!);
      },
    );
  }
}
