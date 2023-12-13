sealed class ViewState {}

class LoadingState extends ViewState {}

class SuccessState extends ViewState {}

class ErrorState extends ViewState {
  final String message;
  final StackTrace stackTrace;
  ErrorState({
    required this.message,
    required this.stackTrace,
  });
}
