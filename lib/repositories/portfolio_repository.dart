import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;

import '../config/google_sheets_config.dart';
import '../models/project_model.dart';
import '../models/skill_model.dart';
import '../models/certification_model.dart';

class PortfolioRepository {
  const PortfolioRepository();

  Future<List<Map<String, String>>> _loadRows(String sheetName) async {
    final response = await http.get(GoogleSheetsConfig.endpoint(sheetName));

    if (response.statusCode != 200) {
      throw Exception(
        'Unable to load portfolio data from Google Sheets '
        '(HTTP ${response.statusCode}).',
      );
    }

    final body = response.body;
    final jsonStart = body.indexOf('{');
    final jsonEnd = body.lastIndexOf('}');
    if (jsonStart == -1 || jsonEnd <= jsonStart) {
      throw const FormatException(
          'Google Sheets returned an invalid response.');
    }

    final payload = jsonDecode(body.substring(jsonStart, jsonEnd + 1));
    final table = payload['table'];
    if (table is! Map<String, dynamic> || table['cols'] is! List) {
      throw const FormatException('Google Sheets response has no table data.');
    }

    final headers = (table['cols'] as List)
        .map((column) => _normalise(column['label']?.toString() ?? ''))
        .toList();
    final rows = table['rows'];
    if (rows is! List) return const [];

    return rows.map((row) {
      final cells = row['c'] as List? ?? const [];
      return <String, String>{
        for (var index = 0; index < headers.length; index++)
          if (headers[index].isNotEmpty)
            headers[index]: _cellValue(cells, index),
      };
    }).toList();
  }

  Future<List<Project>> getProjects() async {
    final rows = await _loadRows(GoogleSheetsConfig.projectsSheet);

    return rows.map((row) {
      return Project(
        slug: _required(row, 'slug'),
        title: _required(row, 'title'),
        description: _required(row, 'description'),
        contribution: _required(row, 'contribution'),
        features: _list(row['features']),
        technologies: _list(row['technologies']),
        architecture: _required(row, 'architecture'),
        imageAsset: _optional(row, 'imageAsset') ?? _optional(row, 'imageUrl'),
        githubUrl: _optional(row, 'githubUrl'),
        liveDemoUrl:
            _optional(row, 'liveDemoUrl') ?? _optional(row, 'videoUrl'),
        datasetUrl: _optional(row, 'datasetUrl'),
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
          Skill('CSS', icon: Icons.style_rounded),
        ],
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
    final rows = await _loadRows(GoogleSheetsConfig.educationSheet);

    return rows
        .map(
          (row) => TimelineEntry(
            period: _required(row, 'period'),
            title: _required(row, 'title'),
            subtitle: _optional(row, 'subtitle'),
          ),
        )
        .toList();
  }

  Future<List<Certification>> getCertifications() async {
    final rows = await _loadRows(GoogleSheetsConfig.certificationsSheet);

    return rows
        .map(
          (row) => Certification(
            title: _required(row, 'title'),
            provider: _required(row, 'provider'),
            verifyUrl: _optional(row, 'verifyUrl'),
          ),
        )
        .toList();
  }

  static String _normalise(String value) =>
      value.trim().toLowerCase().replaceAll(RegExp(r'[^a-z0-9]+'), '');

  static String _cellValue(List<dynamic> cells, int index) {
    if (index >= cells.length || cells[index] == null) return '';
    final value = cells[index]['v'];
    return value?.toString().trim() ?? '';
  }

  static String _required(Map<String, String> row, String field) {
    final value = _optional(row, field);
    if (value == null) {
      throw FormatException('Google Sheets row is missing "$field".');
    }
    return value;
  }

  static String? _optional(Map<String, String> row, String field) {
    final value = row[_normalise(field)]?.trim();
    return value == null || value.isEmpty ? null : value;
  }

  static List<String> _list(String? value) {
    if (value == null || value.trim().isEmpty) return const [];
    final trimmed = value.trim();
    if (trimmed.startsWith('[') && trimmed.endsWith(']')) {
      final decoded = jsonDecode(trimmed);
      if (decoded is List) {
        return decoded
            .map((item) => item.toString().trim())
            .where((item) => item.isNotEmpty)
            .toList();
      }
    }
    return trimmed
        .split(RegExp(r'\s*[|\n]\s*|\s*,\s*'))
        .map((item) => item.trim())
        .where((item) => item.isNotEmpty)
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
