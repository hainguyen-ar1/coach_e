import 'dart:async';

import 'package:coach_e/features/coaching/data/coaching_history_repository.dart';
import 'package:coach_e/features/coaching/models/coaching_models.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

enum CoachingHistoryStatus { loading, ready, saving, failure }

class CoachingHistoryState {
  const CoachingHistoryState({
    required this.status,
    this.sessions = const [],
    this.errorMessage,
  });

  const CoachingHistoryState.loading()
    : this(status: CoachingHistoryStatus.loading);

  final CoachingHistoryStatus status;
  final List<CoachingSessionSummary> sessions;
  final String? errorMessage;

  CoachingHistoryState copyWith({
    CoachingHistoryStatus? status,
    List<CoachingSessionSummary>? sessions,
    String? errorMessage,
    bool clearError = false,
  }) {
    return CoachingHistoryState(
      status: status ?? this.status,
      sessions: sessions ?? this.sessions,
      errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
    );
  }
}

class CoachingHistoryCubit extends Cubit<CoachingHistoryState> {
  CoachingHistoryCubit({required CoachingHistoryRepository repository})
    : _repository = repository,
      super(const CoachingHistoryState.loading()) {
    unawaited(loadRecentSessions());
  }

  final CoachingHistoryRepository _repository;

  Future<void> loadRecentSessions() async {
    emit(state.copyWith(status: CoachingHistoryStatus.loading));
    try {
      final sessions = await _repository.loadRecentSessions();
      emit(
        CoachingHistoryState(
          status: CoachingHistoryStatus.ready,
          sessions: sessions,
        ),
      );
    } on Object {
      emit(
        state.copyWith(
          status: CoachingHistoryStatus.failure,
          errorMessage: 'Không đọc được lịch sử coaching local.',
        ),
      );
    }
  }

  Future<CoachingSessionSummary> saveCompletedDraft(
    CoachingSessionDraft draft,
  ) async {
    final previousSessions = state.sessions;
    emit(state.copyWith(status: CoachingHistoryStatus.saving));

    try {
      final summary = CoachingSessionSummary.fromDraft(draft);
      final savedSummary = await _repository.saveSession(summary);
      final sessions = await _repository.loadRecentSessions();
      emit(
        CoachingHistoryState(
          status: CoachingHistoryStatus.ready,
          sessions: sessions,
        ),
      );
      return savedSummary;
    } on Object {
      emit(
        CoachingHistoryState(
          status: CoachingHistoryStatus.failure,
          sessions: previousSessions,
          errorMessage: 'Không lưu được phiên coaching local.',
        ),
      );
      rethrow;
    }
  }

  Future<void> clearHistory() async {
    emit(state.copyWith(status: CoachingHistoryStatus.loading));
    try {
      await _repository.clearHistory();
      emit(const CoachingHistoryState(status: CoachingHistoryStatus.ready));
    } on Object {
      emit(
        state.copyWith(
          status: CoachingHistoryStatus.failure,
          errorMessage: 'Không xoá được lịch sử coaching local.',
        ),
      );
    }
  }
}
