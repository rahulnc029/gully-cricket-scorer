import 'package:flutter/material.dart';
import '../models/ball_event.dart';
import '../models/innings.dart';
import '../theme/app_theme.dart';

/// Horizontal pill strip showing recent deliveries of the current over.
class OverTimeline extends StatelessWidget {
  final Innings innings;

  const OverTimeline({super.key, required this.innings});

  @override
  Widget build(BuildContext context) {
    final currentBalls = innings.currentOverBalls;
    final totalOverRuns = currentBalls.fold(0, (sum, b) => sum + b.totalRuns);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.surfaceBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'THIS OVER',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w800,
                  color: AppTheme.textSecondary,
                  letterSpacing: 1.0,
                ),
              ),
              Text(
                '$totalOverRuns Runs',
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          if (currentBalls.isEmpty)
            Container(
              alignment: Alignment.centerLeft,
              height: 38,
              child: const Text(
                'Over ready to start...',
                style: TextStyle(
                  fontSize: 14,
                  fontStyle: FontStyle.italic,
                  color: AppTheme.textMuted,
                ),
              ),
            )
          else
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              reverse: true,
              child: Row(
                children: currentBalls.map((ball) => _buildBallPill(ball)).toList(),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildBallPill(BallEvent ball) {
    Color bg = AppTheme.surfaceElevated;
    Color fg = AppTheme.textPrimary;
    Border? border;

    if (ball.isWicket) {
      bg = AppTheme.wicketRed;
      fg = Colors.white;
    } else if (ball.runsScored == 6 && !ball.isWide && !ball.isNoBall) {
      bg = AppTheme.accentAmber;
      fg = Colors.black;
    } else if (ball.runsScored == 4 && !ball.isWide && !ball.isNoBall) {
      bg = AppTheme.primary;
      fg = Colors.black;
    } else if (ball.isWide || ball.isNoBall) {
      bg = const Color(0xFFD97706); // Darker amber
      fg = Colors.white;
    } else if (ball.isBye || ball.isLegBye) {
      bg = AppTheme.secondary;
      fg = Colors.black;
    } else if (ball.runsScored == 0) {
      bg = const Color(0xFF1E293B);
      border = Border.all(color: AppTheme.surfaceBorder);
      fg = AppTheme.textMuted;
    }

    return Container(
      margin: const EdgeInsets.only(right: 8),
      constraints: const BoxConstraints(minWidth: 38, minHeight: 38),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(10),
        border: border,
      ),
      alignment: Alignment.center,
      child: Text(
        ball.displayTag,
        style: TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w900,
          color: fg,
        ),
      ),
    );
  }
}
