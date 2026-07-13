import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'core/theme/app_theme.dart';
import 'features/home/home_page.dart';
import 'state/accent_color_provider.dart';

void main() {
  runApp(const ProviderScope(child: PortfolioApp()));
}

/// Single-page portfolio — everything (hero, about, skills, projects,
/// certifications, contact) lives on HomePage as scroll-anchored sections.
class PortfolioApp extends ConsumerWidget {
  const PortfolioApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final accent = ref.watch(accentColorProvider);

    return MaterialApp(
      title: 'Akshay H | Flutter Developer, Backend Developer',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.themeFor(accent),
      home: const HomePage(),
      builder: (context, child) => ResponsiveBreakpoints.builder(
        child: child!,
        breakpoints: const [
          Breakpoint(start: 0, end: 599, name: MOBILE),
          Breakpoint(start: 600, end: 1023, name: TABLET),
          Breakpoint(start: 1024, end: 1439, name: DESKTOP),
          Breakpoint(start: 1440, end: double.infinity, name: '4K'),
        ],
      ),
    );
  }
}
