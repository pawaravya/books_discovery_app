import 'package:books_discovery_app/core/constants/color_constants.dart';
import 'package:books_discovery_app/features/anyalytics/models/anyalytics_model.dart';
import 'package:books_discovery_app/features/anyalytics/models/publishing_trend_model.dart';
import 'package:books_discovery_app/features/anyalytics/viewmodels/anyalytics_notifier.dart';
import 'package:books_discovery_app/features/authentication/models/user_model.dart';
import 'package:books_discovery_app/shared/app_shared_preferences.dart';
import 'package:books_discovery_app/shared/widgets/app_text.dart';
import 'package:books_discovery_app/shared/widgets/base_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class AnalyticsTab extends ConsumerStatefulWidget {
  const AnalyticsTab({super.key});

  @override
  ConsumerState<AnalyticsTab> createState() => _AnalyticsTabState();
}

class _AnalyticsTabState extends ConsumerState<AnalyticsTab>
    with WidgetsBindingObserver {
  UserModel? _user;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this); // 👈 add observer
    WidgetsBinding.instance.addPostFrameCallback((_) {
      fetchData();
    });
  }

  void _loadUser() async {
    final savedUser = await AppSharedPreferences.customSharedPreferences
        .getUser();
    if (savedUser != null) {
      setState(() {
        _user = savedUser;
      });
    }
  }

  Future<void> fetchData() async {
    await ref.read(analyticsProvider.notifier).refresh();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this); // 👈 remove observer

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(analyticsProvider);

    return BaseWidget(
      sidePadding: 0,
      screen: Stack(
        children: [
          Column(
            children: [
              Visibility(
                visible: state.genreAnalytics.isNotEmpty,
                child: Container(
                  height: 200,
                  width: double.infinity,
                  color: HexColor(ColorConstants.themeColor),
                ),
              ),
              Expanded(
                child: Container(
                  height: double.infinity,
                  width: double.infinity,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          state.genreAnalytics.isEmpty
              ? const Center(
                  child: Text(
                    "No search history yet.\nStart searching to see analytics!",
                    textAlign: TextAlign.center,
                  ),
                )
              : RefreshIndicator(
                  onRefresh: () =>
                      ref.read(analyticsProvider.notifier).refresh(),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 20, top: 30),
                          child: AppText(
                            "Hi, ${_user?.name ?? "User"}",
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.all(20),
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: HexColor("#CEECFE"),
                            borderRadius: BorderRadius.circular(25),
                          ),
                          child: SfCircularChart(
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
                                xValueMapper:
                                    (CategoriesAnyalyticsModel ga, _) =>
                                        ga.categories,
                                yValueMapper:
                                    (CategoriesAnyalyticsModel ga, _) =>
                                        ga.count,
                                dataLabelMapper:
                                    (CategoriesAnyalyticsModel ga, _) =>
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
                        ),
                        const SizedBox(height: 10),
                        Container(
                          height: 350,
                          padding: EdgeInsets.all(10),
                          margin: EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: HexColor("#CCCCCC"),
                              width: 1, // you can adjust the thickness
                            ),
                          ),
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
                                dataLabelSettings: DataLabelSettings(
                                  isVisible: true,
                                ),
                                borderRadius: BorderRadius.all(
                                  Radius.circular(5),
                                ),
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
                                dataLabelSettings: DataLabelSettings(
                                  isVisible: true,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
        ],
      ),
    );
  }
}
/*state.genreAnalytics.isEmpty
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
            ), */