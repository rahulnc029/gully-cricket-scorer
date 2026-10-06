import 'package:flutter/foundation.dart';
import '../models/ball_event.dart';
import '../models/innings.dart';
import '../models/match_config.dart';
import '../models/match_record.dart';
import '../services/storage_service.dart';

/// Provider managing active match state, ball-by-ball actions, undo, and persistence.
class MatchProvider extends ChangeNotifier {
  MatchRecord? _currentMatch;
  List<MatchRecord> _history = [];
  bool _isLoading = true;

  MatchRecord? get currentMatch => _currentMatch;
  List<MatchRecord> get history => _history;
  bool get isLoading => _isLoading;
  bool get hasActiveMatch => _currentMatch != null && !_currentMatch!.isFinished;

  Innings? get currentInnings => _currentMatch?.currentInnings;
  bool get isSecondInnings => _currentMatch?.currentInningsNumber == 2;

  MatchProvider() {
    init();
  }

  /// Load cached match or history on startup
  Future<void> init() async {
    _isLoading = true;
    notifyListeners();

    _currentMatch = await StorageService.loadActiveMatch();
    _history = await StorageService.loadHistory();

    _isLoading = false;
    notifyListeners();
  }

  /// Start a new match with custom configurations
  void startNewMatch(MatchConfig config) {
    final id = 'match_${DateTime.now().millisecondsSinceEpoch}';
    final innings1 = Innings(
      battingTeam: config.battingFirstTeam,
      bowlingTeam: config.bowlingFirstTeam,
      maxOvers: config.totalOvers,
      maxWickets: config.maxWickets,
    );
    final innings2 = Innings(
      battingTeam: config.bowlingFirstTeam,
      bowlingTeam: config.battingFirstTeam,
      maxOvers: config.totalOvers,
      maxWickets: config.maxWickets,
    );

    _currentMatch = MatchRecord(
      id: id,
      config: config,
      innings1: innings1,
      innings2: innings2,
      currentInningsNumber: 1,
      isFinished: false,
    );

    _saveState();
    notifyListeners();
  }

  /// Record a ball event (Runs, Extras, Wickets)
  void recordBall({
    required int runs,
    bool isWide = false,
    bool isNoBall = false,
    bool isBye = false,
    bool isLegBye = false,
    bool isWicket = false,
    String? wicketType,
  }) {
    if (_currentMatch == null || _currentMatch!.isFinished) return;

    final ball = BallEvent(
      runsScored: runs,
      isWide: isWide,
      isNoBall: isNoBall,
      isBye: isBye,
      isLegBye: isLegBye,
      isWicket: isWicket,
      wicketType: wicketType,
    );

    final innings = _currentMatch!.currentInnings;
    innings.balls.add(ball);

    // Check match & innings transitions
    if (_currentMatch!.currentInningsNumber == 1) {
      if (innings.isInningsFinished) {
        // Automatically switch to 2nd innings
        _currentMatch!.currentInningsNumber = 2;
      }
    } else {
      // 2nd Innings
      // Check if chased successfully
      if (innings.totalRuns >= _currentMatch!.targetScore) {
        _finishMatch();
      } else if (innings.isInningsFinished) {
        _finishMatch();
      }
    }

    _saveState();
    notifyListeners();
  }

  /// Undo the last recorded ball action
  void undoLastBall() {
    if (_currentMatch == null) return;

    // If match was already completed, resume it
    if (_currentMatch!.isFinished) {
      _currentMatch!.isFinished = false;
    }

    final current = _currentMatch!.currentInnings;
    if (current.balls.isNotEmpty) {
      current.balls.removeLast();
    } else if (_currentMatch!.currentInningsNumber == 2) {
      // If 2nd innings is empty and user wants to undo back to 1st innings
      _currentMatch!.currentInningsNumber = 1;
      if (_currentMatch!.innings1.balls.isNotEmpty) {
        _currentMatch!.innings1.balls.removeLast();
      }
    }

    _saveState();
    notifyListeners();
  }

  /// Switch innings manually (e.g. early declaration or rain)
  void switchInnings() {
    if (_currentMatch == null || _currentMatch!.currentInningsNumber == 2) return;
    _currentMatch!.currentInningsNumber = 2;
    _saveState();
    notifyListeners();
  }

  /// Adjust total overs mid-match (e.g. bad light / time shortage)
  void adjustOvers(int newOvers) {
    if (_currentMatch == null || newOvers < 1) return;
    _currentMatch!.config.totalOvers = newOvers;
    _currentMatch!.innings1.maxOvers = newOvers;
    _currentMatch!.innings2.maxOvers = newOvers;

    // Re-verify if current innings is now finished
    if (_currentMatch!.currentInningsNumber == 1 &&
        _currentMatch!.innings1.isInningsFinished) {
      _currentMatch!.currentInningsNumber = 2;
    } else if (_currentMatch!.currentInningsNumber == 2 &&
        _currentMatch!.innings2.isInningsFinished) {
      _finishMatch();
    }

    _saveState();
    notifyListeners();
  }

  /// Finish the match and add to local history
  void _finishMatch() {
    if (_currentMatch == null) return;
    _currentMatch!.isFinished = true;
    StorageService.saveToHistory(_currentMatch!);
    _history.insert(0, _currentMatch!);
    if (_history.length > 10) _history.removeLast();
    StorageService.clearActiveMatch();
  }

  /// Force end match manually from menu
  void endMatchManually() {
    _finishMatch();
    _saveState();
    notifyListeners();
  }

  /// Reset / discard current match to start clean
  void resetMatch() {
    _currentMatch = null;
    StorageService.clearActiveMatch();
    notifyListeners();
  }

  /// Clear all stored matches for IT/temporary privacy compliance
  Future<void> clearAllStoredData() async {
    _currentMatch = null;
    _history.clear();
    await StorageService.clearAllData();
    notifyListeners();
  }

  void _saveState() {
    if (_currentMatch != null && !_currentMatch!.isFinished) {
      StorageService.saveActiveMatch(_currentMatch!);
    }
  }
}
