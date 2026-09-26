import 'package:flutter/material.dart';
import '../models/app_state.dart';
import '../theme/hdfc_theme.dart';
import '../widgets/charts.dart';
import 'add_holding_screen.dart';
import 'main_navigation_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _selectedPeriod = '1Y';

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: AppState(),
      builder: (context, _) {
        final state = AppState();
        final holdings = state.visibleHoldings;
        final personalAssets = state.totalPersonalAssets;
        final familyAssets = state.totalFamilyAssets;

        return Scaffold(
          backgroundColor: HdfcColors.bg,
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            titleSpacing: 16,
            title: Row(
              children: [
                const HdfcLogoWidget(size: 24),
                const SizedBox(width: 8),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      'HDFC BANK',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 1.1,
                        color: HdfcColors.deepNavy,
                      ),
                    ),
                    Text(
                      'FAMILY ASSET TRACKER',
                      style: TextStyle(
                        fontSize: 9,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.6,
                        color: HdfcColors.red,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            actions: [
              Container(
                margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: HdfcColors.lightGold,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: HdfcColors.gold.withValues(alpha: 0.4)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    Icon(Icons.workspace_premium, size: 14, color: HdfcColors.gold),
                    SizedBox(width: 4),
                    Text(
                      'IMPERIA',
                      style: TextStyle(fontSize: 10, fontWeight: FontWeight.w800, color: HdfcColors.gold),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
            ],
          ),
          body: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Greeting & Add Holding row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 42,
                            height: 42,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: HdfcColors.navy.withValues(alpha: 0.1),
                              border: Border.all(color: HdfcColors.navy.withValues(alpha: 0.3)),
                            ),
                            child: const Icon(Icons.person, color: HdfcColors.navy, size: 24),
                          ),
                          const SizedBox(width: 10),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Good Morning!',
                                style: TextStyle(fontSize: 12, color: HdfcColors.textMuted, fontWeight: FontWeight.w500),
                              ),
                              Text(
                                state.userName,
                                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: HdfcColors.textDark),
                              ),
                            ],
                          ),
                        ],
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => const AddHoldingScreen()),
                          );
                        },
                        borderRadius: BorderRadius.circular(24),
                        child: Container(
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [HdfcColors.navy, HdfcColors.deepNavy],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: HdfcColors.navy.withValues(alpha: 0.3),
                                blurRadius: 8,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                          child: const Icon(Icons.add, color: Colors.white, size: 24),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Consolidated Family Wealth Card
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [HdfcColors.navy, HdfcColors.deepNavy],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: HdfcColors.navy.withValues(alpha: 0.25),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: const [
                                Icon(Icons.family_restroom, size: 16, color: Colors.white70),
                                SizedBox(width: 6),
                                Text(
                                  'Consolidated Family Net Worth',
                                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Colors.white70),
                                ),
                              ],
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.15),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                '${state.familyMembers.where((m) => m.isVisible).length + 1} Visible',
                                style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: Colors.white),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              _formatCr(familyAssets),
                              style: const TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.w800,
                                letterSpacing: -0.5,
                                color: Colors.white,
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.2),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(Icons.trending_up, size: 14, color: HdfcColors.green),
                                  const SizedBox(width: 4),
                                  Text(
                                    '${state.visibleHoldings.length} Assets',
                                    style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.white),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        const Text(
                          'Aggregated across all active family members in real-time',
                          style: TextStyle(fontSize: 11, color: Colors.white60),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 14),

                  // Total Personal Assets Card
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(18),
                    decoration: HdfcStyles.cardDecoration,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                const Text(
                                  'My Personal Assets',
                                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: HdfcColors.textMuted),
                                ),
                                const SizedBox(width: 5),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFF1F5F9),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Text(
                                    state.userName,
                                    style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: HdfcColors.navy),
                                  ),
                                ),
                              ],
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                              decoration: BoxDecoration(
                                color: const Color(0xFFF1F5F9),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: const Text(
                                'A/c: ****4892',
                                style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: HdfcColors.textMuted),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              _formatCr(personalAssets),
                              style: const TextStyle(
                                fontSize: 26,
                                fontWeight: FontWeight.w800,
                                letterSpacing: -0.5,
                                color: HdfcColors.textDark,
                              ),
                            ),
                            Builder(
                              builder: (_) {
                                final myHoldings = state.holdings.where((h) => AppState.isOwnerMatch(h.owner, state.userName)).toList();
                                final myInvested = myHoldings.fold(0.0, (acc, h) => acc + (h.purchasePrice * h.quantity));
                                final myGainPct = myInvested > 0 ? ((personalAssets - myInvested) / myInvested * 100) : 4.5;
                                final isPos = myGainPct >= 0;
                                return Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: isPos ? HdfcColors.greenBg : HdfcColors.lightRed,
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(isPos ? Icons.arrow_drop_up : Icons.arrow_drop_down, size: 16, color: isPos ? HdfcColors.green : HdfcColors.red),
                                      Text(
                                        '${isPos ? '+' : ''}${myGainPct.toStringAsFixed(1)}% ',
                                        style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: isPos ? HdfcColors.green : HdfcColors.red),
                                      ),
                                      Text(
                                        'vs invested',
                                        style: TextStyle(fontSize: 10, color: isPos ? HdfcColors.green : HdfcColors.red),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                        const SizedBox(height: 14),
                        const SmoothLineChart(height: 65, color: HdfcColors.navy),
                        const SizedBox(height: 12),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: ['1M', '3M', '6M', '1Y', 'ALL'].map((period) {
                            final isSel = period == _selectedPeriod;
                            return InkWell(
                              onTap: () => setState(() => _selectedPeriod = period),
                              borderRadius: BorderRadius.circular(6),
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                                decoration: BoxDecoration(
                                  color: isSel ? HdfcColors.navy : const Color(0xFFF8FAFC),
                                  borderRadius: BorderRadius.circular(6),
                                  border: Border.all(
                                    color: isSel ? HdfcColors.navy : HdfcColors.border,
                                    width: 1,
                                  ),
                                ),
                                child: Text(
                                  period,
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: isSel ? FontWeight.w700 : FontWeight.w500,
                                    color: isSel ? Colors.white : HdfcColors.textMuted,
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Indian Banking Quick Service Highlights (Dynamic Values)
                  Row(
                    children: [
                      Expanded(
                        child: _buildQuickBadge(
                          icon: Icons.account_balance_wallet_outlined,
                          title: _formatCr(familyAssets),
                          subtitle: 'Family Net Worth',
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: _buildQuickBadge(
                          icon: Icons.pie_chart_outline,
                          title: '${state.visibleHoldings.length} Assets',
                          subtitle: 'Active Portfolio',
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: _buildQuickBadge(
                          icon: Icons.group_outlined,
                          title: '${state.familyMembers.where((m) => m.isVisible).length + 1} Members',
                          subtitle: 'Visible Circle',
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Real-time Calculated Asset Allocation Card
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(18),
                    decoration: HdfcStyles.cardDecoration,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Asset Allocation',
                              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: HdfcColors.textDark),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                              decoration: BoxDecoration(
                                color: const Color(0xFFF1F5F9),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                '${state.categoryPercentages.length} Categories',
                                style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: HdfcColors.navy),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            DonutChartWidget(
                              size: 115,
                              data: state.categoryPercentages.isEmpty ? {'Equity': 100} : state.categoryPercentages,
                              colors: const {
                                'Equity': HdfcColors.navy,
                                'Mutual Fund': Color(0xFF7C3AED),
                                'Real Estate': Color(0xFF10B981),
                                'Gold': Color(0xFFD4AF37),
                                'Crypto': Color(0xFFF59E0B),
                                'Other': Color(0xFF64748B),
                              },
                            ),
                            const SizedBox(width: 20),
                            Expanded(
                              child: Column(
                                children: state.categoryPercentages.entries.map((e) {
                                  final color = const {
                                    'Equity': HdfcColors.navy,
                                    'Mutual Fund': Color(0xFF7C3AED),
                                    'Real Estate': Color(0xFF10B981),
                                    'Gold': Color(0xFFD4AF37),
                                    'Crypto': Color(0xFFF59E0B),
                                    'Other': Color(0xFF64748B),
                                  }[e.key] ?? Colors.grey;
                                  return Padding(
                                    padding: const EdgeInsets.only(bottom: 6.0),
                                    child: _LegendRow(
                                      color: color,
                                      label: e.key,
                                      pct: '${e.value.toStringAsFixed(1)}%',
                                    ),
                                  );
                                }).toList(),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Recent Holdings
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Recent Holdings',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: HdfcColors.textDark),
                      ),
                      TextButton(
                        onPressed: () => MainNavigationScreen.switchTab(context, 1),
                        style: TextButton.styleFrom(padding: EdgeInsets.zero),
                        child: Row(
                          children: const [
                            Text(
                              'View All',
                              style: TextStyle(color: HdfcColors.navy, fontWeight: FontWeight.w700, fontSize: 13),
                            ),
                            SizedBox(width: 2),
                            Icon(Icons.arrow_forward_ios, size: 10, color: HdfcColors.navy),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Material(
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                      side: const BorderSide(color: HdfcColors.border),
                    ),
                    child: ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: holdings.take(3).length,
                      separatorBuilder: (_, index) => const Divider(height: 1, color: HdfcColors.borderLight),
                      itemBuilder: (ctx, i) {
                        final h = holdings[i];
                        return ListTile(
                          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                          leading: Container(
                            width: 42,
                            height: 42,
                            decoration: BoxDecoration(
                              color: const Color(0xFFF1F5F9),
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: HdfcColors.borderLight),
                            ),
                            child: Icon(_getIconForType(h.type), color: HdfcColors.navy, size: 20),
                          ),
                          title: Text(
                            h.name,
                            style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14, color: HdfcColors.textDark),
                          ),
                          subtitle: Text(
                            '${h.type} • ${h.owner}',
                            style: const TextStyle(fontSize: 12, color: HdfcColors.textMuted),
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                '₹${_formatCurrency(h.totalValue)}',
                                style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14, color: HdfcColors.textDark),
                              ),
                              PopupMenuButton<String>(
                                icon: const Icon(Icons.more_horiz, color: HdfcColors.textSubtle, size: 18),
                                onSelected: (val) {
                                  if (val == 'delete') state.removeHolding(h.id);
                                },
                                itemBuilder: (ctx) => [
                                  const PopupMenuItem(value: 'delete', child: Text('Delete', style: TextStyle(color: Colors.red))),
                                ],
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildQuickBadge({required IconData icon, required String title, required String subtitle}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: HdfcColors.border),
      ),
      child: Row(
        children: [
          Icon(icon, size: 18, color: HdfcColors.navy),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: HdfcColors.textDark)),
                Text(subtitle, style: const TextStyle(fontSize: 9, color: HdfcColors.textMuted)),
              ],
            ),
          ),
        ],
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

  String _formatCr(double val) {
    if (val >= 10000000) {
      final cr = val / 10000000;
      return '₹${cr.toStringAsFixed(2)} Cr';
    } else if (val >= 100000) {
      final l = val / 100000;
      return '₹${l.toStringAsFixed(2)} L';
    }
    return '₹${_formatCurrency(val)}';
  }

  String _formatCurrency(double val) {
    return val.toStringAsFixed(0).replaceAllMapped(
          RegExp(r'(\d+?)(?=(\d\d)+(\d)(?!\d))(\.\d+)?'),
          (Match m) => '${m[1]},',
        );
  }
}

class _LegendRow extends StatelessWidget {
  final Color color;
  final String label;
  final String pct;

  const _LegendRow({required this.color, required this.label, required this.pct});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 9,
          height: 9,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            label,
            style: const TextStyle(fontSize: 12, color: HdfcColors.textMuted, fontWeight: FontWeight.w500),
          ),
        ),
        Text(
          pct,
          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: HdfcColors.textDark),
        ),
      ],
    );
  }
}
