import 'package:flutter/foundation.dart';

Uri getApiEndpoint(String path) {
  Uri endpointUrl;

  if (kDebugMode) {
    endpointUrl = Uri.parse("http://192.168.65.202:5000");
  } else {
    endpointUrl = Uri.parse("https://kururin.pleb.moe");
  }

  return endpointUrl.replace(
    path: path,
  );
}
