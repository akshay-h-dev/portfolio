import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// The single global accent color. Every hover outline, button, link, and
/// accent-tinted label reads this indirectly via `Theme.of(context)
/// .colorScheme.secondary` (see `context.accent` in app_theme.dart), so
/// changing it here updates the whole app instantly — no navigation, no
/// page reload, no per-widget listeners required.
final accentColorProvider = StateProvider<Color>((ref) => const Color(0xFFFFFFFF));

/// Quick-pick swatches shown in the footer's GlobalColorChanger.
const List<(String, Color)> accentPresets = [
  ('Cyan', Color(0xFF35E7E0)), // default
  ('Purple', Color(0xFF7C6CFF)),
  ('Blue', Color(0xFF4C6FFF)),
  ('Green', Color(0xFF3DDC97)),
  ('Amber', Color(0xFFFFC048)),
  ('Red', Color(0xFFFF6B6B)),
  ('Pink', Color(0xFFFF7CD9)),
  ('White', Color(0xFFFFFFFF)),
];
