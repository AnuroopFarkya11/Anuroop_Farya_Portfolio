import 'package:url_launcher/url_launcher.dart';

class Utilty {
  static Future<void> openUrl(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    }
  }

  static Future<void> openMail() => openUrl("mailto:anuroopf02@gmail.com");

  static Future<void> openMyLocation() =>
      openUrl("");
  static Future<void> openMyPhoneNo() => openUrl("tel:+91-8305048867");
  static Future<void> openWhatsapp() => openUrl("https://wa.me/8305048867");
}
