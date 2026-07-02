import 'package:url_launcher/url_launcher.dart';

class CallUtils {
  static Future<void> callNumber(String number) async {
    final Uri uri = Uri.parse('tel:$number');

    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      throw 'Cannot make call';
    }
  }
}