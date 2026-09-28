import 'package:url_launcher/url_launcher.dart';

/// Small helpers to open the phone dialer or the email app.
/// They return false instead of crashing when it is not possible.
Future<bool> callNumber(String phone) {
  final uri = Uri(scheme: 'tel', path: phone.replaceAll(' ', ''));
  return _launch(uri);
}

Future<bool> sendEmail(String email) {
  final uri = Uri(scheme: 'mailto', path: email.trim());
  return _launch(uri);
}

Future<bool> _launch(Uri uri) async {
  try {
    return await launchUrl(uri);
  } catch (_) {
    return false;
  }
}
