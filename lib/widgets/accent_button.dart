import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';
import '../core/theme/app_theme.dart';

enum AccentButtonStyle { filled, outline }

/// Primary/outline CTA buttons (View Projects, Download Resume, ...).
/// `filled` uses a solid live-accent background with contrast-checked
/// text; `outline` is transparent with a white border that switches to
/// the accent on hover, matching OutlineCard's language.
class AccentButton extends StatefulWidget {
  final String? label;
  final Widget? icon; // CHANGED: Type changed from IconData? to Widget?
  final VoidCallback onPressed;
  final AccentButtonStyle style;

  const AccentButton({
    super.key,
    this.label,
    required this.onPressed,
    this.icon,
    this.style = AccentButtonStyle.filled,
  });

  @override
  State<AccentButton> createState() => _AccentButtonState();
}

class _AccentButtonState extends State<AccentButton> {
  bool _hovering = false;

  @override
  Widget build(BuildContext context) {
    final accent = context.accent;
    final filled = widget.style == AccentButtonStyle.filled;
    final labelColor =
        filled ? textColorOnAccent(accent) : AppColors.textPrimary;

    // Determine the icon color dynamically based on state
    final iconColor = filled ? labelColor : accent;

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovering = true),
      onExit: (_) => setState(() => _hovering = false),
      child: GestureDetector(
        onTap: widget.onPressed,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          curve: Curves.easeOut,
          transform: Matrix4.translationValues(0, _hovering ? -2 : 0, 0),
          padding: EdgeInsets.symmetric(horizontal: widget.label == null?10:26, vertical: 16),
          decoration: BoxDecoration(
            color: filled ? accent : Colors.transparent,
            border: filled
                ? null
                : Border.all(
                    color: _hovering ? accent : AppColors.outline,
                    width: 1.4,
                  ),
            borderRadius: BorderRadius.circular(14),
            boxShadow: filled && _hovering
                ? [
                    BoxShadow(
                      color: accent.withValues(alpha: 0.35),
                      blurRadius: 24,
                      offset: const Offset(0, 8),
                    ),
                  ]
                : const [],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (widget.icon != null) ...[
                // CHANGED: Wrap inside IconTheme to inject size and color dynamically
                // into either Icon or FaIcon children.
                IconTheme(
                  data: IconThemeData(size: 18, color: iconColor),
                  child: widget.icon!,
                ),
                const SizedBox(width: 10),
              ],
              if (widget.label != null)
                Text(
                  widget.label!,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: labelColor,
                        fontWeight: FontWeight.w600,
                        height: 1,
                      ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
