
import 'package:books_discovery_app/features/home/models/books_model.dart';

class SearchHistoryItem {
  final String id;
  final String query;
  final DateTime timestamp;
  final List<Book> results;

  SearchHistoryItem({
    required this.id,
    required this.query,
    required this.timestamp,
    required this.results,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'query': query,
        'timestamp': timestamp.toIso8601String(),
        'results': results.map((b) => b.toJson()).toList(),
      };

  static SearchHistoryItem fromJson(Map<String, dynamic> json) {
    return SearchHistoryItem(
      id: json['id'] as String,
      query: json['query'] as String,
      timestamp: DateTime.parse(json['timestamp'] as String),
      results: (json['results'] as List<dynamic>)
          .map((e) => Book.fromJson(Map<String, dynamic>.from(e)))
          .toList(),
    );
  }
}
