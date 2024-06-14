class AppException {
  final String message;
  AppException({this.message = 'خطای نامشخص'});
  @override
  String toString() {
    super.toString();
    return message;
  }
}
