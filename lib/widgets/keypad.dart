import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

/// Large, tactile keypad for fast ground scoring.
class ScoringKeypad extends StatelessWidget {
  final Function(int runs) onNormalRun;
  final VoidCallback onWide;
  final VoidCallback onNoBall;
  final VoidCallback onWicket;
  final VoidCallback onUndo;
  final VoidCallback onCustomExtras;
  final VoidCallback onByes;
  final bool canUndo;

  const ScoringKeypad({
    super.key,
    required this.onNormalRun,
    required this.onWide,
    required this.onNoBall,
    required this.onWicket,
    required this.onUndo,
    required this.onCustomExtras,
    required this.onByes,
    required this.canUndo,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Row 1: Common runs (0, 1, 2, 3)
        Row(
          children: [
            _buildButton(
              label: '0',
              subtitle: 'Dot',
              color: AppTheme.surfaceElevated,
              textColor: AppTheme.textPrimary,
              onTap: () => onNormalRun(0),
            ),
            const SizedBox(width: 8),
            _buildButton(
              label: '1',
              subtitle: 'Single',
              color: AppTheme.surfaceElevated,
              textColor: AppTheme.textPrimary,
              onTap: () => onNormalRun(1),
            ),
            const SizedBox(width: 8),
            _buildButton(
              label: '2',
              subtitle: 'Double',
              color: AppTheme.surfaceElevated,
              textColor: AppTheme.textPrimary,
              onTap: () => onNormalRun(2),
            ),
            const SizedBox(width: 8),
            _buildButton(
              label: '3',
              subtitle: 'Triple',
              color: AppTheme.surfaceElevated,
              textColor: AppTheme.textPrimary,
              onTap: () => onNormalRun(3),
            ),
          ],
        ),
        const SizedBox(height: 8),

        // Row 2: Boundaries & Wicket (4, 6, OUT)
        Row(
          children: [
            _buildButton(
              label: '4',
              subtitle: 'FOUR',
              color: AppTheme.primary.withOpacity(0.2),
              borderColor: AppTheme.primary,
              textColor: AppTheme.primary,
              isProminent: true,
              onTap: () => onNormalRun(4),
            ),
            const SizedBox(width: 8),
            _buildButton(
              label: '6',
              subtitle: 'SIX',
              color: AppTheme.accentAmber.withOpacity(0.2),
              borderColor: AppTheme.accentAmber,
              textColor: AppTheme.accentAmber,
              isProminent: true,
              onTap: () => onNormalRun(6),
            ),
            const SizedBox(width: 8),
            Expanded(
              flex: 2,
              child: _buildActionButton(
                label: 'OUT',
                subtitle: 'Wicket',
                icon: Icons.sports_cricket_rounded,
                color: AppTheme.wicketRed,
                textColor: Colors.white,
                onTap: onWicket,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),

        // Row 3: Extras (WD, NB, BYE, +MORE)
        Row(
          children: [
            _buildButton(
              label: 'WD',
              subtitle: '+1 Re-ball',
              color: const Color(0xFFD97706).withOpacity(0.2),
              borderColor: const Color(0xFFD97706),
              textColor: const Color(0xFFFBBF24),
              onTap: onWide,
            ),
            const SizedBox(width: 8),
            _buildButton(
              label: 'NB',
              subtitle: '+1 Re-ball',
              color: const Color(0xFFD97706).withOpacity(0.2),
              borderColor: const Color(0xFFD97706),
              textColor: const Color(0xFFFBBF24),
              onTap: onNoBall,
            ),
            const SizedBox(width: 8),
            _buildButton(
              label: 'BYE',
              subtitle: 'Leg/Bye',
              color: AppTheme.secondary.withOpacity(0.15),
              borderColor: AppTheme.secondary.withOpacity(0.5),
              textColor: AppTheme.secondary,
              onTap: onByes,
            ),
            const SizedBox(width: 8),
            _buildButton(
              label: '+EXTRA',
              subtitle: 'Custom',
              color: AppTheme.surfaceElevated,
              borderColor: AppTheme.surfaceBorder,
              textColor: AppTheme.textSecondary,
              onTap: onCustomExtras,
            ),
          ],
        ),
        const SizedBox(height: 8),

        // Row 4: Undo Action Bar
        SizedBox(
          width: double.infinity,
          height: 48,
          child: OutlinedButton.icon(
            onPressed: canUndo ? onUndo : null,
            icon: const Icon(Icons.undo_rounded, size: 20),
            label: const Text('UNDO LAST BALL'),
            style: OutlinedButton.styleFrom(
              foregroundColor: canUndo ? AppTheme.textPrimary : AppTheme.textMuted,
              backgroundColor: AppTheme.surface,
              side: BorderSide(
                color: canUndo ? AppTheme.surfaceBorder : AppTheme.surfaceBorder.withOpacity(0.4),
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildButton({
    required String label,
    required String subtitle,
    required Color color,
    Color? borderColor,
    required Color textColor,
    required VoidCallback onTap,
    bool isProminent = false,
  }) {
    return Expanded(
      flex: 1,
      child: Material(
        color: color,
        borderRadius: BorderRadius.circular(14),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(14),
          child: Container(
            height: 66,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: borderColor ?? AppTheme.surfaceBorder,
                width: isProminent ? 1.5 : 1.0,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w900,
                    color: textColor,
                    height: 1.0,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color: textColor.withOpacity(0.8),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildActionButton({
    required String label,
    required String subtitle,
    required IconData icon,
    required Color color,
    required Color textColor,
    required VoidCallback onTap,
  }) {
    return Material(
      color: color,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Container(
          height: 66,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            boxShadow: [
              BoxShadow(
                color: color.withOpacity(0.3),
                blurRadius: 8,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: textColor, size: 22),
              const SizedBox(width: 8),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w900,
                      color: textColor,
                      height: 1.0,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      color: textColor.withOpacity(0.9),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
