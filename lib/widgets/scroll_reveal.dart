import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:visibility_detector/visibility_detector.dart';

/// Wrap any section widget with this to get a one-time fade + slide-up
/// reveal the first time it scrolls into view. Uses VisibilityDetector
/// (cheap, no scroll-listener boilerplate per section) and only plays once
/// per widget instance to avoid re-triggering on scroll-back.
class ScrollReveal extends StatefulWidget {
  final Widget child;
  final String id; // must be unique per section on the page
  final double visibleThreshold;

  const ScrollReveal({
    super.key,
    required this.child,
    required this.id,
    this.visibleThreshold = 0.15,
  });

  @override
  State<ScrollReveal> createState() => _ScrollRevealState();
}

class _ScrollRevealState extends State<ScrollReveal> {
  bool _revealed = false;

  @override
  Widget build(BuildContext context) {
    return VisibilityDetector(
      key: Key('scroll-reveal-${widget.id}'),
      onVisibilityChanged: (info) {
        if (!_revealed && info.visibleFraction >= widget.visibleThreshold) {
          setState(() => _revealed = true);
        }
      },
      child: _revealed
          ? widget.child
              .animate()
              .fadeIn(duration: 550.ms, curve: Curves.easeOut)
              .slideY(begin: 0.08, end: 0, duration: 550.ms, curve: Curves.easeOut)
          : Opacity(opacity: 0, child: widget.child),
    );
  }
}
