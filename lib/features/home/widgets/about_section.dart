import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_theme.dart';
import '../../../models/certification_model.dart';
import '../../../repositories/portfolio_repository.dart';
import '../../../utils/responsive.dart';
import '../../../widgets/outline_card.dart';
import '../../../widgets/scroll_reveal.dart';
import '../../../widgets/section_title.dart';

class AboutSection extends ConsumerWidget {
  const AboutSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final timeline = ref.watch(educationTimelineProvider);

    return timeline.when(
      loading: () => const Center(
        child: CircularProgressIndicator(),
      ),
      error: (e, _) => Center(
        child: Text(e.toString()),
      ),
      data: (timeline) {
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
                    index: '01',
                    eyebrow: 'about',
                    heading: 'About Me',
                  ),
                  const SizedBox(height: 40),
                  Responsive.isDesktop(context)
                      ? Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Expanded(
                              flex: 5,
                              child: _AboutText(),
                            ),
                            SizedBox(width: 56),
                            Expanded(
                              flex: 6,
                              child: _EducationTimeline(entries: timeline),
                            ),
                          ],
                        )
                      : Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const _AboutText(),
                            const SizedBox(height: 40),
                            _EducationTimeline(entries: timeline),
                          ],
                        ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _AboutText extends StatelessWidget {
  const _AboutText();

  @override
  Widget build(BuildContext context) {
    return ScrollReveal(
      id: 'about-text',
      child: OutlineCard(
        hoverLift: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(AppConstants.aboutMe,
                style: Theme.of(context).textTheme.bodyLarge),
            const SizedBox(height: 24),
            _StatRow(label: 'Institution', value: AppConstants.institution),
            const SizedBox(height: 12),
            _StatRow(label: 'Degree', value: AppConstants.degree),
            const SizedBox(height: 12),
            _StatRow(label: 'CGPA', value: AppConstants.cgpa),
          ],
        ),
      ),
    );
  }
}

class _StatRow extends StatelessWidget {
  final String label;
  final String value;
  const _StatRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 100,
          child: Text(label, style: Theme.of(context).textTheme.labelMedium),
        ),
        Expanded(
          child: Text(
            value,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppColors.textPrimary, fontWeight: FontWeight.w500),
          ),
        ),
      ],
    );
  }
}

class _EducationTimeline extends StatelessWidget {
  final List<TimelineEntry> entries;
  const _EducationTimeline({required this.entries});

  @override
  Widget build(BuildContext context) {
    return ScrollReveal(
      id: 'education-timeline',
      child: Column(
        children: [
          for (int i = 0; i < entries.length; i++)
            _TimelineTile(
              entry: entries[i],
              isLast: i == entries.length - 1,
            ),
        ],
      ),
    );
  }
}

class _TimelineTile extends StatelessWidget {
  final TimelineEntry entry;
  final bool isLast;
  const _TimelineTile({required this.entry, required this.isLast});

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              Container(
                width: 14,
                height: 14,
                decoration: BoxDecoration(
                  color: context.accent,
                  shape: BoxShape.circle,
                ),
              ),
              if (!isLast)
                Expanded(
                  child: Container(width: 2, color: AppColors.outlineSubtle),
                ),
            ],
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 28),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(entry.period,
                      style: Theme.of(context).textTheme.labelLarge),
                  const SizedBox(height: 6),
                  Text(entry.title,
                      style: Theme.of(context).textTheme.titleLarge),
                  if (entry.subtitle != null) ...[
                    const SizedBox(height: 4),
                    Text(entry.subtitle!,
                        style: Theme.of(context).textTheme.bodyMedium),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
