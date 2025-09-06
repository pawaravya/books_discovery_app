import 'package:books_discovery_app/features/home/models/books_model.dart';

class HomeScreenState {
  final List<Book> books;
  final bool isLoading;
  final String? error;

  HomeScreenState({
    required this.books,
    required this.isLoading,
    this.error,
  });

  // Copy constructor for updating state
  HomeScreenState copyWith({
    List<Book>? books,
    bool? isLoading,
    String? error,
  }) {
    return HomeScreenState(
      books: books ?? this.books,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }

  // Factory constructor for initial state
  factory HomeScreenState.initial() {
    return HomeScreenState(
      books: [],
      isLoading: false,
      error: null,
    );
  }
}