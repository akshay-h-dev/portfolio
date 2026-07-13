import 'dart:convert';
import 'package:web/web.dart' as web;

/// Mutates the live document's <title>, <meta name="description">,
/// canonical <link>, and per-page JSON-LD <script> tags so every route
/// carries accurate metadata for crawlers/social unfurlers that inspect
/// the DOM after initial render, and for the browser tab itself.
///
/// Note: the static tags baked into web/index.html cover the very first
/// paint (before Flutter/JS has run); this service keeps them accurate as
/// the user navigates client-side between routes.
class SeoServiceImpl {
  void setTitle(String title) {
    web.document.title = title;
  }

  void setDescription(String description) {
    _upsertMeta('description', description);
  }

  void setCanonical(String url) {
    final existing =
        web.document.querySelector('link[rel="canonical"]') as web.HTMLLinkElement?;
    if (existing != null) {
      existing.href = url;
      return;
    }
    final link = web.document.createElement('link') as web.HTMLLinkElement;
    link.rel = 'canonical';
    link.href = url;
    web.document.head?.appendChild(link);
  }

  void setJsonLd(String id, Map<String, dynamic> data) {
    removeJsonLd(id);
    final script = web.document.createElement('script') as web.HTMLScriptElement;
    script.id = id;
    script.type = 'application/ld+json';
    script.text = jsonEncode(data);
    web.document.head?.appendChild(script);
  }

  void removeJsonLd(String id) {
    web.document.getElementById(id)?.remove();
  }

  void _upsertMeta(String name, String content) {
    final existing =
        web.document.querySelector('meta[name="$name"]') as web.HTMLMetaElement?;
    if (existing != null) {
      existing.content = content;
      return;
    }
    final meta = web.document.createElement('meta') as web.HTMLMetaElement;
    meta.name = name;
    meta.content = content;
    web.document.head?.appendChild(meta);
  }
}
