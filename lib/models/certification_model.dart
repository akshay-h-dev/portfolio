class Certification {
  final String title;
  final String provider;
  final String? verifyUrl; // link to the credential (e.g. NPTEL/Coursera cert page)

  const Certification({required this.title, required this.provider, this.verifyUrl});
}

class TimelineEntry {
  final String period; // e.g. "2023 – Present"
  final String title;
  final String? subtitle; // e.g. score/CGPA

  const TimelineEntry({
    required this.period,
    required this.title,
    this.subtitle,
  });
}
