import 'package:shared_preferences/shared_preferences.dart';

/// Tracks whether the expiry reminder dialog has already been shown for the
/// current authenticated login.
class ExpiryReminderDialogService {
  static const String _shownForCurrentLoginKey =
      'expiry_reminder_dialog_shown_for_current_login';

  Future<void> markPendingForLogin() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_shownForCurrentLoginKey, false);
  }

  Future<bool> hasShownForCurrentLogin() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_shownForCurrentLoginKey) ?? false;
  }

  Future<void> markShownForCurrentLogin() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_shownForCurrentLoginKey, true);
  }
}
