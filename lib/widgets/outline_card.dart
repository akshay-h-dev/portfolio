import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';
import '../core/theme/app_theme.dart';

/// The app's signature surface: solid black, no fill, just a white outline
/// that switches to the live global accent color on hover. Used for skill
/// cards, project cards, timeline entries, and the contact form so the
/// whole site reads as one cohesive material.
class OutlineCard extends StatefulWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  final BorderRadius borderRadius;
  final bool hoverLift;
  final VoidCallback? onTap;

  const OutlineCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(24),
    this.borderRadius = const BorderRadius.all(Radius.circular(20)),
    this.hoverLift = true,
    this.onTap,
  });

  @override
  State<OutlineCard> createState() => _OutlineCardState();
}

class _OutlineCardState extends State<OutlineCard> {
  bool _hovering = false;

  @override
  Widget build(BuildContext context) {
    final accent = context.accent;
    final borderColor = _hovering ? accent : AppColors.outline;

    final content = ClipRRect(
      borderRadius: widget.borderRadius,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOut,
        padding: widget.padding,
        decoration: BoxDecoration(
          color: AppColors.background,
          borderRadius: widget.borderRadius,
          border: Border.all(color: borderColor, width: _hovering ? 1.4 : 1),
          boxShadow: _hovering
              ? [
                  BoxShadow(
                    color: accent.withValues(alpha: 0.28),
                    blurRadius: 26,
                    offset: const Offset(0, 12),
                  ),
                ]
              : const [],
        ),
        child: widget.child,
      ),
    );

    final transformed = AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeOut,
      transform: Matrix4.translationValues(0, widget.hoverLift && _hovering ? -6 : 0, 0),
      child: content,
    );

    return MouseRegion(
      onEnter: (_) => setState(() => _hovering = true),
      onExit: (_) => setState(() => _hovering = false),
      cursor: widget.onTap != null ? SystemMouseCursors.click : MouseCursor.defer,
      child: GestureDetector(onTap: widget.onTap, child: transformed),
    );
  }
}
