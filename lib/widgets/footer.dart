import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';
import '../utils/responsive.dart';
import 'global_color_changer.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

/// Footer intentionally contains nothing but the global color changer —
/// no nav links, no social icons — per the current design direction.
class SiteFooter extends StatelessWidget {
  const SiteFooter({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: Responsive.horizontalPadding(context),
        vertical: 48,
      ),
      decoration: const BoxDecoration(
        border: Border(top: BorderSide(color: AppColors.outlineSubtle)),
      ),
      child: const Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          GlobalColorChanger(),
          SizedBox(height: 16),
          Row(
            children: [
              Text(
                'Designed & Developed with Flutter ',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: AppColors.textSecondary, // Change if needed
                  fontWeight: FontWeight.w400,
                ),
              ),
              FaIcon(FontAwesomeIcons.flutter, color: Colors.blue,)
            ],
          ),
        ],
      ),
    );
  }
}
