import 'package:books_discovery_app/features/anyalytics/models/anyalytics_model.dart';
import 'package:books_discovery_app/features/anyalytics/models/publishing_trend_model.dart';
import 'package:books_discovery_app/features/anyalytics/viewmodels/anyalytics_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class AnalyticsTab extends ConsumerStatefulWidget {
  const AnalyticsTab({super.key});

  @override
  ConsumerState<AnalyticsTab> createState() => _AnalyticsTabState();
}

class _AnalyticsTabState extends ConsumerState<AnalyticsTab> {
  @override
  Widget build(BuildContext context) {
    final state = ref.watch(analyticsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Analytics"),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => ref.read(analyticsProvider.notifier).refresh(),
          ),
        ],
      ),
      body: state.genreAnalytics.isEmpty
          ? const Center(
              child: Text(
                "No search history yet.\nStart searching to see analytics!",
                textAlign: TextAlign.center,
              ),
            )
          : RefreshIndicator(
              onRefresh: () => ref.read(analyticsProvider.notifier).refresh(),
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  SfCircularChart(
                    title: ChartTitle(text: "Catregories Distribution"),
                    legend: const Legend(
                      shouldAlwaysShowScrollbar: false,
                      itemPadding: 5,
                      isVisible: true,
                      position: LegendPosition.bottom,
                      orientation: LegendItemOrientation.vertical,
                      overflowMode: LegendItemOverflowMode.wrap,
                      alignment: ChartAlignment.near,
                      iconHeight: 12,
                      iconWidth: 12,
                    ),
                    series: <CircularSeries>[
                      DoughnutSeries<CategoriesAnyalyticsModel, String>(
                        dataSource: state.genreAnalytics,
                        xValueMapper: (CategoriesAnyalyticsModel ga, _) =>
                            ga.categories,
                        yValueMapper: (CategoriesAnyalyticsModel ga, _) =>
                            ga.count,
                        dataLabelMapper: (CategoriesAnyalyticsModel ga, _) =>
                            "${ga.categories} (${ga.count})",
                        dataLabelSettings: const DataLabelSettings(
                          isVisible: false,
                          labelPosition: ChartDataLabelPosition.outside,
                        ),
                        radius: "90%",

                        startAngle: 1,
                        cornerStyle: CornerStyle.bothFlat,
                        innerRadius: "60%",
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    height: 350,
                    child: SfCartesianChart(
                      primaryXAxis: CategoryAxis(
                        title: AxisTitle(text: "Year Range"),
                      ),
                      primaryYAxis: NumericAxis(
                        title: AxisTitle(text: "Books Count"),
                      ),
                      title: ChartTitle(text: "Publishing Trend"),
                      legend: Legend(
                        isVisible: true,
                        position: LegendPosition.bottom,
                      ),
                      tooltipBehavior: TooltipBehavior(enable: true),
                      series: <CartesianSeries>[
                        ColumnSeries<PublishingTrendModel, String>(
                          name: "Books",
                          dataSource: state.publishingTrend,
                          xValueMapper: (PublishingTrendModel data, _) =>
                              data.yearRange,
                          yValueMapper: (PublishingTrendModel data, _) =>
                              data.count,
                          dataLabelSettings: DataLabelSettings(isVisible: true),
                          borderRadius: BorderRadius.all(Radius.circular(5)),
                          spacing: 0.1,
                        ),
                        LineSeries<PublishingTrendModel, String>(
                          name: "Trend",
                          dataSource: state.publishingTrend,
                          xValueMapper: (PublishingTrendModel data, _) =>
                              data.yearRange,
                          yValueMapper: (PublishingTrendModel data, _) =>
                              data.count,
                          markerSettings: MarkerSettings(isVisible: true),
                          dataLabelSettings: DataLabelSettings(isVisible: true),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
    );
  }

 
}
