// features/home/views/home_tab.dart
import 'package:books_discovery_app/core/constants/image_constants.dart';
import 'package:books_discovery_app/core/constants/string_constants.dart';
import 'package:books_discovery_app/features/home/models/books_model.dart';
import 'package:books_discovery_app/features/home/viewmodels/home_notifier.dart';
import 'package:books_discovery_app/shared/widgets/app_loade.dart';
import 'package:books_discovery_app/shared/widgets/app_text.dart';
import 'package:books_discovery_app/shared/widgets/base_widget.dart';
import 'package:books_discovery_app/shared/widgets/common_empty_state.dart';
import 'package:books_discovery_app/shared/widgets/custom_input_text.dart';
import 'package:books_discovery_app/shared/widgets/network_image_with_placeholder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
        .fetchBooks(context, query: searchText ,scannerSearch: scannarValue );
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
        children: [
          CustomInputText(
            textEditingController: searchEditingController,
            labelText: "",
            hintText: "Search books",
            isSecure: false,
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
            child: AppText("Try searching with Qr code ?"),
          ),

          Expanded(
            child: RefreshIndicator(
              onRefresh: () => _fetchBooks(reset: true),
              child: homeState.isLoading
                  ? AppLoader.loaderWidget()
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
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      itemCount:
                          homeState.books.length +
                          (homeState.isLoadingMore ? 1 : 0),
                      itemBuilder: (context, index) {
                        if (index < homeState.books.length) {
                          final Book book = homeState.books[index];
                          final String title =
                              book.volumeInfo?.title ?? 'Unknown Title';
                          final List<String>? authors =
                              book.volumeInfo?.authors;
                          final String authorsText =
                              authors != null && authors.isNotEmpty
                              ? authors.join(', ')
                              : 'Unknown Author';
                          final String? imageUrl =
                              book.volumeInfo?.imageLinks?.thumbnail;

                          return Card(
                            margin: const EdgeInsets.only(bottom: 12.0),
                            child: ListTile(
                              leading: ClipRRect(
                                borderRadius: BorderRadius.circular(4.0),
                                child: NetworkImageWithPlaceholder(
                                  imageUrl: imageUrl ?? "",
                                  placeholderAsset: "",
                                  height: 70,
                                  width: 50,
                                  boxfit: BoxFit.cover,
                                ),
                              ),
                              title: AppText(title, maxLines: 20),
                              subtitle: AppText(
                                "Authors :" + authorsText,
                                maxLines: 20,
                              ),
                              onTap: () {
                                Navigator.of(context).pushNamed(
                                  '/home/book_details',
                                  arguments: book,
                                );
                              },
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
}
