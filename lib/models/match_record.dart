import 'dart:math';
import 'match_config.dart';
import 'innings.dart';

/// Represents a complete cricket match with both innings and winner logic.
class MatchRecord {
  final String id;
  final DateTime date;
  MatchConfig config;
  Innings innings1;
  Innings innings2;
  int currentInningsNumber; // 1 or 2
  bool isFinished;

  MatchRecord({
    required this.id,
    DateTime? date,
    required this.config,
    required this.innings1,
    required this.innings2,
    this.currentInningsNumber = 1,
    this.isFinished = false,
  }) : date = date ?? DateTime.now();

  Innings get currentInnings =>
      currentInningsNumber == 1 ? innings1 : innings2;

  int get targetScore => innings1.totalRuns + 1;

  int get runsNeeded => max(0, targetScore - innings2.totalRuns);

  int get ballsRemaining =>
      max(0, (config.totalOvers * 6) - innings2.legalBallsBowled);

  double get requiredRunRate {
    if (ballsRemaining <= 0) return 0.0;
    return (runsNeeded / (ballsRemaining / 6.0));
  }

  /// Calculates the match status and winner text.
  String get resultText {
    if (!isFinished) {
      if (currentInningsNumber == 1) {
        return '1st Innings in progress';
      } else {
        return 'Need $runsNeeded runs in $ballsRemaining balls';
      }
    }

    // 2nd innings chased successfully
    if (innings2.totalRuns >= targetScore) {
      int wicketsInHand = config.maxWickets - innings2.totalWickets;
      String ballsStr = ballsRemaining > 0 ? ' ($ballsRemaining balls left)' : '';
      return '${innings2.battingTeam} won by $wicketsInHand wicket${wicketsInHand == 1 ? '' : 's'}$ballsStr';
    }

    // 1st innings team defended total
    if (innings2.isInningsFinished && innings2.totalRuns < innings1.totalRuns) {
      int marginRuns = innings1.totalRuns - innings2.totalRuns;
      return '${innings1.battingTeam} won by $marginRuns run${marginRuns == 1 ? '' : 's'}';
    }

    // Scores level
    if (innings2.isInningsFinished && innings2.totalRuns == innings1.totalRuns) {
      return 'Match Tied! 🤝';
    }

    return 'Match Completed';
  }

  String get winningTeam {
    if (!isFinished) return '';
    if (innings2.totalRuns >= targetScore) {
      return innings2.battingTeam;
    }
    if (innings2.isInningsFinished && innings2.totalRuns < innings1.totalRuns) {
      return innings1.battingTeam;
    }
    return 'Tie';
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'date': date.toIso8601String(),
        'config': config.toJson(),
        'innings1': innings1.toJson(),
        'innings2': innings2.toJson(),
        'currentInningsNumber': currentInningsNumber,
        'isFinished': isFinished,
      };

  factory MatchRecord.fromJson(Map<String, dynamic> json) => MatchRecord(
        id: json['id'] as String? ?? DateTime.now().millisecondsSinceEpoch.toString(),
        date: json['date'] != null
            ? DateTime.tryParse(json['date'] as String) ?? DateTime.now()
            : DateTime.now(),
        config: MatchConfig.fromJson(json['config'] as Map<String, dynamic>),
        innings1: Innings.fromJson(json['innings1'] as Map<String, dynamic>),
        innings2: Innings.fromJson(json['innings2'] as Map<String, dynamic>),
        currentInningsNumber: json['currentInningsNumber'] as int? ?? 1,
        isFinished: json['isFinished'] as bool? ?? false,
      );
}
