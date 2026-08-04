import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Skill {
  final String name;
  final IconData? icon;
  final FaIconData? brandIcon;

  const Skill(this.name, {this.icon, this.brandIcon})
      : assert(icon != null || brandIcon != null);
}

class SkillCategory {
  final String title;
  final IconData icon;
  final List<Skill> skills;

  const SkillCategory({
    required this.title,
    required this.icon,
    required this.skills,
  });
}
