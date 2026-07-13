/// Site-wide constants. Single source of truth for personal/contact info
/// so it's never hardcoded twice across widgets.
class AppConstants {
  AppConstants._();

  static const String siteUrl = 'https://akshayh.dev';

  static const String name = 'Akshay H';
  static const String role =
      'Flutter App Developer | Backend Developer';
  static const String tagline =
      'Building scalable mobile applications, backend systems, and intelligent solutions through modern technologies.';
  static const String heroIntro =
      'Passionate Computer Science Engineering student focused on developing '
      'scalable mobile applications, backend systems, and innovative software solutions.';

  static const List<String> rolesForTyping = [
    'Flutter Developer',
    'Backend Developer',
  ];

  static const String aboutMe =
      'Dedicated Computer Science Engineering student with a passion for building '
      'innovative solutions and continuously improving software development skills.';

  // Contact
  static const String email = 'akshay.h.achar@gmail.com';
  static const String githubUsername = 'akshay-h-dev';
  static const String linkedinUsername = 'akshay-h-info';
  static const String githubUrl = 'https://github.com/akshay-h-dev';
  static const String linkedinUrl = 'https://linkedin.com/in/akshay-h-info';
  static const String emailUrl = 'mailto:akshay.h.achar@gmail.com';
  static const String kaggleUsername = 'akshayhdev';
  static const String kaggleUrl = 'https://www.kaggle.com/akshayhdev';
  // TODO(akshay): replace with your real Google Drive share link — must be
  // set to "Anyone with the link can view" or visitors will hit a
  // permission-denied screen. The Download Resume button opens this
  // directly in a new tab.
  static const String resumeUrl =
      'https://drive.google.com/file/d/1bPJHd8E_uQsoy93pmneibFBxBsWgb1Hk/view?usp=sharing';

  // Education
  static const String degree = 'Bachelor of Engineering, Computer Science Engineering';
  static const String institution = 'St Joseph Engineering College';
  static const String cgpa = '8.65';

  // Responsive breakpoints
  static const double mobileBreakpoint = 600;
  static const double tabletBreakpoint = 1024;
  static const double desktopBreakpoint = 1440;
}
