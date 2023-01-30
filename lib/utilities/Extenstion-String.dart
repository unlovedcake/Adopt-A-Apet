extension FancyNum on String {
  String trimWhiteSpace() {
    return replaceAll(" ", "");
  }

  bool isURLValid() {
    return Uri.parse(this).isAbsolute;
  }
}
