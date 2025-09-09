class Appurl {
  static final String _BASEURL =
      "https://www.googleapis.com/books/v1/volumes?q=";

  static String _getUrl(String endpoint) {
    return '$_BASEURL$endpoint';
  }

  static String booksSerachApi = _getUrl("author:");
  static String booksTitleSearchApi = _getUrl("intitle:");
  static String booksIsbnSearchApi = _getUrl("isbn:");
}
