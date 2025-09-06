// features/home/views/home_tab.dart
import 'package:books_discovery_app/core/constants/string_constants.dart';
import 'package:books_discovery_app/features/home/models/books_model.dart';
import 'package:books_discovery_app/features/home/models/home_screen_state.dart';
import 'package:books_discovery_app/features/home/viewmodels/home_notifier.dart';
import 'package:books_discovery_app/shared/widgets/app_loade.dart';
import 'package:books_discovery_app/shared/widgets/base_widget.dart';
import 'package:books_discovery_app/shared/widgets/common_empty_state.dart';
import 'package:books_discovery_app/shared/widgets/custom_input_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeTab extends ConsumerStatefulWidget {
  const HomeTab({super.key});

  @override
  ConsumerState<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends ConsumerState<HomeTab> {
  late HomeScreenState homeState;
  String searchText = '';

  @override
  void initState() {
    super.initState();
    homeState = ref.read(homeScreenPtovider);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      fetchBooks();
    });
  }

  Future<void> fetchBooks() async {
    await ref
        .read(homeScreenPtovider.notifier)
        .fetchBooks(context, query: 'popular');
  }

  @override
  Widget build(BuildContext context) {
    final homeState = ref.watch(homeScreenPtovider);
    return BaseWidget(
      screen: homeState.isLoading && homeState.books.isEmpty
          ? AppLoader.loaderWidget()
          : homeState.error != null && homeState.books.isEmpty
          ? CommonEmptyState(
              buttonText: "RETRY",
              isBackButtonRequired: false,
              stateScreenSubHeading: "TO DO",
              stateScreenHeading: StringConstants.somethingWentWrongMessage,
              stateScreenEmoji: "",
              onTapButton: () {},
            )
          : Column(
              children: [
                CustomInputText(
                  labelText: "",
                  hintText: "serach",
                  isSecure: false,
                  isForSearch: true,
                ),
                _buildBookList(),
              ],
            ),
    );
  }

  Widget _buildBookList() {
    return Expanded(
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        itemCount: homeState.books.length,
        itemBuilder: (context, index) {
          final Book book = homeState.books[index];
          final String title = book.volumeInfo?.title ?? 'Unknown Title';
          final List<String>? authors = book.volumeInfo?.authors;
          final String authorsText = authors != null && authors.isNotEmpty
              ? authors.join(', ')
              : 'Unknown Author';
          final String? imageUrl = book.volumeInfo?.imageLinks?.thumbnail;
          return Card(
            margin: const EdgeInsets.only(bottom: 12.0),
            child: ListTile(
              leading: ClipRRect(
                borderRadius: BorderRadius.circular(4.0),
                child: imageUrl != null
                    ? Image.network(
                        imageUrl,
                        width: 50,
                        height: 70,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          // Handle image loading errors
                          return Container(
                            width: 50,
                            height: 70,
                            color: Colors.grey[300],
                            child: const Icon(Icons.book, color: Colors.grey),
                          );
                        },
                      )
                    : Container(
                        width: 50,
                        height: 70,
                        color: Colors.grey[300],
                        child: const Icon(Icons.book, color: Colors.grey),
                      ),
              ),
              // --- Title and Subtitle ---
              title: Text(
                title,
                style: const TextStyle(fontWeight: FontWeight.w500),
              ),
              subtitle: Text(
                'by $authorsText',
                style: const TextStyle(color: Colors.grey),
                maxLines: 1, // Prevent subtitle from taking too much space
                overflow: TextOverflow.ellipsis,
              ),
              // --- Trailing: Action ---
              trailing: IconButton(
                icon: const Icon(Icons.more_vert),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Options for '${title}'")),
                  );
                },
              ),
              onTap: () {
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(SnackBar(content: Text("Tapped on '${title}'")));
                // Example navigation (uncomment and adjust when you have a details screen):
                // Navigator.pushNamed(context, '/book/details', arguments: book);
              },
            ),
          );
        },
      ),
    );
  }
}
