import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

/// Modal dialog for recording a wicket with dismissal type and optional runs.
class WicketDialog extends StatefulWidget {
  final Function(String wicketType, int runsCompleted) onConfirm;

  const WicketDialog({super.key, required this.onConfirm});

  @override
  State<WicketDialog> createState() => _WicketDialogState();
}

class _WicketDialogState extends State<WicketDialog> {
  String _selectedType = 'Bowled';
  int _runsCompleted = 0;

  final List<String> _types = [
    'Bowled',
    'Caught',
    'Run Out',
    'Stumped',
    'LBW',
    'Hit Wicket',
  ];

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
                    color: AppTheme.wicketRed.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(Icons.sports_cricket_rounded, color: AppTheme.wicketRed),
                ),
                const SizedBox(width: 12),
                const Text(
                  'Dismissal Type',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: AppTheme.textPrimary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Dismissal types grid
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _types.map((type) {
                final isSelected = _selectedType == type;
                return ChoiceChip(
                  label: Text(type),
                  selected: isSelected,
                  selectedColor: AppTheme.wicketRed,
                  backgroundColor: AppTheme.surfaceElevated,
                  labelStyle: TextStyle(
                    color: isSelected ? Colors.white : AppTheme.textPrimary,
                    fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                  ),
                  side: BorderSide(
                    color: isSelected ? AppTheme.wicketRed : AppTheme.surfaceBorder,
                  ),
                  onSelected: (selected) {
                    if (selected) {
                      setState(() {
                        _selectedType = type;
                        if (type != 'Run Out') _runsCompleted = 0;
                      });
                    }
                  },
                );
              }).toList(),
            ),

            if (_selectedType == 'Run Out') ...[
              const SizedBox(height: 16),
              const Text(
                'Runs completed before Run Out:',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.textSecondary,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [0, 1, 2, 3].map((r) {
                  final isSelected = _runsCompleted == r;
                  return InkWell(
                    onTap: () => setState(() => _runsCompleted = r),
                    borderRadius: BorderRadius.circular(8),
                    child: Container(
                      width: 44,
                      height: 44,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: isSelected ? AppTheme.primary : AppTheme.surfaceElevated,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: isSelected ? AppTheme.primary : AppTheme.surfaceBorder,
                        ),
                      ),
                      child: Text(
                        '$r',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                          color: isSelected ? Colors.black : AppTheme.textPrimary,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ],

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
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.wicketRed,
                      foregroundColor: Colors.white,
                    ),
                    onPressed: () {
                      widget.onConfirm(_selectedType, _runsCompleted);
                      Navigator.of(context).pop();
                    },
                    child: const Text('OUT'),
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
