// features/home/viewmodels/home_notifier.dart
import 'package:books_discovery_app/core/services/pagination_helper.dart';
import 'package:books_discovery_app/features/home/models/books_model.dart';
import 'package:books_discovery_app/features/home/models/home_screen_state.dart';
import 'package:books_discovery_app/features/home/repositories/home_repository.dart';
import 'package:books_discovery_app/shared/app_shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BookStateNotifier extends StateNotifier<HomeScreenState> {
  BookStateNotifier() : super(HomeScreenState.initial());

  final HomeRepository homeRepository = HomeRepository();
  final PaginationHelper<Book> paginationHelper = PaginationHelper<Book>(
    limit: 40,
  );

  bool get hasMoreData => paginationHelper.hasMoreData;

  void resetPagination() {
    paginationHelper.reset();
  }

  Future<void> fetchBooks(
    BuildContext context, {
    String query = '',
    String scannerSearch = "",
  }) async {
    try {
      if (paginationHelper.currentOffset == 0) {
        state = state.copyWith(
          isLoading: true,
          error: null,
          isLoadingMore: false,
        );
      } else {
        state = state.copyWith(
          isLoadingMore: true,
          isLoading: false,
          error: null,
        );
      }

      final jsonData = await homeRepository.fetchBooks(
        context,
        query: query,
        scannerSearch: scannerSearch,
        offset: paginationHelper.currentOffset,
        limit: paginationHelper.limit,
      );

      if (jsonData is Map<String, dynamic> &&
          jsonData.containsKey('items') &&
          jsonData['items'] is List) {
        final List<Book> fetchedBooks = (jsonData['items'] as List)
            .map((item) => Book.fromJson(item as Map<String, dynamic>))
            .toList();

        if (paginationHelper.currentOffset == 0) {
          state = state.copyWith(
            books: fetchedBooks,
            isLoading: false,
            isLoadingMore: false,
            error: null,
          );
        } else {
          state = state.copyWith(
            books: [...state.books, ...fetchedBooks],
            isLoading: false,
            isLoadingMore: false,
            error: null,
          );
        }
        paginationHelper.updateState(fetchedBooks);
        AppSharedPreferences.customSharedPreferences.saveSearchQueryAndResults(
          query,
          fetchedBooks,
        );
      } else {
        if (jsonData["totalItems"] == 0) {
          state = state.copyWith(books: [], isLoading: false);
        } else {
          state = state.copyWith(
            isLoading: false,
            isLoadingMore: false,
            error: 'Invalid data format received from server.',
          );
        }
      }
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        isLoadingMore: false,
        error: 'Failed to fetch books. Please try again.',
      );
    }
  }
}

final homeScreenProvider =
    StateNotifierProvider<BookStateNotifier, HomeScreenState>((ref) {
      return BookStateNotifier();
    });
