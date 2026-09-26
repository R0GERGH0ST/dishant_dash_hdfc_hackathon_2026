import 'package:flutter/material.dart';
import '../models/app_state.dart';
import '../theme/hdfc_theme.dart';

class AssetTypesScreen extends StatelessWidget {
  const AssetTypesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: AppState(),
      builder: (context, _) {
        final state = AppState();
        final types = [
          {'name': 'Crypto', 'icon': Icons.currency_bitcoin_rounded, 'color': const Color(0xFFF59E0B)},
          {'name': 'Equity', 'icon': Icons.bar_chart_rounded, 'color': HdfcColors.navy},
          {'name': 'Real Estate', 'icon': Icons.home_work_outlined, 'color': const Color(0xFF10B981)},
          {'name': 'Gold', 'icon': Icons.grid_view_rounded, 'color': const Color(0xFFD4AF37)},
          {'name': 'Mutual Fund', 'icon': Icons.pie_chart_outline_rounded, 'color': const Color(0xFF7C3AED)},
          {'name': 'Other', 'icon': Icons.more_horiz_rounded, 'color': HdfcColors.textMuted},
        ];

        return Scaffold(
          backgroundColor: HdfcColors.bg,
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new, size: 18, color: HdfcColors.navy),
              onPressed: () => Navigator.pop(context),
            ),
            title: Row(
              mainAxisSize: MainAxisSize.min,
              children: const [
                HdfcLogoWidget(size: 16),
                SizedBox(width: 8),
                Text(
                  'Asset Types',
                  style: TextStyle(color: HdfcColors.textDark, fontSize: 17, fontWeight: FontWeight.w700),
                ),
              ],
            ),
            centerTitle: true,
            actions: [
              IconButton(
                icon: const Icon(Icons.add, color: HdfcColors.navy),
                onPressed: () {
                  _showAddTypeDialog(context);
                },
              ),
            ],
          ),
          body: SafeArea(
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              itemCount: types.length,
              separatorBuilder: (_, index) => const SizedBox(height: 10),
              itemBuilder: (ctx, i) {
                final t = types[i];
                final typeName = t['name'] as String;
                final typeHoldings = state.visibleHoldings.where((h) => h.type == typeName).toList();
                final typeVal = state.categoryTotals[typeName] ?? 0.0;
                final valStr = typeVal >= 100000
                    ? '₹${(typeVal / 100000).toStringAsFixed(2)} L'
                    : '₹${typeVal.toStringAsFixed(0)}';

                return Material(
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: const BorderSide(color: HdfcColors.border),
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
                    leading: Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: (t['color'] as Color).withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(t['icon'] as IconData, color: t['color'] as Color, size: 22),
                    ),
                    title: Text(
                      typeName,
                      style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 15, color: HdfcColors.textDark),
                    ),
                    subtitle: Text(
                      '${typeHoldings.length} active holdings • $valStr',
                      style: const TextStyle(fontSize: 12, color: HdfcColors.textMuted),
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(valStr, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: HdfcColors.navy)),
                        const SizedBox(width: 6),
                        const Icon(Icons.arrow_forward_ios, size: 14, color: HdfcColors.textSubtle),
                      ],
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => AssetItemListScreen(assetType: typeName)),
                      );
                    },
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }

  void _showAddTypeDialog(BuildContext context) {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Add Asset Type', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(hintText: 'Enter asset type name'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel', style: TextStyle(color: HdfcColors.textMuted)),
          ),
          ElevatedButton(
            onPressed: () {
              if (controller.text.trim().isNotEmpty) {
                AppState().addAssetType(controller.text.trim());
              }
              Navigator.pop(ctx);
            },
            style: ElevatedButton.styleFrom(backgroundColor: HdfcColors.navy),
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }
}

class AssetItemListScreen extends StatefulWidget {
  final String assetType;
  const AssetItemListScreen({super.key, required this.assetType});

  @override
  State<AssetItemListScreen> createState() => _AssetItemListScreenState();
}

class _AssetItemListScreenState extends State<AssetItemListScreen> {
  final _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: AppState(),
      builder: (context, _) {
        final state = AppState();
        final allItems = state.assetItems[widget.assetType] ?? [];
        final items = allItems.where((item) {
          final query = _searchQuery.toLowerCase();
          return item.name.toLowerCase().contains(query) || item.symbol.toLowerCase().contains(query);
        }).toList();

        return Scaffold(
          backgroundColor: HdfcColors.bg,
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new, size: 18, color: HdfcColors.navy),
              onPressed: () => Navigator.pop(context),
            ),
            title: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const HdfcLogoWidget(size: 16),
                const SizedBox(width: 8),
                Text(
                  widget.assetType,
                  style: const TextStyle(color: HdfcColors.textDark, fontSize: 17, fontWeight: FontWeight.w700),
                ),
              ],
            ),
            centerTitle: true,
            actions: [
              IconButton(
                icon: const Icon(Icons.add, color: HdfcColors.navy),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => AddAssetItemScreen(assetType: widget.assetType),
                    ),
                  );
                },
              ),
            ],
          ),
          body: SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: HdfcColors.border),
                    ),
                    child: TextField(
                      controller: _searchController,
                      onChanged: (val) => setState(() => _searchQuery = val),
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.search, size: 20, color: HdfcColors.textMuted),
                        hintText: 'Search ${widget.assetType.toLowerCase()} items',
                        hintStyle: const TextStyle(fontSize: 14, color: HdfcColors.textSubtle),
                        border: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: items.isEmpty
                      ? Center(
                          child: Text(
                            'No ${widget.assetType} items found',
                            style: const TextStyle(color: HdfcColors.textMuted),
                          ),
                        )
                      : ListView.separated(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                          itemCount: items.length,
                          separatorBuilder: (_, index) => const SizedBox(height: 8),
                          itemBuilder: (ctx, i) {
                            final item = items[i];
                            return Material(
                              color: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                                side: const BorderSide(color: HdfcColors.border),
                              ),
                              child: ListTile(
                                contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
                                leading: Container(
                                  width: 42,
                                  height: 42,
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFF1F5F9),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Icon(item.icon, color: item.color, size: 22),
                                ),
                                title: Text(
                                  item.symbol,
                                  style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14, color: HdfcColors.textDark),
                                ),
                                subtitle: Text(
                                  item.name,
                                  style: const TextStyle(fontSize: 12, color: HdfcColors.textMuted),
                                ),
                                trailing: const Icon(Icons.more_horiz, size: 18, color: HdfcColors.textSubtle),
                              ),
                            );
                          },
                        ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class AddAssetItemScreen extends StatefulWidget {
  final String assetType;
  const AddAssetItemScreen({super.key, required this.assetType});

  @override
  State<AddAssetItemScreen> createState() => _AddAssetItemScreenState();
}

