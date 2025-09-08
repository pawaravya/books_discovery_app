class PaginationHelper<T> {
  int _currentOffset = 0;
  final int _limit;
  bool _hasMoreData = true;

  PaginationHelper({int limit = 10}) : _limit = limit;

  int get currentOffset => _currentOffset;
  bool get hasMoreData => _hasMoreData;
  int get limit => _limit;

  /// Resets the pagination state
  void reset() {
    _currentOffset = 0;
    _hasMoreData = true;
  }

  /// Updates the pagination state based on the response
  void updateState(List<T>? newData) {
    if (newData == null || newData.isEmpty) {
      _hasMoreData = false;
    } else {
      _currentOffset += _limit;
    }
  }


}
