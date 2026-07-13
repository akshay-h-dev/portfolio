class Project {
  final String slug; // stable id, used for JSON-LD keys and list rendering
  final String title;
  final String description;
  final String contribution;
  final List<String> features;
  final List<String> technologies;
  final String architecture;
  final String? imageAsset;
  final String? githubUrl;
  final String? liveDemoUrl;

  const Project({
    required this.slug,
    required this.title,
    required this.description,
    required this.contribution,
    required this.features,
    required this.technologies,
    required this.architecture,
    this.imageAsset,
    this.githubUrl,
    this.liveDemoUrl,
  });

  /// Minimal Project structured-data map (schema.org CreativeWork), injected
  /// as JSON-LD directly on the single home page by HomePage (see
  /// home_page.dart) since projects no longer have their own routes.
  Map<String, dynamic> toSchemaOrgJson() => {
        '@context': 'https://schema.org',
        '@type': 'CreativeWork',
        'name': title,
        'description': description,
        'creator': {'@type': 'Person', 'name': 'Akshay H'},
        'keywords': technologies.join(', '),
        if (githubUrl != null) 'codeRepository': githubUrl,
        if (liveDemoUrl != null) 'url': liveDemoUrl,
      };
}
