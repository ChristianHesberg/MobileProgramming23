extension QueryParameter on Map<String, String> {
  String asQueryParameter() {
    return entries.map((e) => '${e.key}=${e.value}').join('&');
  }
}
