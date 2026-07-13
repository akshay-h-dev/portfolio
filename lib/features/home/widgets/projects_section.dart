import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../repositories/portfolio_repository.dart';
import '../../../utils/responsive.dart';
import '../../../widgets/project_card.dart';
import '../../../widgets/scroll_reveal.dart';
import '../../../widgets/section_title.dart';

/// Full project write-ups live directly on the single home page now (no
/// separate /projects route) — each ProjectCard carries the contribution,
/// feature list, and tech stack inline, so cards are stacked full-width
/// rather than packed into a fixed-height grid.
class ProjectsSection extends ConsumerWidget {
  const ProjectsSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final projects = ref.watch(projectsProvider);

    return projects.when(
      loading: () => const Center(
        child: CircularProgressIndicator(),
      ),
      error: (e, _) => Center(
        child: Text(e.toString()),
      ),
      data: (projects) {
        return Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(
            horizontal: Responsive.horizontalPadding(context),
            vertical: 80,
          ),
          child: Center(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: Responsive.maxContentWidth(context),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SectionTitle(
                    index: '03',
                    eyebrow: 'projects',
                    heading: 'Selected Work',
                    subheading:
                        'A mix of embedded ML, mobile, and multi-agent backend systems.',
                  ),
                  const SizedBox(height: 40),
                  for (int i = 0; i < projects.length; i++) ...[
                    ScrollReveal(
                      id: 'project-$i',
                      child: ProjectCard(project: projects[i]),
                    ),
                    if (i != projects.length - 1) const SizedBox(height: 28),
                  ],
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
