import 'package:flutter/material.dart';
import '../core/constants/app_constants.dart';
import '../core/theme/app_colors.dart';
import '../core/theme/app_theme.dart';
import '../utils/responsive.dart';
import 'accent_button.dart';

class NavItem {
  final String label;
  final VoidCallback onTap;

  const NavItem(this.label, this.onTap);
}

class NavBar extends StatelessWidget implements PreferredSizeWidget {
  final List<NavItem> items;
  final VoidCallback? onResumeTap;
  final VoidCallback? onLogoTap;

  const NavBar({super.key, required this.items, this.onResumeTap, this.onLogoTap});

  @override
  Size get preferredSize => const Size.fromHeight(76);

  @override
  Widget build(BuildContext context) {
    final isMobile = Responsive.isMobile(context) || Responsive.isTablet(context);

    return Container(
      height: preferredSize.height,
      padding: EdgeInsets.symmetric(
        horizontal: Responsive.horizontalPadding(context),
      ),
      decoration: const BoxDecoration(
        color: AppColors.background,
        border: Border(
          bottom: BorderSide(color: AppColors.outlineSubtle, width: 1),
        ),
      ),
      child: Row(
        children: [
          _Logo(onTap: onLogoTap ?? () {}),
          const Spacer(),
          if (!isMobile) ...[
            for (final item in items) _NavLink(item: item),
            const SizedBox(width: 12),
            AccentButton(
              label: 'Resume',
              onPressed: onResumeTap ?? () {},
            ),
          ] else
            Builder(
              builder: (context) => IconButton(
                icon: const Icon(Icons.menu_rounded, color: AppColors.textPrimary),
                onPressed: () => _openMobileMenu(context),
              ),
            ),
        ],
      ),
    );
  }

  void _openMobileMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        side: BorderSide(color: AppColors.outline),
      ),
      builder: (sheetContext) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.outline,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                const SizedBox(height: 20),
                for (final item in items)
                  ListTile(
                    title: Text(
                      item.label,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    onTap: () {
                      Navigator.of(sheetContext).pop();
                      item.onTap();
                    },
                  ),
                const SizedBox(height: 12),
                AccentButton(
                  label: 'Resume',
                  //icon: const Icon(Icons.download_rounded),
                  onPressed: () {
                    Navigator.of(sheetContext).pop();
                    onResumeTap?.call();
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _Logo extends StatelessWidget {
  final VoidCallback onTap;
  const _Logo({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: Row(
          children: [
            // Text(
            //   'AH',
            //   style: Theme.of(context).textTheme.headlineMedium?.copyWith(
            //         color: context.accent,
            //         fontWeight: FontWeight.w800,
            //       ),
            // ),
            const SizedBox(width: 10),
            if (!Responsive.isMobile(context))
              Text(
                AppConstants.name,
                style: Theme.of(context).textTheme.titleLarge,
              ),
          ],
        ),
      ),
    );
  }
}

class _NavLink extends StatefulWidget {
  final NavItem item;
  const _NavLink({required this.item});

  @override
  State<_NavLink> createState() => _NavLinkState();
}

class _NavLinkState extends State<_NavLink> {
  bool _hovering = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovering = true),
      onExit: (_) => setState(() => _hovering = false),
      child: GestureDetector(
        onTap: widget.item.onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14),
          child: AnimatedDefaultTextStyle(
            duration: const Duration(milliseconds: 150),
            style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                  color: _hovering ? context.accent : AppColors.textPrimary,
                  fontWeight: FontWeight.w500,
                ),
            child: Text(widget.item.label),
          ),
        ),
      ),
    );
  }
}
