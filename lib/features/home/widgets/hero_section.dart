import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_theme.dart';
import '../../../utils/responsive.dart';
import '../../../widgets/accent_button.dart';
import '../../../widgets/typing_text.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class HeroSection extends StatelessWidget {
  final VoidCallback onViewProjects;
  final VoidCallback onDownloadResume;
  final VoidCallback onContactMe;

  const HeroSection({
    super.key,
    required this.onViewProjects,
    required this.onDownloadResume,
    required this.onContactMe,
  });

  @override
  Widget build(BuildContext context) {
    final isDesktop = Responsive.isDesktop(context);

    return Container(
      width: double.infinity,
      constraints: const BoxConstraints(minHeight: 720),
      padding: EdgeInsets.symmetric(
        horizontal: Responsive.horizontalPadding(context),
        vertical: 64,
      ),
      color: AppColors.background,
      child: Center(
        child: ConstrainedBox(
          constraints:
              BoxConstraints(maxWidth: Responsive.maxContentWidth(context)),
          child: isDesktop
              ? Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                        flex: 6,
                        child: _HeroText(
                          onViewProjects: onViewProjects,
                          onDownloadResume: onDownloadResume,
                          onContactMe: onContactMe,
                        )),
                    const SizedBox(width: 48),
                    const Expanded(flex: 5, child: _HeroVisual()),
                  ],
                )
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _HeroText(
                      onViewProjects: onViewProjects,
                      onDownloadResume: onDownloadResume,
                      onContactMe: onContactMe,
                    ),
                    const SizedBox(height: 48),
                    // Leave enough vertical room for the availability label
                    // above the avatar on narrow screens.
                    const SizedBox(height: 320, child: _HeroVisual()),
                  ],
                ),
        ),
      ),
    );
  }
}

class _HeroText extends StatelessWidget {
  final VoidCallback onViewProjects;
  final VoidCallback onDownloadResume;
  final VoidCallback onContactMe;

  const _HeroText({
    required this.onViewProjects,
    required this.onDownloadResume,
    required this.onContactMe,
  });

  @override
  Widget build(BuildContext context) {
    final isMobile = Responsive.isMobile(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '// hello, I\'m',
          style: Theme.of(context).textTheme.labelLarge,
        ).animate().fadeIn(duration: 400.ms),
        const SizedBox(height: 14),
        Text(
          AppConstants.name,
          style: (isMobile
                  ? Theme.of(context).textTheme.displayMedium
                  : Theme.of(context).textTheme.displayLarge)
              ?.copyWith(color: context.accent),
        )
            .animate()
            .fadeIn(duration: 500.ms, delay: 100.ms)
            .slideY(begin: 0.15, end: 0),
        const SizedBox(height: 16),
        TypingText(
          words: AppConstants.rolesForTyping,
          style: AppTheme.monoFont.copyWith(
            fontSize: Theme.of(context).textTheme.headlineMedium?.fontSize,
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w500,
          ),
        ).animate().fadeIn(duration: 500.ms, delay: 220.ms),
        const SizedBox(height: 24),
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 560),
          child: Text(
            AppConstants.heroIntro,
            style: Theme.of(context).textTheme.bodyLarge,
          ),
        ).animate().fadeIn(duration: 500.ms, delay: 320.ms),
        const SizedBox(height: 36),
        Wrap(
          spacing: 16,
          runSpacing: 16,
          children: [
            AccentButton(
              label: 'View Projects',
              onPressed: onViewProjects,
              style: AccentButtonStyle.outline,
            ),
            AccentButton(
              label: 'Resume',
              //icon: Icons.download_rounded,
              //style: AccentButtonStyle.outline,
              onPressed: onDownloadResume,
            ),
            AccentButton(
              label: 'LinkedIn',
              icon: const FaIcon(FontAwesomeIcons.linkedin),
              style: AccentButtonStyle.outline,
              onPressed: () async {
                final uri = Uri.parse(AppConstants.linkedinUrl);
                if (await canLaunchUrl(uri)) {
                  await launchUrl(uri, webOnlyWindowName: '_blank');
                }
              },
            ),
            AccentButton(
              label: 'GitHub',
              icon: const FaIcon(FontAwesomeIcons.github),
              style: AccentButtonStyle.outline,
              onPressed: () async {
                final uri = Uri.parse(AppConstants.githubUrl);
                if (await canLaunchUrl(uri)) {
                  await launchUrl(uri, webOnlyWindowName: '_blank');
                }
              },
            ),
          ],
        ).animate().fadeIn(duration: 500.ms, delay: 420.ms),
      ],
    );
  }
}

class _HeroVisual extends StatelessWidget {
  const _HeroVisual();

  @override
  Widget build(BuildContext context) {
    final accent = context.accent;
    final isMobile = Responsive.isMobile(context);
    final avatarSize = isMobile ? 220.0 : 260.0;

    return SizedBox(
      height: isMobile ? 320 : 380,
      child: Stack(
        fit: StackFit.expand,
        children: [
          Align(
            // Anchor the mobile avatar to the bottom. This reserves a
            // dedicated row for the status label instead of letting it share
            // the avatar's space.
            alignment: isMobile ? Alignment.bottomCenter : Alignment.center,
            child: Padding(
                padding: EdgeInsets.only(bottom: isMobile ? 16 : 0),
                child: Container(
                  width: avatarSize,
                  height: avatarSize,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.background,
                    border: Border.all(color: accent, width: 3),
                    boxShadow: [
                      BoxShadow(
                        color: accent.withValues(alpha: 0.35),
                        blurRadius: 80,
                        spreadRadius: 10,
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(6),
                    child: ClipOval(
                      child: Image.asset(
                        'assets/images/profile.jpg',
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                )
                // .animate(
                //     onPlay: (controller) => controller.repeat(reverse: true))
                // .scale(
                //   begin: const Offset(1, 1),
                //   end: const Offset(1.05, 1.05),
                //   duration: 2600.ms,
                //   curve: Curves.easeInOut,
                // ),
                ),
          ),
          Align(
            alignment: Alignment.topCenter,
            child: Padding(
              padding: EdgeInsets.only(top: isMobile ? 8 : 15),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.circle, color: accent, size: 8),
                  const SizedBox(width: 8),
                  Text(
                    'OPEN TO WORK',
                    style: Theme.of(context).textTheme.labelMedium?.copyWith(
                          color: AppColors.textSecondary,
                          letterSpacing: 1.4,
                        ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
