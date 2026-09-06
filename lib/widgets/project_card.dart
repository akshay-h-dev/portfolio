import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../core/theme/app_colors.dart';
import '../core/theme/app_theme.dart';
import '../models/project_model.dart';
import 'outline_card.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ProjectCard extends StatelessWidget {
  final Project project;

  const ProjectCard({super.key, required this.project});

  Future<void> _open(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri))
      await launchUrl(uri, webOnlyWindowName: '_blank');
  }

  @override
  Widget build(BuildContext context) {
    return OutlineCard(
      hoverLift: false,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (project.imageAsset?.isNotEmpty ?? false) ...[
            _ProjectImage(url: project.imageAsset!, title: project.title),
          ],
          const SizedBox(height: 18),
          Text(
            project.title,
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 8),
          Text(
            project.description,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 14),
          Text(
            'CONTRIBUTION',
            style: Theme.of(context)
                .textTheme
                .labelMedium
                ?.copyWith(letterSpacing: 1),
          ),
          const SizedBox(height: 4),
          Text(
            project.contribution,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppColors.textPrimary, fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 14),
          for (final feature in project.features) _FeatureLine(feature),
          const SizedBox(height: 14),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final tech in project.technologies) _TechChip(tech)
            ],
          ),
          if ((project.githubUrl?.isNotEmpty ?? false) ||
              (project.liveDemoUrl?.isNotEmpty ?? false) ||
              (project.datasetUrl?.isNotEmpty ?? false)) ...[
            const SizedBox(height: 16),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: [
                if (project.githubUrl?.isNotEmpty ?? false)
                  _LinkButton(
                    icon: const FaIcon(FontAwesomeIcons.github),
                    label: 'View Code',
                    onTap: () => _open(project.githubUrl!),
                  ),
                if (project.liveDemoUrl?.isNotEmpty ?? false)
                  _LinkButton(
                    icon: const Icon(Icons.open_in_new_rounded),
                    label: 'Live Demo',
                    onTap: () => _open(project.liveDemoUrl!),
                  ),
                if (project.datasetUrl?.isNotEmpty ?? false)
                  _LinkButton(
                    icon: const Icon(Icons.dataset_outlined),
                    label: 'View Dataset',
                    onTap: () => _open(project.datasetUrl!),
                  ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

class _ProjectImage extends StatelessWidget {
  final String url;
  final String title;

  const _ProjectImage({required this.url, required this.title});

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 16 / 9,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Container(
          width: double.infinity,
          color: AppColors.backgroundSecondary,
          child: Image.network(
            url,
            width: double.infinity,
            fit: BoxFit.contain,
            semanticLabel: '$title project image',
            loadingBuilder: (context, child, progress) {
              if (progress == null) return child;
              return const Center(child: CircularProgressIndicator());
            },
            errorBuilder: (context, error, stackTrace) {
              return const Center(
                child: Icon(Icons.image_not_supported_outlined),
              );
            },
          ),
        ),
      ),
    );
  }
}

class _FeatureLine extends StatelessWidget {
  final String feature;
  const _FeatureLine(this.feature);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.check_rounded, size: 15, color: context.accent),
          const SizedBox(width: 8),
          Expanded(
              child:
                  Text(feature, style: Theme.of(context).textTheme.bodyMedium)),
        ],
      ),
    );
  }
}

class _TechChip extends StatelessWidget {
  final String label;
  const _TechChip(this.label);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.outline),
      ),
      child: Text(label, style: Theme.of(context).textTheme.labelMedium),
    );
  }
}

class _LinkButton extends StatefulWidget {
  final Widget icon;
  final String label;
  final VoidCallback onTap;
  const _LinkButton(
      {required this.icon, required this.label, required this.onTap});

  @override
  State<_LinkButton> createState() => _LinkButtonState();
}

class _LinkButtonState extends State<_LinkButton> {
  bool _hovering = false;

  @override
  Widget build(BuildContext context) {
    final accent = context.accent;
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovering = true),
      onExit: (_) => setState(() => _hovering = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: _hovering ? accent : AppColors.outline),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconTheme(
                data: IconThemeData(size: 14, color: accent),
                child: widget.icon,
              ),
              const SizedBox(width: 6),
              Text(widget.label,
                  style: Theme.of(context).textTheme.labelMedium),
            ],
          ),
        ),
      ),
    );
  }
}
