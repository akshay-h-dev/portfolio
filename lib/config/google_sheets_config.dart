class GoogleSheetsConfig {
  GoogleSheetsConfig._();

  // Publish the spreadsheet to the web and replace the placeholder ID.
  static const String spreadsheetId = '122GdX-pvLLRz9LkufhG-BDsMJkuEYyiJQTnvprdbAPw';

  static const String projectsSheet = 'projects';
  static const String educationSheet = 'education';
  static const String certificationsSheet = 'certifications';

  static Uri endpoint(String sheetName) {
    return Uri.https(
      'docs.google.com',
      '/spreadsheets/d/$spreadsheetId/gviz/tq',
      {
        'tqx': 'out:json',
        'sheet': sheetName,
        'headers': '1',
      },
    );
  }
}
