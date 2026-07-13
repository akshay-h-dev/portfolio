import 'package:flutter/material.dart';

class Skill {
  final String name;
  final int proficiency; // 0-100, drives the animated progress indicator

  const Skill(this.name, {this.proficiency = 80});
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
