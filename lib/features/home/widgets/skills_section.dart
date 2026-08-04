import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_theme.dart';
import '../../../models/skill_model.dart';
import '../../../repositories/portfolio_repository.dart';
import '../../../utils/responsive.dart';
import '../../../widgets/outline_card.dart';
import '../../../widgets/scroll_reveal.dart';
import '../../../widgets/section_title.dart';

class SkillsSection extends ConsumerWidget {
  const SkillsSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categories = ref.watch(skillCategoriesProvider);
    final columns = Responsive.gridColumns(context);

    return categories.when(
      loading: () => const Center(
        child: CircularProgressIndicator(),
      ),
      error: (e, _) => Center(
        child: Text(e.toString()),
      ),
      data: (categories) {
        return Container(
          width: double.infinity,
          color: AppColors.backgroundSecondary,
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
                    index: '02',
                    eyebrow: 'skills',
                    heading: 'What I Work With',
                    subheading:
                        'The languages, platforms and tools I use to turn ideas into shipped products.',
                  ),
                  const SizedBox(height: 40),
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: categories.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: columns,
                      crossAxisSpacing: 20,
                      mainAxisSpacing: 20,
                      mainAxisExtent: 320,
                    ),
                    itemBuilder: (context, index) {
                      return ScrollReveal(
                        id: 'skill-cat-$index',
                        child: _SkillCategoryCard(
                          category: categories[index],
                        ),
                      );
                    },
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

class _SkillCategoryCard extends StatelessWidget {
  final SkillCategory category;
  const _SkillCategoryCard({required this.category});

  @override
  Widget build(BuildContext context) {
    final accent = context.accent;
    return OutlineCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppColors.background,
                  border: Border.all(color: accent),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(category.icon, color: accent, size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  category.title,
                  style: Theme.of(context).textTheme.titleLarge,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          Expanded(
            child: ListView.separated(
              physics: const NeverScrollableScrollPhysics(),
              itemCount: category.skills.length,
              separatorBuilder: (_, __) => const SizedBox(height: 10),
              itemBuilder: (context, i) =>
                  _SkillItem(skill: category.skills[i]),
            ),
          ),
        ],
      ),
    );
  }
}

class _SkillItem extends StatelessWidget {
  final Skill skill;
  const _SkillItem({required this.skill});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.background,
        border: Border.all(color: AppColors.outlineSubtle),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          skill.brandIcon != null
              ? FaIcon(skill.brandIcon, color: context.accent, size: 20)
              : Icon(skill.icon, color: context.accent, size: 20),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              skill.name,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
        ],
      ),
    );
  }
}
