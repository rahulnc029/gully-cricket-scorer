/// Represents a single ball event in a cricket match.
class BallEvent {
  final int runsScored; // Runs made by batsman or running
  final bool isWide;
  final bool isNoBall;
  final bool isBye;
  final bool isLegBye;
  final bool isWicket;
  final String? wicketType; // "Bowled", "Caught", "Run Out", "Stumped", "LBW", "Other"
  final DateTime timestamp;

  BallEvent({
    required this.runsScored,
    this.isWide = false,
    this.isNoBall = false,
    this.isBye = false,
    this.isLegBye = false,
    this.isWicket = false,
    this.wicketType,
    DateTime? timestamp,
  }) : timestamp = timestamp ?? DateTime.now();

  /// Whether this ball was a legal delivery that counts towards the over.
  bool get isLegalDelivery => !isWide && !isNoBall;

  /// Total runs contributed to team total on this ball.
  int get totalRuns {
    int extra = 0;
    if (isWide) extra += 1;
    if (isNoBall) extra += 1;
    return runsScored + extra;
  }

  /// Compact string display on the ball-by-ball timeline (e.g. "0", "4", "6", "Wd", "Nb+4", "W").
  String get displayTag {
    if (isWicket) {
      if (runsScored > 0) return 'W+$runsScored';
      return 'W';
    }
    if (isWide) {
      if (runsScored > 0) return 'Wd+$runsScored';
      return 'Wd';
    }
    if (isNoBall) {
      if (runsScored > 0) return 'Nb+$runsScored';
      return 'Nb';
    }
    if (isBye || isLegBye) {
      return 'B$runsScored';
    }
    if (runsScored == 0) return '•';
    return runsScored.toString();
  }

  Map<String, dynamic> toJson() => {
        'runsScored': runsScored,
        'isWide': isWide,
        'isNoBall': isNoBall,
        'isBye': isBye,
        'isLegBye': isLegBye,
        'isWicket': isWicket,
        'wicketType': wicketType,
        'timestamp': timestamp.toIso8601String(),
      };

  factory BallEvent.fromJson(Map<String, dynamic> json) => BallEvent(
        runsScored: json['runsScored'] as int? ?? 0,
        isWide: json['isWide'] as bool? ?? false,
        isNoBall: json['isNoBall'] as bool? ?? false,
        isBye: json['isBye'] as bool? ?? false,
        isLegBye: json['isLegBye'] as bool? ?? false,
        isWicket: json['isWicket'] as bool? ?? false,
        wicketType: json['wicketType'] as String?,
        timestamp: json['timestamp'] != null
            ? DateTime.tryParse(json['timestamp'] as String) ?? DateTime.now()
            : DateTime.now(),
      );
}
