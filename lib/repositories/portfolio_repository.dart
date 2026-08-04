import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
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
        datasetUrl: e['datasetUrl'],
      );
    }).toList();
  }

  Future<List<SkillCategory>> getSkillCategories() async {
    // Skills are intentionally local so this core portfolio content remains
    // available even when the remote data source is unavailable. The projects,
    // education and certifications below continue to come from the JSON feed.
    return const [
      SkillCategory(
        title: 'Programming Languages',
        icon: Icons.code_rounded,
        skills: [
          Skill('Java', brandIcon: FontAwesomeIcons.java),
          Skill('Dart', brandIcon: FontAwesomeIcons.dartLang),
          Skill('Python', brandIcon: FontAwesomeIcons.python),
          Skill('Go', brandIcon: FontAwesomeIcons.golang),
        ],
      ),
      SkillCategory(
        title: 'Frontend',
        icon: Icons.web_rounded,
        skills: [
          Skill('React', brandIcon: FontAwesomeIcons.react),
          Skill('HTML', icon: Icons.language_rounded),
          Skill('CSS', icon: Icons.style_rounded),],
      ),
      SkillCategory(
        title: 'Backend',
        icon: Icons.dns_rounded,
        skills: [
          Skill('Flask', icon: Icons.dns_rounded),
          Skill('FastAPI', icon: Icons.dns_rounded),
          Skill('Firebase', brandIcon: FontAwesomeIcons.fire)
        ],
      ),
      SkillCategory(
        title: 'Mobile Development',
        icon: Icons.phone_android_rounded,
        skills: [
          Skill('Flutter', brandIcon: FontAwesomeIcons.flutter),
          Skill('Riverpod', icon: Icons.account_tree_rounded),
          Skill('Firebase', brandIcon: FontAwesomeIcons.fire),
        ],
      ),
      SkillCategory(
        title: 'Databases',
        icon: Icons.storage_rounded,
        skills: [
          Skill('MySQL', brandIcon: FontAwesomeIcons.database),
          Skill('MongoDB', brandIcon: FontAwesomeIcons.database),
          Skill('InfluxDB', brandIcon: FontAwesomeIcons.database),
          Skill('Supabase', brandIcon: FontAwesomeIcons.database),
        ],
      ),
      SkillCategory(
        title: 'Tools',
        icon: Icons.build_rounded,
        skills: [
          Skill('Git', brandIcon: FontAwesomeIcons.gitAlt),
          Skill('Linux', brandIcon: FontAwesomeIcons.linux),
          Skill('Docker', brandIcon: FontAwesomeIcons.docker),
        ],
      ),
    ];
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
