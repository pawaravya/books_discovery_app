class Appurl {
  static final String _BASEURL =
      "https://www.googleapis.com/books/v1/volumes?q=author";

  static String _getUrl(String endpoint) {
    return '$_BASEURL/$endpoint';
  }

  static String booksSerachApi = _BASEURL ;
}
