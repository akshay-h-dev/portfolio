import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_theme.dart';
import '../../../models/certification_model.dart';
import '../../../repositories/portfolio_repository.dart';
import '../../../utils/responsive.dart';
import '../../../widgets/accent_button.dart';
import '../../../widgets/outline_card.dart';
import '../../../widgets/scroll_reveal.dart';
import '../../../widgets/section_title.dart';

class CertificationsSection extends ConsumerWidget {
  const CertificationsSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final certifications = ref.watch(certificationsProvider);
    final columns = Responsive.gridColumns(context);

    return certifications.when(
      loading: () => const Center(
        child: CircularProgressIndicator(),
      ),
      error: (e, _) => Center(
        child: Text(e.toString()),
      ),
      data: (certifications) {
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
                    index: '04',
                    eyebrow: 'experience & certifications',
                    heading: 'Certifications',
                  ),
                  const SizedBox(height: 40),
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: certifications.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: columns,
                      crossAxisSpacing: 20,
                      mainAxisSpacing: 20,
                      mainAxisExtent: 240,
                    ),
                    itemBuilder: (context, index) => ScrollReveal(
                      id: 'cert-$index',
                      child: _CertCard(
                        cert: certifications[index],
                      ),
                    ),
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

/// Its own widget (rather than inline in itemBuilder) so `context.accent`
/// is read from this widget's own BuildContext — the same pattern used by
/// every other card in the app (ProjectCard, skill category cards, ...) —
/// which is what guarantees it rebuilds when the footer's color changer
/// picks a new accent.
class _CertCard extends StatelessWidget {
  final Certification cert;
  const _CertCard({required this.cert});

  Future<void> _verify(BuildContext context) async {
    final url = cert.verifyUrl;
    if (url == null || url.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
              'Add this certificate\'s verification link in portfolio_repository.dart'),
        ),
      );
      return;
    }
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, webOnlyWindowName: '_blank');
    }
  }

  @override
  Widget build(BuildContext context) {
    final accent = context.accent;
    return OutlineCard(
      hoverLift: false,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.workspace_premium_rounded, color: accent, size: 28),
          const SizedBox(height: 12),
          Text(
            cert.title,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 6),
          Text(cert.provider, style: Theme.of(context).textTheme.labelLarge),
          const Spacer(),
          AccentButton(
            label: 'Verify',
            icon: const Icon(Icons.verified_rounded),
            style: AccentButtonStyle.outline,
            onPressed: () => _verify(context),
          ),
        ],
      ),
    );
  }
}
