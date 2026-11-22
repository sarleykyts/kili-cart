import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class ShareService {
  static Future<void> shareProductLink({
    required String title,
    required String url,
  }) async {
    await Share.share(
      'Check out "$title" on KiliCart!\n$url',
      subject: 'KiliCart - $title',
    );
  }

  static Future<void> shareCollectionAsImage({
    required String collectionName,
    required String imageBytes,
  }) async {
    await Share.shareXFiles(
      [],
      text: 'Check out my "$collectionName" collection on KiliCart!',
    );
  }

  static Future<void> openKilimallLink(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }
}
