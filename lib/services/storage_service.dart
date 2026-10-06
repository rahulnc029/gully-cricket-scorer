import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/match_record.dart';

/// Lightweight local storage for active match recovery and history.
/// Everything is stored on device in SharedPreferences and can be wiped anytime.
class StorageService {
  static const String _activeMatchKey = 'gully_cricket_active_match';
  static const String _historyKey = 'gully_cricket_history';

  /// Saves ongoing match progress so it won't be lost on app minimization or refresh.
  static Future<void> saveActiveMatch(MatchRecord match) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonStr = jsonEncode(match.toJson());
      await prefs.setString(_activeMatchKey, jsonStr);
    } catch (e) {
      // Ignore storage errors in restricted contexts
    }
  }

  /// Loads the active match if one exists.
  static Future<MatchRecord?> loadActiveMatch() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonStr = prefs.getString(_activeMatchKey);
      if (jsonStr == null || jsonStr.isEmpty) return null;
      final map = jsonDecode(jsonStr) as Map<String, dynamic>;
      return MatchRecord.fromJson(map);
    } catch (e) {
      return null;
    }
  }

  /// Clears active match cache (e.g. when starting fresh match).
  static Future<void> clearActiveMatch() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_activeMatchKey);
    } catch (e) {
      // Ignore
    }
  }

  /// Saves a completed match to local recent history (keeps up to 10).
  static Future<void> saveToHistory(MatchRecord match) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final listStr = prefs.getStringList(_historyKey) ?? [];
      final matchJson = jsonEncode(match.toJson());
      
      // Avoid duplicates with same id
      listStr.removeWhere((item) {
        try {
          final decoded = jsonDecode(item) as Map<String, dynamic>;
          return decoded['id'] == match.id;
        } catch (_) {
          return false;
        }
      });

      listStr.insert(0, matchJson);
      // Keep only last 10 matches
      if (listStr.length > 10) {
        listStr.removeRange(10, listStr.length);
      }

      await prefs.setStringList(_historyKey, listStr);
    } catch (e) {
      // Ignore
    }
  }

  /// Loads recent matches history.
  static Future<List<MatchRecord>> loadHistory() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final listStr = prefs.getStringList(_historyKey) ?? [];
      List<MatchRecord> matches = [];
      for (var str in listStr) {
        try {
          final map = jsonDecode(str) as Map<String, dynamic>;
          matches.add(MatchRecord.fromJson(map));
        } catch (_) {}
      }
      return matches;
    } catch (e) {
      return [];
    }
  }

  /// Completely wipes all match data and history.
  static Future<void> clearAllData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_activeMatchKey);
      await prefs.remove(_historyKey);
    } catch (e) {
      // Ignore
    }
  }
}
