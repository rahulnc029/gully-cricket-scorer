import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

/// Modal dialog for recording custom extra run combinations.
class ExtrasDialog extends StatefulWidget {
  final Function({
    required int runs,
    required bool isWide,
    required bool isNoBall,
    required bool isBye,
    required bool isLegBye,
  }) onConfirm;

  const ExtrasDialog({super.key, required this.onConfirm});

  @override
  State<ExtrasDialog> createState() => _ExtrasDialogState();
}

class _ExtrasDialogState extends State<ExtrasDialog> {
  String _extraType = 'Wide'; // Wide, NoBall, Bye, LegBye
  int _additionalRuns = 0; // Additional runs made by running / boundary

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
                    color: AppTheme.accentAmber.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(Icons.add_circle_outline_rounded, color: AppTheme.accentAmber),
                ),
                const SizedBox(width: 12),
                const Text(
                  'Custom Extras',
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
              'Extra Type:',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppTheme.textSecondary,
              ),
            ),
            const SizedBox(height: 8),

            // Extra type choices
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: ['Wide', 'No Ball', 'Bye', 'Leg Bye'].map((type) {
                final isSelected = _extraType == type;
                return ChoiceChip(
                  label: Text(type),
                  selected: isSelected,
                  selectedColor: AppTheme.accentAmber,
                  backgroundColor: AppTheme.surfaceElevated,
                  labelStyle: TextStyle(
                    color: isSelected ? Colors.black : AppTheme.textPrimary,
                    fontWeight: isSelected ? FontWeight.w800 : FontWeight.w500,
                  ),
                  side: BorderSide(
                    color: isSelected ? AppTheme.accentAmber : AppTheme.surfaceBorder,
                  ),
                  onSelected: (selected) {
                    if (selected) setState(() => _extraType = type);
                  },
                );
              }).toList(),
            ),

            const SizedBox(height: 16),
            const Text(
              'Additional Runs (off bat / running):',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppTheme.textSecondary,
              ),
            ),
            const SizedBox(height: 8),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [0, 1, 2, 3, 4, 6].map((r) {
                final isSelected = _additionalRuns == r;
                return InkWell(
                  onTap: () => setState(() => _additionalRuns = r),
                  borderRadius: BorderRadius.circular(8),
                  child: Container(
                    width: 40,
                    height: 40,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: isSelected ? AppTheme.primary : AppTheme.surfaceElevated,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: isSelected ? AppTheme.primary : AppTheme.surfaceBorder,
                      ),
                    ),
                    child: Text(
                      '+$r',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w800,
                        color: isSelected ? Colors.black : AppTheme.textPrimary,
                      ),
                    ),
                  ),
                );
              }).toList(),
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
                      widget.onConfirm(
                        runs: _additionalRuns,
                        isWide: _extraType == 'Wide',
                        isNoBall: _extraType == 'No Ball',
                        isBye: _extraType == 'Bye',
                        isLegBye: _extraType == 'Leg Bye',
                      );
                      Navigator.of(context).pop();
                    },
                    child: const Text('Record Extra'),
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
