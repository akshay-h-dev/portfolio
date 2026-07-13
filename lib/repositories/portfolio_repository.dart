import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

import '../models/project_model.dart';
import '../models/skill_model.dart';
import '../models/certification_model.dart';

class PortfolioRepository {
  const PortfolioRepository();

  static const String _url =
      'https://raw.githubusercontent.com/akshay-h-dev/portfolio-data/refs/heads/main/portfolio.json';

  Future<Map<String, dynamic>> _loadData() async {
    final response = await http.get(Uri.parse(_url));

    if (response.statusCode != 200) {
      throw Exception('Failed to load portfolio data');
    }

    return jsonDecode(response.body);
  }

  Future<List<Project>> getProjects() async {
    final json = await _loadData();

    return (json['projects'] as List).map((e) {
      return Project(
        slug: e['slug'],
        title: e['title'],
        description: e['description'],
        contribution: e['contribution'],
        features: List<String>.from(e['features']),
        technologies: List<String>.from(e['technologies']),
        architecture: e['architecture'],
        githubUrl: e['githubUrl'],
        liveDemoUrl: e['liveDemoUrl'],
      );
    }).toList();
  }

  Future<List<SkillCategory>> getSkillCategories() async {
    final json = await _loadData();

    return (json['skillCategories'] as List).map((category) {
      return SkillCategory(
        title: category['title'],
        icon: _iconForCategory(category['title']),
        skills: (category['skills'] as List)
            .map(
              (skill) => Skill(
                skill['name'],
                proficiency: skill['proficiency'],
              ),
            )
            .toList(),
      );
    }).toList();
  }

  Future<List<TimelineEntry>> getEducationTimeline() async {
    final json = await _loadData();

    return (json['education'] as List)
        .map(
          (e) => TimelineEntry(
            period: e['period'],
            title: e['title'],
            subtitle: e['subtitle'],
          ),
        )
        .toList();
  }

  Future<List<Certification>> getCertifications() async {
    final json = await _loadData();

    return (json['certifications'] as List)
        .map(
          (e) => Certification(
            title: e['title'],
            provider: e['provider'],
            verifyUrl: e['verifyUrl'],
          ),
        )
        .toList();
  }

  IconData _iconForCategory(String title) {
    switch (title) {
      case 'Programming Languages':
        return Icons.code_rounded;
      case 'Technical':
        return Icons.dns_rounded;
      case 'Databases':
        return Icons.storage_rounded;
      case 'Tools':
        return Icons.build_rounded;
      case 'Core Concepts':
        return Icons.memory_rounded;
      case 'Languages':
        return Icons.translate_rounded;
      default:
        return Icons.star;
    }
  }
}
final portfolioRepositoryProvider =
    Provider<PortfolioRepository>((ref) => const PortfolioRepository());

final projectsProvider = FutureProvider<List<Project>>(
  (ref) => ref.watch(portfolioRepositoryProvider).getProjects(),
);

final skillCategoriesProvider = FutureProvider<List<SkillCategory>>(
  (ref) => ref.watch(portfolioRepositoryProvider).getSkillCategories(),
);

final educationTimelineProvider = FutureProvider<List<TimelineEntry>>(
  (ref) => ref.watch(portfolioRepositoryProvider).getEducationTimeline(),
);

final certificationsProvider = FutureProvider<List<Certification>>(
  (ref) => ref.watch(portfolioRepositoryProvider).getCertifications(),
);