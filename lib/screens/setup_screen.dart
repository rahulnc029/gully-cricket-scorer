import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/match_config.dart';
import '../providers/match_provider.dart';
import '../theme/app_theme.dart';
import 'history_screen.dart';
import 'live_scoring_screen.dart';

/// Screen for quick weekend match setup (Overs, Wickets, Toss).
class SetupScreen extends StatefulWidget {
  const SetupScreen({super.key});

  @override
  State<SetupScreen> createState() => _SetupScreenState();
}

class _SetupScreenState extends State<SetupScreen> {
  final TextEditingController _teamAController = TextEditingController(text: 'Team A');
  final TextEditingController _teamBController = TextEditingController(text: 'Team B');

  int _selectedOvers = 6;
  int _maxWickets = 10;
  String _battingFirst = 'Team A';

  final List<int> _presetOvers = [4, 6, 8, 10, 12, 15, 20];
  final List<int> _presetWickets = [3, 4, 5, 8, 10];

  @override
  void dispose() {
    _teamAController.dispose();
    _teamBController.dispose();
    super.dispose();
  }

  void _startMatch() {
    final teamA = _teamAController.text.trim().isEmpty ? 'Team A' : _teamAController.text.trim();
    final teamB = _teamBController.text.trim().isEmpty ? 'Team B' : _teamBController.text.trim();

    final config = MatchConfig(
      teamAName: teamA,
      teamBName: teamB,
      totalOvers: _selectedOvers,
      maxWickets: _maxWickets,
      battingFirstTeam: _battingFirst == 'Team A' ? teamA : teamB,
      reballOnWide: true,
      reballOnNoBall: true,
    );

    context.read<MatchProvider>().startNewMatch(config);

    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const LiveScoringScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gully Cricket Scorer'),
        actions: [
          IconButton(
            icon: const Icon(Icons.history_rounded),
            tooltip: 'Match History & Data Settings',
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const HistoryScreen()),
              );
            },
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Header Card
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppTheme.primaryDark.withOpacity(0.4),
                      AppTheme.surfaceElevated,
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppTheme.primary.withOpacity(0.3)),
                ),
                child: Row(
                  children: [
                    const Text('🏏', style: TextStyle(fontSize: 32)),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text(
                            'Quick Match Setup',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w800,
                              color: AppTheme.textPrimary,
                            ),
                          ),
                          SizedBox(height: 2),
                          Text(
                            'Configure overs, players count & start scoring',
                            style: TextStyle(
                              fontSize: 13,
                              color: AppTheme.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // Team Names Card
              _buildSectionCard(
                title: 'Team Names',
                icon: Icons.groups_rounded,
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _teamAController,
                        decoration: const InputDecoration(
                          labelText: 'Team 1',
                          prefixIcon: Icon(Icons.shield_outlined, size: 20),
                        ),
                        onChanged: (val) {
                          if (_battingFirst == 'Team A') setState(() {});
                        },
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: TextField(
                        controller: _teamBController,
                        decoration: const InputDecoration(
                          labelText: 'Team 2',
                          prefixIcon: Icon(Icons.shield_outlined, size: 20),
                        ),
                        onChanged: (val) {
                          if (_battingFirst == 'Team B') setState(() {});
                        },
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // Total Overs Selection
              _buildSectionCard(
                title: 'Total Overs per Innings',
                icon: Icons.timer_outlined,
                trailing: Text(
                  '$_selectedOvers Overs',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: AppTheme.primary,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: _presetOvers.map((overs) {
                        final isSelected = _selectedOvers == overs;
                        return ChoiceChip(
                          label: Text('$overs Overs'),
                          selected: isSelected,
                          selectedColor: AppTheme.primary,
                          backgroundColor: AppTheme.surfaceElevated,
                          labelStyle: TextStyle(
                            color: isSelected ? Colors.black : AppTheme.textPrimary,
                            fontWeight: isSelected ? FontWeight.w800 : FontWeight.w500,
                          ),
                          onSelected: (selected) {
                            if (selected) setState(() => _selectedOvers = overs);
                          },
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        const Text(
                          'Custom Overs: ',
                          style: TextStyle(fontSize: 13, color: AppTheme.textMuted),
                        ),
                        IconButton.filledTonal(
                          icon: const Icon(Icons.remove, size: 18),
                          onPressed: _selectedOvers > 1
                              ? () => setState(() => _selectedOvers--)
                              : null,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          child: Text(
                            '$_selectedOvers',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w800,
                              color: AppTheme.textPrimary,
                            ),
                          ),
                        ),
                        IconButton.filledTonal(
                          icon: const Icon(Icons.add, size: 18),
                          onPressed: _selectedOvers < 50
                              ? () => setState(() => _selectedOvers++)
                              : null,
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // Total Wickets / Player Headcount
              _buildSectionCard(
                title: 'Max Wickets (Player Count)',
                icon: Icons.sports_cricket_rounded,
                trailing: Text(
                  '$_maxWickets Wkts',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: AppTheme.accentAmber,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: _presetWickets.map((w) {
                        final isSelected = _maxWickets == w;
                        String sub = '';
                        if (w == 3) sub = ' (4P)';
                        if (w == 4) sub = ' (5P)';
                        if (w == 10) sub = ' (11P)';

                        return ChoiceChip(
                          label: Text('$w Wkts$sub'),
                          selected: isSelected,
                          selectedColor: AppTheme.accentAmber,
                          backgroundColor: AppTheme.surfaceElevated,
                          labelStyle: TextStyle(
                            color: isSelected ? Colors.black : AppTheme.textPrimary,
                            fontWeight: isSelected ? FontWeight.w800 : FontWeight.w500,
                          ),
                          onSelected: (selected) {
                            if (selected) setState(() => _maxWickets = w);
                          },
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        const Text(
                          'Custom Wickets: ',
                          style: TextStyle(fontSize: 13, color: AppTheme.textMuted),
                        ),
                        IconButton.filledTonal(
                          icon: const Icon(Icons.remove, size: 18),
                          onPressed: _maxWickets > 1
                              ? () => setState(() => _maxWickets--)
                              : null,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          child: Text(
                            '$_maxWickets',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w800,
                              color: AppTheme.textPrimary,
                            ),
                          ),
                        ),
                        IconButton.filledTonal(
                          icon: const Icon(Icons.add, size: 18),
                          onPressed: _maxWickets < 15
                              ? () => setState(() => _maxWickets++)
                              : null,
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // Batting First (Toss)
              _buildSectionCard(
                title: 'Batting First',
                icon: Icons.compare_arrows_rounded,
                child: Row(
                  children: [
                    Expanded(
                      child: InkWell(
                        onTap: () => setState(() => _battingFirst = 'Team A'),
                        borderRadius: BorderRadius.circular(12),
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          decoration: BoxDecoration(
                            color: _battingFirst == 'Team A'
                                ? AppTheme.primary.withOpacity(0.2)
                                : AppTheme.surfaceElevated,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: _battingFirst == 'Team A'
                                  ? AppTheme.primary
                                  : AppTheme.surfaceBorder,
                              width: 1.5,
                            ),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            _teamAController.text.trim().isEmpty
                                ? 'Team A'
                                : _teamAController.text.trim(),
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w800,
                              color: _battingFirst == 'Team A'
                                  ? AppTheme.primary
                                  : AppTheme.textSecondary,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: InkWell(
                        onTap: () => setState(() => _battingFirst = 'Team B'),
                        borderRadius: BorderRadius.circular(12),
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          decoration: BoxDecoration(
                            color: _battingFirst == 'Team B'
                                ? AppTheme.primary.withOpacity(0.2)
                                : AppTheme.surfaceElevated,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: _battingFirst == 'Team B'
                                  ? AppTheme.primary
                                  : AppTheme.surfaceBorder,
                              width: 1.5,
                            ),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            _teamBController.text.trim().isEmpty
                                ? 'Team B'
                                : _teamBController.text.trim(),
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w800,
                              color: _battingFirst == 'Team B'
                                  ? AppTheme.primary
                                  : AppTheme.textSecondary,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 28),

              // Start Match CTA Button
              SizedBox(
                height: 56,
                child: ElevatedButton(
                  onPressed: _startMatch,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primary,
                    foregroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 4,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(Icons.play_arrow_rounded, size: 28),
                      SizedBox(width: 8),
                      Text(
                        'START MATCH',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionCard({
    required String title,
    required IconData icon,
    Widget? trailing,
    required Widget child,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.surfaceBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(icon, size: 20, color: AppTheme.secondary),
                  const SizedBox(width: 8),
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: AppTheme.textPrimary,
                    ),
                  ),
                ],
              ),
              if (trailing != null) trailing,
            ],
          ),
          const SizedBox(height: 14),
          child,
        ],
      ),
    );
  }
}
