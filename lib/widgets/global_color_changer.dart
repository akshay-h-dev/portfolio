import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/theme/app_colors.dart';
import '../state/accent_color_provider.dart';

/// Lives in the footer. Tapping a swatch writes straight to
/// [accentColorProvider], which main.dart watches to rebuild the app's
/// ThemeData — every hover outline, button, and accent label across the
/// whole site updates on the next frame, with no route change or reload.
class GlobalColorChanger extends ConsumerWidget {
  const GlobalColorChanger({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final current = ref.watch(accentColorProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          '// accent color',
          style: Theme.of(context).textTheme.labelMedium,
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          alignment: WrapAlignment.center,
          children: [
            for (final (name, color) in accentPresets)
              _Swatch(
                name: name,
                color: color,
                selected: color == current,
                onTap: () => ref.read(accentColorProvider.notifier).state = color,
              ),
          ],
        ),
      ],
    );
  }
}

class _Swatch extends StatefulWidget {
  final String name;
  final Color color;
  final bool selected;
  final VoidCallback onTap;

  const _Swatch({
    required this.name,
    required this.color,
    required this.selected,
    required this.onTap,
  });

  @override
  State<_Swatch> createState() => _SwatchState();
}

class _SwatchState extends State<_Swatch> {
  bool _hovering = false;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: widget.name,
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        onEnter: (_) => setState(() => _hovering = true),
        onExit: (_) => setState(() => _hovering = false),
        child: GestureDetector(
          onTap: widget.onTap,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            width: widget.selected ? 34 : 28,
            height: widget.selected ? 34 : 28,
            decoration: BoxDecoration(
              color: widget.color,
              shape: BoxShape.circle,
              border: Border.all(
                color: widget.selected || _hovering ? Colors.white : AppColors.outline,
                width: widget.selected ? 2.5 : 1.5,
              ),
              boxShadow: widget.selected
                  ? [BoxShadow(color: widget.color.withValues(alpha: 0.5), blurRadius: 12)]
                  : const [],
            ),
            child: widget.selected
                ? Icon(
                    Icons.check_rounded,
                    size: 16,
                    color: ThemeData.estimateBrightnessForColor(widget.color) == Brightness.dark
                        ? Colors.white
                        : Colors.black,
                  )
                : null,
          ),
        ),
      ),
    );
  }
}
