import 'package:books_discovery_app/features/anyalytics/models/anyalytics_model.dart';
import 'package:books_discovery_app/features/anyalytics/models/publishing_trend_model.dart';

class AnalyticsState {
  final List<CategoriesAnyalyticsModel> genreAnalytics;
  final List<PublishingTrendModel> publishingTrend;

  AnalyticsState({
    required this.genreAnalytics,
    required this.publishingTrend,
  });

  factory AnalyticsState.empty() => AnalyticsState(
        genreAnalytics: [],
        publishingTrend: [],
      );

  AnalyticsState copyWith({
    List<CategoriesAnyalyticsModel>? genreAnalytics,
    List<PublishingTrendModel>? publishingTrend,
  }) {
    return AnalyticsState(
      genreAnalytics: genreAnalytics ?? this.genreAnalytics,
      publishingTrend: publishingTrend ?? this.publishingTrend,
    );
  }
}
