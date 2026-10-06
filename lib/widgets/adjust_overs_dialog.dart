import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

/// Modal dialog to adjust overs mid-match.
class AdjustOversDialog extends StatefulWidget {
  final int currentTotalOvers;
  final Function(int newOvers) onConfirm;

  const AdjustOversDialog({
    super.key,
    required this.currentTotalOvers,
    required this.onConfirm,
  });

  @override
  State<AdjustOversDialog> createState() => _AdjustOversDialogState();
}

class _AdjustOversDialogState extends State<AdjustOversDialog> {
  late int _overs;

  @override
  void initState() {
    super.initState();
    _overs = widget.currentTotalOvers;
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: AppTheme.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: const BorderSide(color: AppTheme.surfaceBorder),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppTheme.secondary.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(Icons.tune_rounded, color: AppTheme.secondary),
                ),
                const SizedBox(width: 12),
                const Text(
                  'Adjust Match Overs',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: AppTheme.textPrimary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Text(
              'Change total overs for both innings if light is fading or time is limited:',
              style: TextStyle(
                fontSize: 14,
                color: AppTheme.textSecondary,
              ),
            ),
            const SizedBox(height: 20),

            // Stepper controls
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton.filledTonal(
                  onPressed: _overs > 1 ? () => setState(() => _overs--) : null,
                  icon: const Icon(Icons.remove_rounded),
                  iconSize: 28,
                ),
                const SizedBox(width: 24),
                Text(
                  '$_overs',
                  style: const TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.w900,
                    color: AppTheme.textPrimary,
                  ),
                ),
                const SizedBox(width: 8),
                const Text(
                  'Overs',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.textSecondary,
                  ),
                ),
                const SizedBox(width: 24),
                IconButton.filledTonal(
                  onPressed: _overs < 50 ? () => setState(() => _overs++) : null,
                  icon: const Icon(Icons.add_rounded),
                  iconSize: 28,
                ),
              ],
            ),

            const SizedBox(height: 24),

            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('Cancel'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      widget.onConfirm(_overs);
                      Navigator.of(context).pop();
                    },
                    child: const Text('Update Overs'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
