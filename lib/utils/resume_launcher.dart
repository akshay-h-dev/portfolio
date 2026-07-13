import 'package:url_launcher/url_launcher.dart';
import '../core/constants/app_constants.dart';

/// Opens AppConstants.resumeUrl (a Google Drive share link) in a new tab.
/// Replace the placeholder in app_constants.dart with your real link —
/// make sure Drive sharing is set to "Anyone with the link can view".
Future<void> downloadResume() async {
  final uri = Uri.parse(AppConstants.resumeUrl);
  if (await canLaunchUrl(uri)) {
    await launchUrl(uri, webOnlyWindowName: '_blank');
  }
}
