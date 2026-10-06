import 'ball_event.dart';

/// Represents a single innings in the match.
class Innings {
  final String battingTeam;
  final String bowlingTeam;
  int maxOvers;
  int maxWickets;
  final List<BallEvent> balls;

  Innings({
    required this.battingTeam,
    required this.bowlingTeam,
    required this.maxOvers,
    required this.maxWickets,
    List<BallEvent>? balls,
  }) : balls = balls ?? [];

  /// Total runs scored in this innings.
  int get totalRuns {
    return balls.fold(0, (sum, b) => sum + b.totalRuns);
  }

  /// Total wickets lost.
  int get totalWickets {
    return balls.where((b) => b.isWicket).length;
  }

  /// Total legal deliveries bowled.
  int get legalBallsBowled {
    return balls.where((b) => b.isLegalDelivery).length;
  }

  /// Number of completed full overs.
  int get completedOvers => legalBallsBowled ~/ 6;

  /// Remaining balls in the ongoing over.
  int get ballsInCurrentOver => legalBallsBowled % 6;

  /// Display string for overs (e.g. "4.2").
  String get oversFormatted => '$completedOvers.$ballsInCurrentOver';

  /// Whether team is all out.
  bool get isAllOut => totalWickets >= maxWickets;

  /// Whether max overs have been completed.
  bool get isOversCompleted => legalBallsBowled >= (maxOvers * 6);

  /// Whether this innings is concluded.
  bool get isInningsFinished => isAllOut || isOversCompleted;

  /// Current Run Rate (CRR).
  double get currentRunRate {
    if (legalBallsBowled == 0) return 0.0;
    return (totalRuns / (legalBallsBowled / 6.0));
  }

  /// Count of boundary 4s off bat.
  int get foursCount => balls
      .where((b) =>
          b.runsScored == 4 &&
          !b.isWide &&
          !b.isNoBall &&
          !b.isBye &&
          !b.isLegBye)
      .length;

  /// Count of boundary 6s off bat.
  int get sixesCount => balls
      .where((b) =>
          b.runsScored == 6 &&
          !b.isWide &&
          !b.isNoBall &&
          !b.isBye &&
          !b.isLegBye)
      .length;

  /// Count of dot balls (legal delivery with 0 runs and no wicket).
  int get dotsCount => balls
      .where((b) => b.isLegalDelivery && b.runsScored == 0 && !b.isWicket)
      .length;

  /// Total extras (wides, no balls, byes).
  int get extrasCount {
    return balls.where((b) => b.isWide || b.isNoBall || b.isBye || b.isLegBye).length;
  }

  /// Total runs contributed purely by extras.
  int get extraRunsTotal {
    int total = 0;
    for (var b in balls) {
      if (b.isWide) total += 1;
      if (b.isNoBall) total += 1;
      if (b.isBye || b.isLegBye) total += b.runsScored;
    }
    return total;
  }

  int get widesCount => balls.where((b) => b.isWide).length;
  int get noBallsCount => balls.where((b) => b.isNoBall).length;

  /// Balls belonging to the current (ongoing) over.
  List<BallEvent> get currentOverBalls {
    if (balls.isEmpty) return [];
    
    // Find the start index of the current over by counting backwards 
    // until we've seen (ballsInCurrentOver) legal deliveries
    int legalSeen = 0;
    int startIndex = balls.length;

    for (int i = balls.length - 1; i >= 0; i--) {
      if (balls[i].isLegalDelivery) {
        if (legalSeen == ballsInCurrentOver && ballsInCurrentOver > 0) {
          break;
        }
        legalSeen++;
      }
      startIndex = i;
      if (ballsInCurrentOver == 0 && legalSeen == 6) {
        // Just finished an over
        break;
      }
    }

    return balls.sublist(startIndex);
  }

  /// Group all balls into structured over-by-over lists for match breakdown.
  List<OverSummary> get overSummaries {
    List<OverSummary> list = [];
    List<BallEvent> currentOver = [];
    int legalCount = 0;
    int overNum = 1;

    for (var ball in balls) {
      currentOver.add(ball);
      if (ball.isLegalDelivery) {
        legalCount++;
        if (legalCount % 6 == 0) {
          list.add(OverSummary(
            overNumber: overNum,
            balls: List.from(currentOver),
          ));
          currentOver.clear();
          overNum++;
        }
      }
    }

    if (currentOver.isNotEmpty) {
      list.add(OverSummary(
        overNumber: overNum,
        balls: List.from(currentOver),
      ));
    }

    return list;
  }

  Map<String, dynamic> toJson() => {
        'battingTeam': battingTeam,
        'bowlingTeam': bowlingTeam,
        'maxOvers': maxOvers,
        'maxWickets': maxWickets,
        'balls': balls.map((b) => b.toJson()).toList(),
      };

  factory Innings.fromJson(Map<String, dynamic> json) => Innings(
        battingTeam: json['battingTeam'] as String? ?? 'Team A',
        bowlingTeam: json['bowlingTeam'] as String? ?? 'Team B',
        maxOvers: json['maxOvers'] as int? ?? 6,
        maxWickets: json['maxWickets'] as int? ?? 10,
        balls: (json['balls'] as List<dynamic>?)
                ?.map((b) => BallEvent.fromJson(b as Map<String, dynamic>))
                .toList() ??
            [],
      );
}

/// Helper class representing a completed or ongoing over.
class OverSummary {
  final int overNumber;
  final List<BallEvent> balls;

  OverSummary({required this.overNumber, required this.balls});

  int get totalRuns => balls.fold(0, (sum, b) => sum + b.totalRuns);
  int get totalWickets => balls.where((b) => b.isWicket).length;
}
