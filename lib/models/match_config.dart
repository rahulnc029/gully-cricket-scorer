/// Configuration settings for a match.
class MatchConfig {
  String teamAName;
  String teamBName;
  int totalOvers;
  int maxWickets;
  String battingFirstTeam; // "Team A" or "Team B"
  int wideRuns;
  int noBallRuns;
  bool reballOnWide;
  bool reballOnNoBall;

  MatchConfig({
    this.teamAName = 'Team A',
    this.teamBName = 'Team B',
    this.totalOvers = 6,
    this.maxWickets = 10,
    this.battingFirstTeam = 'Team A',
    this.wideRuns = 1,
    this.noBallRuns = 1,
    this.reballOnWide = true,
    this.reballOnNoBall = true,
  });

  String get bowlingFirstTeam =>
      battingFirstTeam == teamAName ? teamBName : teamAName;

  MatchConfig copyWith({
    String? teamAName,
    String? teamBName,
    int? totalOvers,
    int? maxWickets,
    String? battingFirstTeam,
    int? wideRuns,
    int? noBallRuns,
    bool? reballOnWide,
    bool? reballOnNoBall,
  }) {
    return MatchConfig(
      teamAName: teamAName ?? this.teamAName,
      teamBName: teamBName ?? this.teamBName,
      totalOvers: totalOvers ?? this.totalOvers,
      maxWickets: maxWickets ?? this.maxWickets,
      battingFirstTeam: battingFirstTeam ?? this.battingFirstTeam,
      wideRuns: wideRuns ?? this.wideRuns,
      noBallRuns: noBallRuns ?? this.noBallRuns,
      reballOnWide: reballOnWide ?? this.reballOnWide,
      reballOnNoBall: reballOnNoBall ?? this.reballOnNoBall,
    );
  }

  Map<String, dynamic> toJson() => {
        'teamAName': teamAName,
        'teamBName': teamBName,
        'totalOvers': totalOvers,
        'maxWickets': maxWickets,
        'battingFirstTeam': battingFirstTeam,
        'wideRuns': wideRuns,
        'noBallRuns': noBallRuns,
        'reballOnWide': reballOnWide,
        'reballOnNoBall': reballOnNoBall,
      };

  factory MatchConfig.fromJson(Map<String, dynamic> json) => MatchConfig(
        teamAName: json['teamAName'] as String? ?? 'Team A',
        teamBName: json['teamBName'] as String? ?? 'Team B',
        totalOvers: json['totalOvers'] as int? ?? 6,
        maxWickets: json['maxWickets'] as int? ?? 10,
        battingFirstTeam: json['battingFirstTeam'] as String? ?? 'Team A',
        wideRuns: json['wideRuns'] as int? ?? 1,
        noBallRuns: json['noBallRuns'] as int? ?? 1,
        reballOnWide: json['reballOnWide'] as bool? ?? true,
        reballOnNoBall: json['reballOnNoBall'] as bool? ?? true,
      );
}
