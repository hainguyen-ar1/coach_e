import 'dart:convert';

import 'package:coach_e/features/coaching/models/coaching_models.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CoachingHistoryRepository {
  const CoachingHistoryRepository();

  static const _storageKey = 'coach_e.coaching.session_history.v1';
  static const _maxStoredSessions = 20;

  Future<List<CoachingSessionSummary>> loadRecentSessions() async {
    final preferences = await SharedPreferences.getInstance();
    final storedItems = preferences.getStringList(_storageKey) ?? const [];
    final sessions = <CoachingSessionSummary>[];

    for (final item in storedItems) {
      try {
        final decoded = jsonDecode(item);
        if (decoded is Map<String, dynamic>) {
          sessions.add(CoachingSessionSummary.fromJson(decoded));
        }
      } on Object {
        // Ignore malformed local entries so one bad item does not break Home.
      }
    }

    sessions.sort((a, b) => b.completedAt.compareTo(a.completedAt));
    return List<CoachingSessionSummary>.unmodifiable(sessions);
  }

  Future<CoachingSessionSummary> saveSession(
    CoachingSessionSummary summary,
  ) async {
    final preferences = await SharedPreferences.getInstance();
    final existingSessions = await loadRecentSessions();
    final nextSessions = [
      summary,
      for (final session in existingSessions)
        if (session.id != summary.id) session,
    ]..sort((a, b) => b.completedAt.compareTo(a.completedAt));

    final cappedSessions = nextSessions.take(_maxStoredSessions).toList();
    await preferences.setStringList(_storageKey, [
      for (final session in cappedSessions) jsonEncode(session.toJson()),
    ]);

    return summary;
  }

  Future<void> clearHistory() async {
    final preferences = await SharedPreferences.getInstance();
    await preferences.remove(_storageKey);
  }
}
