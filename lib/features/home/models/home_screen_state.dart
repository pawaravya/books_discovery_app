// features/home/models/home_screen_state.dart
import 'books_model.dart';

class HomeScreenState {
  final List<Book> books;
  final bool isLoading; // initial loading
  final bool isLoadingMore; // pagination loading
  final String? error;

  HomeScreenState({
    required this.books,
    required this.isLoading,
    required this.isLoadingMore,
    this.error,
  });

  factory HomeScreenState.initial() => HomeScreenState(
        books: [],
        isLoading: false,
        isLoadingMore: false,
        error: null,
      );

  HomeScreenState copyWith({
    List<Book>? books,
    bool? isLoading,
    bool? isLoadingMore,
    String? error,
  }) {
    return HomeScreenState(
      books: books ?? this.books,
      isLoading: isLoading ?? this.isLoading,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      error: error,
    );
  }
}
