class UrlService {
  String baseUrl = "";
  String endPoint = "";
  Map<String, String> params;

  UrlService(String baseUrl, String endPoint, [Map<String, String> params]) {
    this.baseUrl = baseUrl;
    this.endPoint = endPoint;
    this.params = params ?? {};
  }

  String createUrl() {
    String url = this.baseUrl + this.endPoint;
    if (this.params.isNotEmpty) {
      url += "?";
      this.params.forEach((key, value) {
        url += "$key=$value&";
      });
      url = url.substring(0, url.length - 1);
    }
    return url;
  }
}
