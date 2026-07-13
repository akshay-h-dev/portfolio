import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_theme.dart';
import '../../../utils/responsive.dart';
import '../../../widgets/outline_card.dart';
import '../../../widgets/scroll_reveal.dart';
import '../../../widgets/section_title.dart';
import '../../contact/contact_form.dart';

class ContactSection extends StatelessWidget {
  const ContactSection({super.key});

  Future<void> _open(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri))
      await launchUrl(uri, webOnlyWindowName: '_blank');
  }

  @override
  Widget build(BuildContext context) {
    final isDesktop = Responsive.isDesktop(context);

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: Responsive.horizontalPadding(context),
        vertical: 80,
      ),
      child: Center(
        child: ConstrainedBox(
          constraints:
              BoxConstraints(maxWidth: Responsive.maxContentWidth(context)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SectionTitle(
                index: '05',
                eyebrow: 'contact',
                heading: "Let's Build Something",
                subheading:
                    "Open to internships, full-time roles.",
              ),
              const SizedBox(height: 40),
              isDesktop
                  ? Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(flex: 4, child: _ContactInfo(onOpen: _open)),
                        const SizedBox(width: 32),
                        Expanded(
                          flex: 6,
                          child: ScrollReveal(
                            id: 'contact-form',
                            child: OutlineCard(
                                hoverLift: false, child: const ContactForm()),
                          ),
                        ),
                      ],
                    )
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _ContactInfo(onOpen: _open),
                        const SizedBox(height: 32),
                        ScrollReveal(
                          id: 'contact-form',
                          child: OutlineCard(
                              hoverLift: false, child: const ContactForm()),
                        ),
                      ],
                    ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ContactInfo extends StatelessWidget {
  final Future<void> Function(String) onOpen;
  const _ContactInfo({required this.onOpen});

  @override
  Widget build(BuildContext context) {
    return ScrollReveal(
      id: 'contact-info',
      child: OutlineCard(
        hoverLift: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _InfoTile(
              icon: const Icon(Icons.email_rounded),
              label: 'Email',
              value: AppConstants.email,
              onTap: () => onOpen(AppConstants.emailUrl),
            ),
            // const SizedBox(height: 20),
            // _InfoTile(
            //   icon: Icons.phone_rounded,
            //   label: 'Phone',
            //   value: AppConstants.phone,
            //   onTap: () => onOpen('tel:${AppConstants.phoneRaw}'),
            // ),
            const SizedBox(height: 20),
            _InfoTile(
              icon: const FaIcon(FontAwesomeIcons.github),
              label: 'GitHub',
              value: '@${AppConstants.githubUsername}',
              onTap: () => onOpen(AppConstants.githubUrl),
            ),
            const SizedBox(height: 20),
            _InfoTile(
              icon: const FaIcon(FontAwesomeIcons.linkedin),
              label: 'LinkedIn',
              value: '@${AppConstants.linkedinUsername}',
              onTap: () => onOpen(AppConstants.linkedinUrl),
            ),
            const SizedBox(height: 20),
            _InfoTile(
              icon: const FaIcon(FontAwesomeIcons.kaggle),
              label: 'Kaggle',
              value: '@${AppConstants.kaggleUsername}',
              onTap: () => onOpen(AppConstants.kaggleUrl),
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoTile extends StatefulWidget {
  final Widget icon;
  final String label;
  final String value;
  final VoidCallback onTap;

  const _InfoTile({
    required this.icon,
    required this.label,
    required this.value,
    required this.onTap,
  });

  @override
  State<_InfoTile> createState() => _InfoTileState();
}

class _InfoTileState extends State<_InfoTile> {
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
        child: Row(
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 150),
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: AppColors.background,
                borderRadius: BorderRadius.circular(12),
                border:
                    Border.all(color: _hovering ? accent : AppColors.outline),
              ),
              child: IconTheme(
                data: IconThemeData(size: 18, color: accent),
                child: widget.icon,
              ),
            ),
            const SizedBox(width: 14),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(widget.label,
                    style: Theme.of(context).textTheme.labelMedium),
                Text(
                  widget.value,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
