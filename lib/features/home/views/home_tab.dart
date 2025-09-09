// features/home/views/home_tab.dart
import 'package:books_discovery_app/core/constants/color_constants.dart';
import 'package:books_discovery_app/core/constants/image_constants.dart';
import 'package:books_discovery_app/core/constants/string_constants.dart';
import 'package:books_discovery_app/features/home/models/books_model.dart';
import 'package:books_discovery_app/features/home/viewmodels/home_notifier.dart';
import 'package:books_discovery_app/shared/widgets/app_loade.dart';
import 'package:books_discovery_app/shared/widgets/app_text.dart';
import 'package:books_discovery_app/shared/widgets/app_view_utils.dart';
import 'package:books_discovery_app/shared/widgets/base_widget.dart';
import 'package:books_discovery_app/shared/widgets/common_empty_state.dart';
import 'package:books_discovery_app/shared/widgets/custom_input_text.dart';
import 'package:books_discovery_app/shared/widgets/network_image_with_placeholder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hexcolor/hexcolor.dart';

class HomeTab extends ConsumerStatefulWidget {
  const HomeTab({super.key});

  @override
  ConsumerState<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends ConsumerState<HomeTab> {
  final ScrollController _scrollController = ScrollController();
  TextEditingController searchEditingController = TextEditingController();
  String searchText = '';
  String scannarValue = '';
  final FocusNode searchFocusNode = FocusNode();
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchBooks(reset: true);
    });

    _scrollController.addListener(() {
      final notifier = ref.read(homeScreenProvider.notifier);
      final state = ref.read(homeScreenProvider);
      if (_scrollController.position.pixels >=
              _scrollController.position.maxScrollExtent - 200 &&
          !state.isLoadingMore &&
          notifier.hasMoreData) {
        _fetchBooks(reset: false);
      }
    });
  }

  Future<void> _fetchBooks({bool reset = false}) async {
    if (reset) {
      ref.read(homeScreenProvider.notifier).resetPagination();
    }
    await ref
        .read(homeScreenProvider.notifier)
        .fetchBooks(context, query: searchText, scannerSearch: scannarValue);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final homeState = ref.watch(homeScreenProvider);

    return BaseWidget(
      screen: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 20),
          AppText(
            "Books",
            fontSize: 24,
            fontWeight: FontWeight.w700,
            color: HexColor(ColorConstants.blackShade1),
          ),
          SizedBox(height: 10),
          CustomInputText(
            prefixIconPath: ImageConstants.searchIcon,
            isPrefixIcon: true,
            textEditingController: searchEditingController,
            labelText: "",
            hintText: "Search books",
            isSecure: false,
            suffixIconPath: ImageConstants.filterIcon,
            isSuffixIcon: true,
            isForSearch: true,
            focusNode: searchFocusNode,
            onEditingComplete: () async {
              searchText = searchEditingController.text;
              searchFocusNode.unfocus();
              await _fetchBooks(reset: true);
            },
          ),
          InkWell(
            onTap: () async {
              var result = await Navigator.of(
                context,
              ).pushNamed('/home/scanner_screen');

              if (result is String && result != "") {
                searchText = "";
                searchEditingController.text = "";
                scannarValue = result;
                _fetchBooks(reset: true);
              }
            },
            child: Padding(
              padding: const EdgeInsets.only(top: 10.0, bottom: 10),
              child: AppText("Click here to search with Qr code or bar code ?"),
            ),
          ),

          Expanded(
            child: RefreshIndicator(
              color: HexColor(ColorConstants.themeColor),
              onRefresh: () => _fetchBooks(reset: true),
              child: homeState.isLoading
                  ? ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 2.0),
                      itemCount: 6, // number of shimmer items you want
                      itemBuilder: (_, __) => buildShimmerListItem(),
                    )
                  : homeState.error != null
                  ? CommonEmptyState(
                      buttonText: "RETRY",
                      isBackButtonRequired: false,
                      stateScreenSubHeading: "",
                      stateScreenHeading:
                          StringConstants.somethingWentWrongMessage,
                      stateScreenEmoji: ImageConstants.somethingWentWrongLotie,
                      onTapButton: () => _fetchBooks(reset: true),
                    )
                  : homeState.books.isEmpty
                  ? CommonEmptyState(
                      buttonText: "RETRY",
                      isBackButtonRequired: false,
                      stateScreenSubHeading: searchText != ""
                          ? "Try searching with a different keyword."
                          : "There are currently no books to display.",
                      stateScreenHeading: "No books available",
                      stateScreenEmoji: "",
                      onTapButton: () => _fetchBooks(reset: true),
                    )
                  : ListView.builder(
                      controller: _scrollController,
                      padding: const EdgeInsets.symmetric(horizontal: 2.0),
                      itemCount:
                          homeState.books.length +
                          (homeState.isLoadingMore ? 1 : 0),
                      itemBuilder: (context, index) {
                        if (index < homeState.books.length) {
                          final Book book = homeState.books[index];
                          final String title =
                              book.volumeInfo?.title?.trim() ?? 'NA';
                          final List<String>? authors =
                              book.volumeInfo?.authors;
                          final String authorsText =
                              authors != null && authors.isNotEmpty
                              ? authors.join(', ')
                              : 'NA'.trim();
                          final String? imageUrl =
                              book.volumeInfo?.imageLinks?.thumbnail;

                          return Container(
                            margin: const EdgeInsets.only(bottom: 16.0),
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: HexColor(ColorConstants.whiteColor),
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.2),
                                  blurRadius: 6,
                                  offset: const Offset(0, 3),
                                ),
                              ],
                            ),
                            child: InkWell(
                              onTap: () {
                                Navigator.of(context).pushNamed(
                                  '/home/book_details',
                                  arguments: book,
                                );
                              },
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(4.0),
                                    child: NetworkImageWithPlaceholder(
                                      imageUrl: imageUrl ?? "",
                                      placeholderAsset: "",
                                      height: 82,
                                      width: 72,
                                      boxfit: BoxFit.cover,
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: SizedBox(
                                      height: 82,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          AppText(
                                            title,
                                            maxLines: 2,
                                            textAlign: TextAlign.start,
                                          ),
                                          const SizedBox(height: 10),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              AppViewUtils.getAssetImageSVG(
                                                ImageConstants.authorDymmyImage,
                                              ),
                                              SizedBox(width: 4),
                                              Expanded(
                                                child: AppText(
                                                  textAlign: TextAlign.start,
                                                  authorsText,
                                                  maxLines: 1,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        } else {
                          // Bottom loader
                          return Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Center(child: AppLoader.loaderWidget()),
                          );
                        }
                      },
                    ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildShimmerListItem() {
    return Container(
      margin: const EdgeInsets.only(bottom: 16.0),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Book Thumbnail
          AppViewUtils.buildShimmerContainer(
            height: 82,
            width: 72,
            borderRadius: 6,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: SizedBox(
              height: 82,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  AppViewUtils.buildShimmerContainer(
                    height: 14,
                    width: double.infinity,
                  ),
                  AppViewUtils.buildShimmerContainer(height: 14, width: 150),
                  Row(
                    children: [
                      AppViewUtils.buildShimmerContainer(
                        height: 20,
                        width: 20,
                        borderRadius: 10,
                      ),
                      const SizedBox(width: 6),
                      Expanded(
                        child: AppViewUtils.buildShimmerContainer(
                          height: 14,
                          width: double.infinity,
                        ),
                      ),
                    ],
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
