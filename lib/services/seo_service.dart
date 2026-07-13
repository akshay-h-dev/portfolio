import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'seo_service_stub.dart' if (dart.library.js_interop) 'seo_service_web.dart';
import '../config/seo_config.dart';

/// Call this from every route's `pageBuilder`/`initState` to keep the
/// document <title>/<meta description>/JSON-LD in sync with what's on
/// screen. See README > "SEO reality check" for the limits of what this
/// can achieve on a canvas-rendered Flutter Web build.
class SeoService {
  final SeoServiceImpl _impl = SeoServiceImpl();

  void applyRoute(RouteSeo seo, {String? canonicalPath}) {
    _impl.setTitle(seo.title);
    _impl.setDescription(seo.description);
    if (canonicalPath != null) {
      _impl.setCanonical('https://akshayh.dev$canonicalPath');
    }
  }

  void setJsonLd(String id, Map<String, dynamic> data) =>
      _impl.setJsonLd(id, data);

  void removeJsonLd(String id) => _impl.removeJsonLd(id);
}

final seoServiceProvider = Provider<SeoService>((ref) => SeoService());
