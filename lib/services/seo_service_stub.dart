/// No-op implementation used when compiled for non-web platforms
/// (e.g. running `flutter test`, or a future mobile build sharing this code).
class SeoServiceImpl {
  void setTitle(String title) {}
  void setDescription(String description) {}
  void setCanonical(String url) {}
  void setJsonLd(String id, Map<String, dynamic> data) {}
  void removeJsonLd(String id) {}
}
