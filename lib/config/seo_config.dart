/// SEO metadata for the single page. [SeoService] applies this to the
/// document <title> and <meta name="description"> on load, and HomePage
/// separately pushes per-project JSON-LD (see home_page.dart) so the
/// projects section still carries structured data now that each project
/// no longer has its own route.
class RouteSeo {
  final String title;
  final String description;

  const RouteSeo({required this.title, required this.description});
}

class SeoConfig {
  SeoConfig._();

  static const home = RouteSeo(
    title: 'Akshay H | Flutter Developer, Backend Developer',
    description:
        'Portfolio of Akshay H — Computer Science Engineering student building scalable '
        'Flutter apps, backend systems.',
  );
}
