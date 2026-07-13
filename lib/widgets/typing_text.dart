import 'dart:async';
import 'package:flutter/material.dart';
import '../core/theme/app_theme.dart';

/// Cycles through [words], typing then deleting each one, with a blinking
/// cursor, mimicking a terminal prompt (`Flutter Developer_`).
class TypingText extends StatefulWidget {
  final List<String> words;
  final TextStyle? style;
  final Duration typeSpeed;
  final Duration deleteSpeed;
  final Duration pauseAtFull;
  final Duration pauseAtEmpty;

  const TypingText({
    super.key,
    required this.words,
    this.style,
    this.typeSpeed = const Duration(milliseconds: 70),
    this.deleteSpeed = const Duration(milliseconds: 40),
    this.pauseAtFull = const Duration(milliseconds: 1400),
    this.pauseAtEmpty = const Duration(milliseconds: 400),
  });

  @override
  State<TypingText> createState() => _TypingTextState();
}

class _TypingTextState extends State<TypingText> {
  int _wordIndex = 0;
  int _charCount = 0;
  bool _deleting = false;
  Timer? _timer;
  bool _cursorVisible = true;
  Timer? _cursorTimer;

  @override
  void initState() {
    super.initState();
    _scheduleNext(widget.typeSpeed);
    _cursorTimer = Timer.periodic(const Duration(milliseconds: 500), (_) {
      if (mounted) setState(() => _cursorVisible = !_cursorVisible);
    });
  }

  void _scheduleNext(Duration delay) {
    _timer = Timer(delay, _tick);
  }

  void _tick() {
    if (!mounted) return;
    final currentWord = widget.words[_wordIndex];

    setState(() {
      if (!_deleting) {
        _charCount++;
        if (_charCount >= currentWord.length) {
          _deleting = true;
          _scheduleNext(widget.pauseAtFull);
          return;
        }
        _scheduleNext(widget.typeSpeed);
      } else {
        _charCount--;
        if (_charCount <= 0) {
          _deleting = false;
          _wordIndex = (_wordIndex + 1) % widget.words.length;
          _scheduleNext(widget.pauseAtEmpty);
          return;
        }
        _scheduleNext(widget.deleteSpeed);
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _cursorTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final word = widget.words[_wordIndex];
    final visible = word.substring(0, _charCount.clamp(0, word.length));
    final style = widget.style ?? Theme.of(context).textTheme.headlineMedium;

    return RichText(
      text: TextSpan(
        style: style,
        children: [
          TextSpan(text: visible),
          TextSpan(
            text: '_',
            style: style?.copyWith(
              color: context.accent.withValues(alpha: _cursorVisible ? 1 : 0),
              fontWeight: FontWeight.w300,
            ),
          ),
        ],
      ),
    );
  }
}
