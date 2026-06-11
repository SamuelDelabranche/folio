import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class UpdateInfo {
  final String latestVersion;
  final String releaseUrl;

  const UpdateInfo({required this.latestVersion, required this.releaseUrl});
}

class UpdateService {
  static const _owner          = 'SamuelDelabranche';
  static const _repo           = 'folio';
  static const _lastCheckKey   = 'last_update_check';
  static const _checkIntervalH = 24;

  static Future<bool> _shouldCheck() async {
    final prefs     = await SharedPreferences.getInstance();
    final lastCheck = prefs.getInt(_lastCheckKey);
    if (lastCheck == null) return true;
    final last = DateTime.fromMillisecondsSinceEpoch(lastCheck);
    return DateTime.now().difference(last).inHours >= _checkIntervalH;
  }

  static bool _isNewer(String latest, String current) {
    // Tolère les suffixes type "1.2.0-beta" : on n'extrait que les chiffres.
    int parsePart(String s) =>
        int.tryParse(RegExp(r'\d+').firstMatch(s)?.group(0) ?? '') ?? 0;
    final l = latest.split('.').map(parsePart).toList();
    final c = current.split('.').map(parsePart).toList();
    for (int i = 0; i < 3; i++) {
      final lv = i < l.length ? l[i] : 0;
      final cv = i < c.length ? c[i] : 0;
      if (lv > cv) return true;
      if (lv < cv) return false;
    }
    return false;
  }

  /// [force] ignore l'intervalle de 24 h (vérification manuelle depuis les
  /// paramètres) et propage les erreurs réseau pour pouvoir les afficher.
  static Future<UpdateInfo?> checkForUpdate({bool force = false}) async {
    if (!force && !await _shouldCheck()) return null;

    try {
      final response = await http.get(
        Uri.parse('https://api.github.com/repos/$_owner/$_repo/releases/latest'),
        headers: {'Accept': 'application/vnd.github+json'},
      ).timeout(const Duration(seconds: 8));

      if (response.statusCode != 200) return null;

      final data       = jsonDecode(response.body) as Map<String, dynamic>;
      final tagName    = (data['tag_name'] as String).replaceFirst('v', '');
      final releaseUrl = data['html_url'] as String;

      final info           = await PackageInfo.fromPlatform();
      final currentVersion = info.version;

      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt(_lastCheckKey, DateTime.now().millisecondsSinceEpoch);

      if (_isNewer(tagName, currentVersion)) {
        return UpdateInfo(latestVersion: tagName, releaseUrl: releaseUrl);
      }
      return null;
    } catch (_) {
      if (force) rethrow;
      return null;
    }
  }

  static Future<void> openReleasePage(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }
}
