import 'package:books_discovery_app/features/home/models/books_model.dart';
import 'package:books_discovery_app/features/home/models/home_screen_state.dart';
import 'package:books_discovery_app/features/home/repositories/home_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BookStateNotifier extends StateNotifier<HomeScreenState> {
  BookStateNotifier() : super(HomeScreenState.initial());
  HomeRepository homeRepository = HomeRepository();
  Future<void> fetchBooks(
    BuildContext context, {
    String query = 'programming',
  }) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final jsonData = await homeRepository.fetchBooks(context, query: query);
      if (jsonData is Map<String, dynamic> &&
          jsonData.containsKey('items') &&
          jsonData['items'] is List) {
        final List<Book> fetchedBooks = (jsonData['items'] as List)
            .map((item) => Book.fromJson(item as Map<String, dynamic>))
            .toList();
        state = state.copyWith(
          books: fetchedBooks,
          isLoading: false,
          error: null,
        );
      } else {
        state = state.copyWith(
          isLoading: false,
          error: 'Invalid data format received from server.',
        );
      }
    } catch (e) {
      print("Error fetching books: $e"); // Log the error
      state = state.copyWith(
        isLoading: false,
        error: 'Failed to process book data. Please try again.',
      );
    }
  }
}

final homeScreenPtovider =
    StateNotifierProvider<BookStateNotifier, HomeScreenState>((ref) {
      return BookStateNotifier();
    });
