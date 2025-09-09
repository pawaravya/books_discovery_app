import 'dart:async';
import 'package:books_discovery_app/features/anyalytics/models/publishing_trend_model.dart';
import 'package:books_discovery_app/features/home/models/books_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:books_discovery_app/features/anyalytics/models/anyalytics_model.dart';
import 'package:books_discovery_app/features/anyalytics/models/anyalytics_screen_state.dart';
import 'package:books_discovery_app/shared/app_shared_preferences.dart';

final analyticsProvider =
    StateNotifierProvider<AnalyticsNotifier, AnalyticsState>((ref) {
      return AnalyticsNotifier();
    });

class AnalyticsNotifier extends StateNotifier<AnalyticsState> {
  AnalyticsNotifier() : super(AnalyticsState.empty());

  Future<void> generateGenreAnalytics() async {
    final allResults = await AppSharedPreferences.customSharedPreferences
        .getSearchQueryAndResults();

    final Map<String, int> genreCount = {};

    for (var entry in allResults.entries) {
      for (var book in entry.value) {
        final categories = book?.volumeInfo?.categories ?? [];
        if (categories.isEmpty) {
          // genreCount["NA"] = (genreCount["Unknown"] ?? 0) + 1;
        } else {
          for (final genre in categories) {
            final g = genre.trim();
            genreCount[g] = (genreCount[g] ?? 0) + 1;
          }
        }
      }
    }

    final analyticsData = genreCount.entries
        .map((e) => CategoriesAnyalyticsModel(e.key, e.value))
        .toList();
    state = state.copyWith(genreAnalytics: analyticsData);
  }

  /// Load data from shared preferences and compute publishing trend
  Future<void> loadPublishingTrend() async {
    final booksMap = await AppSharedPreferences.customSharedPreferences
        .getSearchQueryAndResults();

    // Flatten all books
    List<Book> allBooks = [];
    booksMap.values.forEach((bookList) => allBooks.addAll(bookList));

    final trend = _computePublishingTrend(allBooks);

    state = state.copyWith(publishingTrend: trend);
  }

  /// Compute publishing trend per year range (2-year ranges)
  List<PublishingTrendModel> _computePublishingTrend(List<Book> books) {
    if (books.isEmpty) return [];

    // Extract publication years
    List<int> years = books
        .map((b) {
          if (b.volumeInfo?.publishedDate  == null || b.volumeInfo!.publishedDate!.isEmpty) return 0;
          final match = RegExp(r'^\d{4}').firstMatch(b.volumeInfo!.publishedDate!);
          return match != null ? int.tryParse(match.group(0)!) ?? 0 : 0;
        })
        .where((y) => y > 0)
        .toList();

    if (years.isEmpty) return [];

    int minYear = years.reduce((a, b) => a < b ? a : b);
    int maxYear = years.reduce((a, b) => a > b ? a : b);

    // Generate 2-year ranges
    List<String> ranges = [];
    for (int y = minYear; y <= maxYear; y += 2) {
      int end = (y + 1 <= maxYear) ? y + 1 : y;
      ranges.add("$y-$end");
    }

    // Count books per range
    List<PublishingTrendModel> trend = ranges.map((range) {
      final parts = range.split('-');
      int start = int.parse(parts[0]);
      int end = int.parse(parts[1]);
      int count = years.where((y) => y >= start && y <= end).length;
      return PublishingTrendModel(yearRange: range, count: count);
    }).toList();

    return trend;
  }

  Future<void> refresh() async {
    generateGenreAnalytics() ;
    loadPublishingTrend();
  } 
}
