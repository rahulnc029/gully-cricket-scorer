import 'package:flutter/material.dart';
import '../models/match_record.dart';
import '../theme/app_theme.dart';

/// Chasing target and required run rate dashboard for 2nd innings.
class TargetCard extends StatelessWidget {
  final MatchRecord match;

  const TargetCard({super.key, required this.match});

  @override
  Widget build(BuildContext context) {
    final target = match.targetScore;
    final runsNeeded = match.runsNeeded;
    final ballsRemaining = match.ballsRemaining;
    final rrr = match.requiredRunRate;
    final chasedRuns = match.innings2.totalRuns;
    final progress = target > 0 ? (chasedRuns / target).clamp(0.0, 1.0) : 0.0;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppTheme.accentAmber.withOpacity(0.15),
            AppTheme.surfaceElevated,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.accentAmber.withOpacity(0.4), width: 1.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(Icons.flag_rounded, color: AppTheme.accentAmber, size: 18),
                  const SizedBox(width: 6),
                  Text(
                    'Target: $target',
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w800,
                      color: AppTheme.accentAmber,
                    ),
                  ),
                ],
              ),
              Text(
                'RRR: ${rrr.toStringAsFixed(2)}',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'Need $runsNeeded run${runsNeeded == 1 ? '' : 's'} in $ballsRemaining ball${ballsRemaining == 1 ? '' : 's'}',
            style: const TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w800,
              color: AppTheme.textPrimary,
              letterSpacing: -0.2,
            ),
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: progress,
              backgroundColor: AppTheme.surfaceBorder,
              valueColor: const AlwaysStoppedAnimation<Color>(AppTheme.accentAmber),
              minHeight: 6,
            ),
          ),
        ],
      ),
    );
  }
}
