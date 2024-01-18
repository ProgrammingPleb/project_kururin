import 'dart:io';

import 'package:logger/logger.dart';

class BackendFetchError extends HttpException {
  BackendFetchError(String? message)
      : super("Unable to get a valid response from the backend!") {
    message ??= "[No message was given.]";
    Logger().e("BackendFetchError: Backend Message was \"$message\"");
  }
}
