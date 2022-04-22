class OTException implements Exception {
  OTException({
    required this.title,
    required this.text,
  });

  String title;
  String text;
}
