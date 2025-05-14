enum LoadingStatus { initial, loading, loaded, error }

/// A utility class to manage loading states in a consistent way
/// across the application.
class LoadingState<T> {
  final LoadingStatus status;
  final T? data;
  final String? errorMessage;

  const LoadingState._({required this.status, this.data, this.errorMessage});

  /// Initial state, before any loading has occurred
  factory LoadingState.initial() =>
      const LoadingState._(status: LoadingStatus.initial);

  /// Loading state, when data is being fetched
  factory LoadingState.loading() =>
      const LoadingState._(status: LoadingStatus.loading);

  /// Successful loading state with data
  factory LoadingState.loaded(T data) =>
      LoadingState._(status: LoadingStatus.loaded, data: data);

  /// Error state with an optional error message
  factory LoadingState.error([String? message]) => LoadingState._(
    status: LoadingStatus.error,
    errorMessage: message ?? 'An error occurred',
  );

  /// Whether the state is in loading status
  bool get isLoading => status == LoadingStatus.loading;

  /// Whether the state has loaded data
  bool get hasData => status == LoadingStatus.loaded && data != null;

  /// Whether the state has an error
  bool get hasError => status == LoadingStatus.error;

  /// Map the data while preserving the loading state
  LoadingState<R> map<R>(R Function(T data) mapper) {
    if (status == LoadingStatus.loaded && data != null) {
      return LoadingState<R>.loaded(mapper(data as T));
    }
    return LoadingState<R>._(status: status, errorMessage: errorMessage);
  }
}
