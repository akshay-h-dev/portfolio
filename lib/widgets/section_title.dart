import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../core/theme/app_colors.dart';

/// Every major section opens with a code-comment-styled eyebrow
/// ("// 01 about") followed by a large heading. The `//` motif is a
/// deliberate nod to the developer subject matter rather than decoration.
class SectionTitle extends StatelessWidget {
  final String index; // e.g. "01"
  final String eyebrow; // e.g. "about"
  final String heading;
  final String? subheading;
  final CrossAxisAlignment alignment;

  const SectionTitle({
    super.key,
    required this.index,
    required this.eyebrow,
    required this.heading,
    this.subheading,
    this.alignment = CrossAxisAlignment.start,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: alignment,
      children: [
        Text(
          '// $index $eyebrow',
          style: Theme.of(context).textTheme.labelLarge,
        ).animate().fadeIn(duration: 400.ms).slideX(begin: -0.05, end: 0),
        const SizedBox(height: 10),
        Text(
          heading,
          textAlign: alignment == CrossAxisAlignment.center
              ? TextAlign.center
              : TextAlign.start,
          style: Theme.of(context).textTheme.headlineLarge,
        ).animate().fadeIn(duration: 500.ms, delay: 80.ms).slideY(begin: 0.08, end: 0),
        if (subheading != null) ...[
          const SizedBox(height: 12),
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 620),
            child: Text(
              subheading!,
              textAlign: alignment == CrossAxisAlignment.center
                  ? TextAlign.center
                  : TextAlign.start,
              style: Theme.of(context)
                  .textTheme
                  .bodyLarge
                  ?.copyWith(color: AppColors.textSecondary),
            ),
          ).animate().fadeIn(duration: 500.ms, delay: 160.ms),
        ],
      ],
    );
  }
}
