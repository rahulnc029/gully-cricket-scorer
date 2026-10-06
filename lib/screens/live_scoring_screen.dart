import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/match_provider.dart';
import '../theme/app_theme.dart';
import '../widgets/adjust_overs_dialog.dart';
import '../widgets/extras_dialog.dart';
import '../widgets/keypad.dart';
import '../widgets/over_timeline.dart';
import '../widgets/score_display.dart';
import '../widgets/target_card.dart';
import '../widgets/wicket_dialog.dart';
import 'match_summary_screen.dart';
import 'setup_screen.dart';

/// Active match live scoring screen.
class LiveScoringScreen extends StatelessWidget {
  const LiveScoringScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final matchProv = context.watch<MatchProvider>();
    final match = matchProv.currentMatch;

    if (match == null) {
      return const SetupScreen();
    }

    // If match has ended, prompt or navigate to summary
    if (match.isFinished) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => MatchSummaryScreen(match: match)),
        );
      });
    }

    final currentInnings = match.currentInnings;
    final is2ndInnings = match.currentInningsNumber == 2;

    return Scaffold(
      appBar: AppBar(
        title: Text('${match.config.teamAName} vs ${match.config.teamBName}'),
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert_rounded),
            color: AppTheme.surfaceElevated,
            onSelected: (value) {
              if (value == 'adjust_overs') {
                showDialog(
                  context: context,
                  builder: (_) => AdjustOversDialog(
                    currentTotalOvers: match.config.totalOvers,
                    onConfirm: (newOvers) {
                      matchProv.adjustOvers(newOvers);
                    },
                  ),
                );
              } else if (value == 'switch_innings') {
                if (!is2ndInnings) {
                  _showConfirmDialog(
                    context,
                    title: 'Declare / Switch Innings',
                    message: 'Are you sure you want to end the 1st innings now?',
                    onConfirm: () => matchProv.switchInnings(),
                  );
                }
              } else if (value == 'end_match') {
                _showConfirmDialog(
                  context,
                  title: 'End Match',
                  message: 'Are you sure you want to finish this match and see the summary?',
                  onConfirm: () => matchProv.endMatchManually(),
                );
              } else if (value == 'reset') {
                _showConfirmDialog(
                  context,
                  title: 'Reset Match',
                  message: 'Discard this match and start over from setup?',
                  onConfirm: () {
                    matchProv.resetMatch();
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (_) => const SetupScreen()),
                    );
                  },
                );
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'adjust_overs',
                child: Row(
                  children: [
                    Icon(Icons.tune_rounded, size: 20, color: AppTheme.secondary),
                    SizedBox(width: 10),
                    Text('Adjust Total Overs'),
                  ],
                ),
              ),
              if (!is2ndInnings)
                const PopupMenuItem(
                  value: 'switch_innings',
                  child: Row(
                    children: [
                      Icon(Icons.swap_horiz_rounded, size: 20, color: AppTheme.accentAmber),
                      SizedBox(width: 10),
                      Text('Declare 1st Innings'),
                    ],
                  ),
                ),
              const PopupMenuItem(
                value: 'end_match',
                child: Row(
                  children: [
                    Icon(Icons.flag_rounded, size: 20, color: AppTheme.primary),
                    SizedBox(width: 10),
                    Text('End Match Now'),
                  ],
                ),
              ),
              const PopupMenuDivider(),
              const PopupMenuItem(
                value: 'reset',
                child: Row(
                  children: [
                    Icon(Icons.refresh_rounded, size: 20, color: AppTheme.wicketRed),
                    SizedBox(width: 10),
                    Text('Reset / New Match'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // 1. Primary Scoreboard Card
              ScoreDisplay(
                innings: currentInnings,
                inningsNumber: match.currentInningsNumber,
                totalOvers: match.config.totalOvers,
              ),

              const SizedBox(height: 10),

              // 2. Target Card (Displayed only in 2nd innings)
              if (is2ndInnings) ...[
                TargetCard(match: match),
                const SizedBox(height: 10),
              ],

              // 3. Current Over Ball Ticker
              OverTimeline(innings: currentInnings),

              const Spacer(),

              // 4. Large Ground Scoring Keypad
              ScoringKeypad(
                canUndo: currentInnings.balls.isNotEmpty || is2ndInnings,
                onNormalRun: (runs) {
                  matchProv.recordBall(runs: runs);
                },
                onWide: () {
                  // Standard wide = 1 extra run + re-ball
                  matchProv.recordBall(runs: 0, isWide: true);
                },
                onNoBall: () {
                  // Standard no-ball = 1 extra run + re-ball
                  matchProv.recordBall(runs: 0, isNoBall: true);
                },
                onByes: () {
                  // Standard 1 bye
                  matchProv.recordBall(runs: 1, isBye: true);
                },
                onWicket: () {
                  showDialog(
                    context: context,
                    builder: (_) => WicketDialog(
                      onConfirm: (wicketType, runsCompleted) {
                        matchProv.recordBall(
                          runs: runsCompleted,
                          isWicket: true,
                          wicketType: wicketType,
                        );
                      },
                    ),
                  );
                },
                onCustomExtras: () {
                  showDialog(
                    context: context,
                    builder: (_) => ExtrasDialog(
                      onConfirm: ({
                        required int runs,
                        required bool isWide,
                        required bool isNoBall,
                        required bool isBye,
                        required bool isLegBye,
                      }) {
                        matchProv.recordBall(
                          runs: runs,
                          isWide: isWide,
                          isNoBall: isNoBall,
                          isBye: isBye,
                          isLegBye: isLegBye,
                        );
                      },
                    ),
                  );
                },
                onUndo: () {
                  matchProv.undoLastBall();
                },
              ),

              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }

  void _showConfirmDialog(
    BuildContext context, {
    required String title,
    required String message,
    required VoidCallback onConfirm,
  }) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: AppTheme.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: AppTheme.surfaceBorder),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w800)),
        content: Text(message, style: const TextStyle(color: AppTheme.textSecondary)),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              onConfirm();
            },
            child: const Text('Confirm'),
          ),
        ],
      ),
    );
  }
}
