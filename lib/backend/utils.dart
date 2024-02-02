Uri getApiEndpoint(String path) {
  Uri endpointUrl;

  endpointUrl = Uri.parse("https://kururin.pleb.moe");

  return endpointUrl.replace(
    path: path,
  );
}
