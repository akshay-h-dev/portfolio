import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../config/seo_config.dart';
import '../../repositories/portfolio_repository.dart';
import '../../services/seo_service.dart';
import '../../utils/resume_launcher.dart';
import '../../widgets/footer.dart';
import '../../widgets/nav_bar.dart';
import 'widgets/about_section.dart';
import 'widgets/certifications_section.dart';
import 'widgets/contact_section.dart';
import 'widgets/hero_section.dart';
import 'widgets/projects_section.dart';
import 'widgets/skills_section.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  final _aboutKey = GlobalKey();
  final _skillsKey = GlobalKey();
  final _projectsKey = GlobalKey();
  final _certsKey = GlobalKey();
  final _contactKey = GlobalKey();
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final seo = ref.read(seoServiceProvider);

      seo.applyRoute(
        SeoConfig.home,
        canonicalPath: '/',
      );

      final projects = await ref.read(projectsProvider.future);

      for (final project in projects) {
        seo.setJsonLd(
          'project-jsonld-${project.slug}',
          project.toSchemaOrgJson(),
        );
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollTo(GlobalKey key) {
    final ctx = key.currentContext;
    if (ctx != null) {
      Scrollable.ensureVisible(
        ctx,
        duration: const Duration(milliseconds: 600),
        curve: Curves.easeInOutCubic,
      );
    }
  }

  void _scrollToTop() {
    _scrollController.animateTo(
      0,
      duration: const Duration(milliseconds: 600),
      curve: Curves.easeInOutCubic,
    );
  }

  Future<void> _downloadResume() => downloadResume();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: NavBar(
        onLogoTap: _scrollToTop,
        onResumeTap: _downloadResume,
        items: [
          NavItem('About', () => _scrollTo(_aboutKey)),
          NavItem('Skills', () => _scrollTo(_skillsKey)),
          NavItem('Projects', () => _scrollTo(_projectsKey)),
          NavItem('Certifications', () => _scrollTo(_certsKey)),
          NavItem('Contact', () => _scrollTo(_contactKey)),
        ],
      ),
      body: SingleChildScrollView(
        controller: _scrollController,
        child: Column(
          children: [
            HeroSection(
              onViewProjects: () => _scrollTo(_projectsKey),
              onDownloadResume: _downloadResume,
              onContactMe: () => _scrollTo(_contactKey),
            ),
            AboutSection(key: _aboutKey),
            SkillsSection(key: _skillsKey),
            ProjectsSection(key: _projectsKey),
            CertificationsSection(key: _certsKey),
            ContactSection(key: _contactKey),
            const SiteFooter(),
          ],
        ),
      ),
    );
  }
}
