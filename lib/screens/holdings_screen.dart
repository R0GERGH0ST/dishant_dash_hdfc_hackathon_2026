import 'package:flutter/material.dart';
import '../models/app_state.dart';
import '../theme/hdfc_theme.dart';
import '../widgets/charts.dart';
import 'add_holding_screen.dart';

class HoldingsScreen extends StatefulWidget {
  const HoldingsScreen({super.key});

  @override
  State<HoldingsScreen> createState() => _HoldingsScreenState();
}

class _HoldingsScreenState extends State<HoldingsScreen> {
  String _selectedType = 'All Asset Types';
  String _selectedMember = 'All Members';
  String _selectedTime = 'All Time';

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: AppState(),
      builder: (context, _) {
        final state = AppState();
        var list = state.visibleHoldings;

        final currentSelfName = state.allFamilyProfiles
            .firstWhere(
              (p) => AppState.isOwnerMatch(p['name']!, state.userName),
              orElse: () => {'name': state.userName},
            )['name']!;
        final selfLabel = '$currentSelfName (Self)';

        final memberFilterOptions = [
          'All Members',
          selfLabel,
          ...state.allFamilyProfiles
              .where((p) =>
                  !AppState.isOwnerMatch(p['name']!, state.userName) &&
                  state.canUserSeeMemberHoldings(p['name']!))
              .map((p) => p['name']!)
              .toSet(),
        ];
        if (!memberFilterOptions.contains(_selectedMember)) {
          if (AppState.isOwnerMatch(_selectedMember, state.userName)) {
            _selectedMember = selfLabel;
          } else {
            _selectedMember = 'All Members';
          }
        }

        if (_selectedType != 'All Asset Types') {
          list = list.where((h) => h.type == _selectedType).toList();
        }
        if (_selectedMember != 'All Members') {
          list = list.where((h) => AppState.isOwnerMatch(h.owner, _selectedMember)).toList();
        }

        return Scaffold(
          backgroundColor: HdfcColors.bg,
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            automaticallyImplyLeading: false,
            title: Row(
              children: const [
                HdfcLogoWidget(size: 20),
                SizedBox(width: 8),
                Text(
                  'Holding',
                  style: TextStyle(color: HdfcColors.textDark, fontWeight: FontWeight.w800, fontSize: 18),
                ),
              ],
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.add_circle_outline, color: HdfcColors.navy),
                tooltip: 'Add Holding',
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const AddHoldingScreen()),
                  );
                },
              ),
              IconButton(
                icon: const Icon(Icons.file_download_outlined, color: HdfcColors.navy),
                tooltip: 'Export Portfolio',
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Downloading Consolidated Account Statement (CAS)...'),
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                },
              ),
              const SizedBox(width: 6),
            ],
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Filter Dropdowns
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      _buildFilterChip(
                        value: _selectedType,
                        items: ['All Asset Types', 'Equity', 'Real Estate', 'Gold', 'Crypto', 'Mutual Fund', 'Other'],
                        onChanged: (v) => setState(() => _selectedType = v!),
                      ),
                      const SizedBox(width: 8),
                      _buildFilterChip(
                        value: _selectedMember,
                        items: memberFilterOptions,
                        onChanged: (v) => setState(() => _selectedMember = v!),
                      ),
                      const SizedBox(width: 8),
                      _buildFilterChip(
                        value: _selectedTime,
                        items: ['All Time', '1Y', '6M', '1M'],
                        onChanged: (v) => setState(() => _selectedTime = v!),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 18),

                // Holdings Count & Table
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Holdings (${list.length})',
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: HdfcColors.textDark),
                    ),
                    Text(
                      'Consolidated View',
                      style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: HdfcColors.navy),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Container(
                  decoration: HdfcStyles.cardDecoration,
                  child: Column(
                    children: [
                      // Header Row
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16, 12, 16, 10),
                        child: Row(
                          children: const [
                            Expanded(flex: 3, child: Text('Asset Name', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: HdfcColors.textMuted))),
                            Expanded(flex: 2, child: Text('Type', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: HdfcColors.textMuted))),
                            Expanded(flex: 2, child: Text('Owner', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: HdfcColors.textMuted))),
                            SizedBox(width: 32, child: Text('Actions', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: HdfcColors.textMuted))),
                          ],
                        ),
                      ),
                      const Divider(height: 1, color: HdfcColors.borderLight),
                      if (list.isEmpty)
                        const Padding(
                          padding: EdgeInsets.all(28.0),
                          child: Center(
                            child: Text('No holdings found matching filters', style: TextStyle(color: HdfcColors.textMuted)),
                          ),
                        )
                      else
                        ListView.separated(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: list.length,
                          separatorBuilder: (_, index) => const Divider(height: 1, color: HdfcColors.borderLight),
                          itemBuilder: (ctx, i) {
                            final h = list[i];
                            return Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                              child: Row(
                                children: [
                                  Expanded(
                                    flex: 3,
                                    child: Row(
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.all(4),
                                          decoration: BoxDecoration(
                                            color: const Color(0xFFF1F5F9),
                                            borderRadius: BorderRadius.circular(6),
                                          ),
                                          child: Icon(_getIconForType(h.type), size: 16, color: HdfcColors.navy),
                                        ),
                                        const SizedBox(width: 8),
                                        Expanded(
                                          child: Text(
                                            h.name,
                                            style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13, color: HdfcColors.textDark),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                    flex: 2,
                                    child: Text(
                                      h.type,
                                      style: const TextStyle(fontSize: 12, color: HdfcColors.textMuted, fontWeight: FontWeight.w500),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 2,
                                    child: Container(
                                      alignment: Alignment.centerLeft,
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                        decoration: BoxDecoration(
                                          color: const Color(0xFFF1F5F9),
                                          borderRadius: BorderRadius.circular(4),
                                        ),
                                        child: Text(
                                          h.owner,
                                          style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: HdfcColors.textDark),
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 32,
                                    child: PopupMenuButton<String>(
                                      padding: EdgeInsets.zero,
                                      icon: const Icon(Icons.more_horiz, size: 18, color: HdfcColors.textSubtle),
                                      onSelected: (val) {
                                        if (val == 'edit') {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (_) => AddHoldingScreen(initialHolding: h),
                                            ),
                                          );
                                        } else if (val == 'delete') {
                                          state.removeHolding(h.id);
                                          ScaffoldMessenger.of(context).clearSnackBars();
                                          ScaffoldMessenger.of(context).showSnackBar(
                                            SnackBar(
                                              content: Text('${h.name} removed from family holdings!'),
                                              backgroundColor: HdfcColors.red,
                                              behavior: SnackBarBehavior.floating,
                                            ),
                                          );
                                        }
                                      },
                                      itemBuilder: (ctx) => [
                                        const PopupMenuItem(
                                          value: 'edit',
                                          child: Row(
                                            children: [
                                              Icon(Icons.edit_outlined, size: 16, color: HdfcColors.navy),
                                              SizedBox(width: 8),
                                              Text('Edit', style: TextStyle(color: HdfcColors.navy, fontSize: 13, fontWeight: FontWeight.w600)),
                                            ],
                                          ),
                                        ),
                                        const PopupMenuItem(
                                          value: 'delete',
                                          child: Row(
                                            children: [
                                              Icon(Icons.delete_outline, size: 16, color: Colors.red),
                                              SizedBox(width: 8),
                                              Text('Delete', style: TextStyle(color: Colors.red, fontSize: 13, fontWeight: FontWeight.w600)),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // Asset Allocation Multi-line Chart Section
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: HdfcStyles.cardDecoration,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: const [
                              Text(
                                'Asset Allocation',
                                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: HdfcColors.textDark),
                              ),
                              SizedBox(width: 4),
                              Icon(Icons.info_outline, size: 14, color: HdfcColors.textSubtle),
                            ],
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF8FAFC),
                              borderRadius: BorderRadius.circular(6),
                              border: Border.all(color: HdfcColors.border),
                            ),
                            child: Row(
                              children: const [
                                Text('1Y', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: HdfcColors.textDark)),
                                SizedBox(width: 2),
                                Icon(Icons.keyboard_arrow_down, size: 14, color: HdfcColors.textMuted),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),
                      const MultiLineTrendChart(height: 105),
                      const SizedBox(height: 14),
                      Wrap(
                        spacing: 12,
                        runSpacing: 6,
                        children: const [
                          _MiniLegend(color: HdfcColors.navy, label: 'Equity', pct: '50%'),
                          _MiniLegend(color: Color(0xFF10B981), label: 'Real Estate', pct: '16.7%'),
                          _MiniLegend(color: Color(0xFFD4AF37), label: 'Gold', pct: '16.7%'),
                          _MiniLegend(color: Color(0xFF7C3AED), label: 'Crypto', pct: '16.7%'),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // Total Assets Card
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [HdfcColors.deepNavy, HdfcColors.darkBlue],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(14),
                    boxShadow: [
                      BoxShadow(
                        color: HdfcColors.deepNavy.withValues(alpha: 0.25),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Builder(
                    builder: (context) {
                      final filteredTotal = list.fold(0.0, (acc, h) => acc + h.totalValue);
                      final filteredTotalStr = filteredTotal >= 10000000
                          ? '₹${(filteredTotal / 10000000).toStringAsFixed(2)} Cr'
                          : filteredTotal >= 100000
                              ? '₹${(filteredTotal / 100000).toStringAsFixed(2)} L'
                              : '₹${filteredTotal.toStringAsFixed(0)}';
                      final totalFamily = state.totalFamilyAssets;
                      final filteredPctStr = totalFamily > 0
                          ? '${((filteredTotal / totalFamily) * 100).toStringAsFixed(0)}%'
                          : '100%';

                      return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: const [
                                  Text(
                                    'Total Assets',
                                    style: TextStyle(fontSize: 12, color: Color(0xFFCBD5E1), fontWeight: FontWeight.w600),
                                  ),
                                  SizedBox(width: 4),
                                  Icon(Icons.info_outline, size: 13, color: Color(0xFF94A3B8)),
                                ],
                              ),
                              const SizedBox(height: 4),
                              Text(
                                filteredTotalStr,
                                style: const TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.w800,
                                  letterSpacing: -0.5,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
                            ),
                            child: Text(
                              filteredPctStr,
                              style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w800, color: Colors.white),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildFilterChip({
    required String value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: HdfcColors.border),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          icon: const Icon(Icons.keyboard_arrow_down, size: 16, color: HdfcColors.textMuted),
          style: const TextStyle(fontSize: 12, color: HdfcColors.textDark, fontWeight: FontWeight.w600),
          items: items.map((i) => DropdownMenuItem(value: i, child: Text(i))).toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }

  IconData _getIconForType(String type) {
    switch (type) {
      case 'Equity':
        return Icons.bar_chart_rounded;
      case 'Real Estate':
        return Icons.home_work_outlined;
      case 'Gold':
        return Icons.grid_view_rounded;
      case 'Crypto':
        return Icons.currency_bitcoin_rounded;
      case 'Mutual Fund':
        return Icons.pie_chart_outline_rounded;
      default:
        return Icons.attach_money_rounded;
    }
  }
}

class _MiniLegend extends StatelessWidget {
  final Color color;
  final String label;
  final String pct;

  const _MiniLegend({required this.color, required this.label, required this.pct});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 5),
        Text(
          '$label $pct',
          style: const TextStyle(fontSize: 11, color: HdfcColors.textMuted, fontWeight: FontWeight.w600),
        ),
      ],
    );
  }
}
