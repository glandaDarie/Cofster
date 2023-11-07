import 'package:share_plus/share_plus.dart';

class InvitieAFriendService {
  InvitieAFriendService._();

  static Future<bool> displayCofsterLocationMap(String url,
      {String catchPhrase = "", String subject = null}) async {
    ShareResult result = subject == null
        ? await Share.shareWithResult("${catchPhrase}${url}")
        : await Share.shareWithResult("${catchPhrase}${url}", subject: subject);
    return result.status == ShareResultStatus.success;
  }
}