class _AddAssetItemScreenState extends State<AddAssetItemScreen> {
  final _nameController = TextEditingController(text: 'HDFC Bank');
  final _symbolController = TextEditingController(text: 'HDFCBANK');
  int _selectedIconIndex = 0;

  final List<Map<String, dynamic>> _iconChoices = [
    {'icon': Icons.bar_chart_rounded, 'color': HdfcColors.navy},
    {'icon': Icons.account_balance, 'color': Colors.blueGrey},
    {'icon': Icons.shield_outlined, 'color': HdfcColors.red},
    {'icon': Icons.more_horiz, 'color': Colors.grey},
  ];

  @override
  void dispose() {
    _nameController.dispose();
    _symbolController.dispose();
    super.dispose();
  }

  void _onSave() {
    final name = _nameController.text.trim();
    if (name.isEmpty) return;
    final symbol = _symbolController.text.trim().isNotEmpty
        ? _symbolController.text.trim()
        : name.toUpperCase();

    final chosen = _iconChoices[_selectedIconIndex];
    final newItem = AssetItem(
      name: name,
      symbol: symbol,
      icon: chosen['icon'] as IconData,
      color: chosen['color'] as Color,
    );

    AppState().addAssetItem(widget.assetType, newItem);

    showModalBottomSheet(
      context: context,
      isDismissible: false,
      enableDrag: false,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      backgroundColor: Colors.white,
      builder: (ctx) {
        return Padding(
          padding: const EdgeInsets.fromLTRB(24, 20, 24, 32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 24),
              Container(
                width: 68,
                height: 68,
                decoration: BoxDecoration(
                  color: HdfcColors.greenBg,
                  shape: BoxShape.circle,
                  border: Border.all(color: HdfcColors.green.withValues(alpha: 0.3), width: 2),
                ),
                child: const Icon(Icons.check, color: HdfcColors.green, size: 38),
              ),
              const SizedBox(height: 20),
              const Text(
                'Item Added Successfully!',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold, color: HdfcColors.textDark),
              ),
              const SizedBox(height: 8),
              Text(
                '$name has been added under ${widget.assetType}.',
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 14, color: HdfcColors.textMuted),
              ),
              const SizedBox(height: 28),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(ctx); // close bottom sheet
                    Navigator.pop(context); // back to equity items
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: HdfcColors.navy,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  child: const Text('Done', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 18, color: HdfcColors.navy),
          onPressed: () => Navigator.pop(context),
        ),
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: const [
            HdfcLogoWidget(size: 16),
            SizedBox(width: 8),
            Text(
              'Add Item',
              style: TextStyle(color: HdfcColors.textDark, fontSize: 17, fontWeight: FontWeight.w700),
            ),
          ],
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Asset Type', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: HdfcColors.textDark)),
              const SizedBox(height: 6),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                decoration: BoxDecoration(
                  color: const Color(0xFFF1F5F9),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: HdfcColors.border),
                ),
                child: Text(
                  widget.assetType,
                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: HdfcColors.textDark),
                ),
              ),
              const SizedBox(height: 18),
              const Text('Item Name', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: HdfcColors.textDark)),
              const SizedBox(height: 6),
              TextField(
                controller: _nameController,
                decoration: const InputDecoration(
                  hintText: 'e.g. HDFC Bank',
                ),
              ),
              const SizedBox(height: 18),
              const Text('Symbol (optional)', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: HdfcColors.textDark)),
              const SizedBox(height: 6),
              TextField(
                controller: _symbolController,
                decoration: const InputDecoration(
                  hintText: 'e.g. HDFCBANK',
                ),
              ),
              const SizedBox(height: 18),
              const Text('Icon (optional)', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: HdfcColors.textDark)),
              const SizedBox(height: 8),
              Row(
                children: List.generate(_iconChoices.length, (i) {
                  final isSelected = _selectedIconIndex == i;
                  final item = _iconChoices[i];
                  return InkWell(
                    onTap: () => setState(() => _selectedIconIndex = i),
                    borderRadius: BorderRadius.circular(10),
                    child: Container(
                      margin: const EdgeInsets.only(right: 12),
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: isSelected ? const Color(0xFFEFF6FF) : const Color(0xFFF8FAFC),
                        border: Border.all(
                          color: isSelected ? HdfcColors.navy : HdfcColors.border,
                          width: isSelected ? 2 : 1,
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(item['icon'] as IconData, color: item['color'] as Color, size: 24),
                    ),
                  );
                }),
              ),
              const SizedBox(height: 36),
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: _onSave,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: HdfcColors.navy,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  child: const Text('Save', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
