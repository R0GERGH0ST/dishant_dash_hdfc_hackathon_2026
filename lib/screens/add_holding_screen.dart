import 'package:flutter/material.dart';
import '../models/app_state.dart';
import '../theme/hdfc_theme.dart';

class AddHoldingScreen extends StatefulWidget {
  final String? initialOwner;
  final HoldingItem? initialHolding;
  const AddHoldingScreen({super.key, this.initialOwner, this.initialHolding});

  @override
  State<AddHoldingScreen> createState() => _AddHoldingScreenState();
}

class _AddHoldingScreenState extends State<AddHoldingScreen> {
  String _selectedAssetType = 'Equity';
  late final TextEditingController _nameController;
  late final TextEditingController _symbolController;
  late final TextEditingController _qtyController;
  late final TextEditingController _priceController;
  bool _isBuy = true;
  late String _selectedOwner;
  DateTime _purchaseDate = DateTime(2024, 8, 12);

  @override
  void initState() {
    super.initState();
    final h = widget.initialHolding;
    if (h != null) {
      _selectedAssetType = h.type;
      _nameController = TextEditingController(text: h.name);
      _symbolController = TextEditingController(text: h.symbol ?? '');
      _qtyController = TextEditingController(
        text: h.quantity.toString().replaceAll(RegExp(r'\.0$'), ''),
      );
      _priceController = TextEditingController(
        text: h.purchasePrice.toString().replaceAll(RegExp(r'\.0$'), ''),
      );
      _isBuy = h.isBuy;
      _selectedOwner = h.owner;
      _purchaseDate = h.purchaseDate;
    } else {
      _nameController = TextEditingController(text: 'HDFC Bank');
      _symbolController = TextEditingController(text: 'HDFCBANK');
      _qtyController = TextEditingController(text: '100');
      _priceController = TextEditingController(text: '1600');
      _selectedOwner = widget.initialOwner ?? AppState().userName;
    }
  }

  final List<Map<String, dynamic>> _types = [
    {'name': 'Equity', 'icon': Icons.bar_chart_rounded},
    {'name': 'Real Estate', 'icon': Icons.home_work_outlined},
    {'name': 'Gold', 'icon': Icons.grid_view_rounded},
    {'name': 'Crypto', 'icon': Icons.currency_bitcoin_rounded},
    {'name': 'Mutual Fund', 'icon': Icons.pie_chart_outline_rounded},
    {'name': 'Other', 'icon': Icons.more_horiz_rounded},
  ];

  @override
  void dispose() {
    _nameController.dispose();
    _symbolController.dispose();
    _qtyController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  double get _totalValue {
    final qty = double.tryParse(_qtyController.text) ?? 0.0;
    final price = double.tryParse(_priceController.text) ?? 0.0;
    return qty * price;
  }

  String _formatCurrency(double val) {
    if (val == 0) return '0';
    return val.toStringAsFixed(0).replaceAllMapped(
          RegExp(r'(\d+?)(?=(\d\d)+(\d)(?!\d))(\.\d+)?'),
          (Match m) => '${m[1]},',
        );
  }

  String? _nameError;
  String? _qtyError;
  String? _priceError;

  void _submit() {
    setState(() {
      _nameError = _nameController.text.trim().isEmpty ? 'Please enter asset name' : null;
      final q = double.tryParse(_qtyController.text);
      if (q == null || q <= 0) {
        _qtyError = 'Enter valid quantity';
      } else {
        _qtyError = null;
      }
      final p = double.tryParse(_priceController.text);
      if (p == null || p < 0) {
        _priceError = 'Enter valid price';
      } else {
        _priceError = null;
      }
    });

    if (_nameError != null || _qtyError != null || _priceError != null) return;

    final qty = double.tryParse(_qtyController.text) ?? 1;
    final price = double.tryParse(_priceController.text) ?? 0;

    if (widget.initialHolding != null) {
      final updated = HoldingItem(
        id: widget.initialHolding!.id,
        name: _nameController.text.trim(),
        type: _selectedAssetType,
        symbol: _symbolController.text.trim().isNotEmpty ? _symbolController.text.trim() : null,
        quantity: qty,
        purchasePrice: price,
        owner: _selectedOwner,
        purchaseDate: _purchaseDate,
        isBuy: _isBuy,
      );
      AppState().updateHolding(updated);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${updated.name} updated in family portfolio!'),
          backgroundColor: HdfcColors.green,
          behavior: SnackBarBehavior.floating,
        ),
      );
    } else {
      final newHolding = HoldingItem(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: _nameController.text.trim(),
        type: _selectedAssetType,
        symbol: _symbolController.text.trim().isNotEmpty ? _symbolController.text.trim() : null,
        quantity: qty,
        purchasePrice: price,
        owner: _selectedOwner,
        purchaseDate: _purchaseDate,
        isBuy: _isBuy,
      );
      AppState().addHolding(newHolding);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${newHolding.name} added to family holdings!'),
          backgroundColor: HdfcColors.green,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final formattedDate =
        '${_purchaseDate.day} ${_monthName(_purchaseDate.month)} ${_purchaseDate.year}';
    final isEditing = widget.initialHolding != null;

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
          children: [
            const HdfcLogoWidget(size: 16),
            const SizedBox(width: 8),
            Text(
              isEditing ? 'Edit Holding' : 'Add Holding',
              style: const TextStyle(color: HdfcColors.textDark, fontSize: 17, fontWeight: FontWeight.w700),
            ),
          ],
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Asset Type', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: HdfcColors.textDark)),
              const SizedBox(height: 10),
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _types.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  childAspectRatio: 1.5,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                ),
                itemBuilder: (ctx, i) {
                  final t = _types[i];
                  final isSelected = t['name'] == _selectedAssetType;
                  return InkWell(
                    onTap: () => setState(() => _selectedAssetType = t['name']),
                    borderRadius: BorderRadius.circular(10),
                    child: Container(
                      decoration: BoxDecoration(
                        color: isSelected ? const Color(0xFFEFF6FF) : const Color(0xFFF8FAFC),
                        border: Border.all(
                          color: isSelected ? HdfcColors.navy : HdfcColors.border,
                          width: isSelected ? 2 : 1,
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(t['icon'], size: 22, color: isSelected ? HdfcColors.navy : HdfcColors.textMuted),
                          const SizedBox(height: 4),
                          Text(
                            t['name'],
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                              color: isSelected ? HdfcColors.navy : HdfcColors.textDark,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 18),
              _buildLabel('Asset Name *'),
              const SizedBox(height: 6),
              _buildTextField(
                _nameController,
                'e.g. HDFC Bank',
                errorText: _nameError,
                onChanged: (_) {
                  if (_nameError != null) setState(() => _nameError = null);
                },
              ),
              const SizedBox(height: 14),
              _buildLabel('Symbol (Optional)'),
              const SizedBox(height: 6),
              _buildTextField(_symbolController, 'e.g. HDFCBANK'),
              const SizedBox(height: 14),
              _buildLabel('Quantity *'),
              const SizedBox(height: 6),
              _buildTextField(
                _qtyController,
                'Quantity',
                isNumber: true,
                errorText: _qtyError,
                onChanged: (_) {
                  setState(() {
                    if (_qtyError != null) _qtyError = null;
                  });
                },
              ),
              const SizedBox(height: 14),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildLabel('Purchase Price (₹) *'),
                        const SizedBox(height: 6),
                        _buildTextField(
                          _priceController,
                          'Price',
                          isNumber: true,
                          errorText: _priceError,
                          onChanged: (_) {
                            setState(() {
                              if (_priceError != null) _priceError = null;
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildLabel('Total Value (₹)'),
                        const SizedBox(height: 6),
                        Container(
                          height: 48,
                          alignment: Alignment.centerLeft,
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF1F5F9),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: HdfcColors.border),
                          ),
                          child: Text(
                            '₹${_formatCurrency(_totalValue)}',
                            style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14, color: HdfcColors.textDark),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              _buildLabel('Transaction Type *'),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () => setState(() => _isBuy = true),
                      icon: const Icon(Icons.north_east, size: 16),
                      label: const Text('Buy'),
                      style: OutlinedButton.styleFrom(
                        backgroundColor: _isBuy ? const Color(0xFFEFF6FF) : Colors.white,
                        foregroundColor: _isBuy ? HdfcColors.navy : HdfcColors.textMuted,
                        side: BorderSide(
                          color: _isBuy ? HdfcColors.navy : HdfcColors.border,
                          width: _isBuy ? 1.8 : 1,
                        ),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () => setState(() => _isBuy = false),
                      icon: const Icon(Icons.south_east, size: 16),
                      label: const Text('Sell'),
                      style: OutlinedButton.styleFrom(
                        backgroundColor: !_isBuy ? HdfcColors.lightRed : Colors.white,
                        foregroundColor: !_isBuy ? HdfcColors.red : HdfcColors.textMuted,
                        side: BorderSide(
                          color: !_isBuy ? HdfcColors.red : HdfcColors.border,
                          width: !_isBuy ? 1.8 : 1,
                        ),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildLabel('Owner *'),
                        const SizedBox(height: 6),
                        Container(
                          height: 48,
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: HdfcColors.border),
                            color: Colors.white,
                          ),
                          child: DropdownButtonHideUnderline(
                            child: Builder(
                              builder: (context) {
                                final memberList = AppState().allFamilyProfiles.map((p) => p['name']!).toSet().toList();
                                if (!memberList.contains(_selectedOwner)) {
                                  memberList.insert(0, _selectedOwner);
                                }
                                return DropdownButton<String>(
                                  value: _selectedOwner,
                                  isExpanded: true,
                                  items: memberList
                                      .map((name) => DropdownMenuItem(
                                            value: name,
                                            child: Text(
                                              name,
                                              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ))
                                      .toList(),
                                  onChanged: (val) {
                                    if (val != null) setState(() => _selectedOwner = val);
                                  },
                                );
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildLabel('Purchase Date'),
                        const SizedBox(height: 6),
                        InkWell(
                          onTap: () async {
                            final picked = await showDatePicker(
                              context: context,
                              initialDate: _purchaseDate,
                              firstDate: DateTime(2000),
                              lastDate: DateTime.now(),
                            );
                            if (picked != null) setState(() => _purchaseDate = picked);
                          },
                          child: Container(
                            height: 48,
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: HdfcColors.border),
                              color: Colors.white,
                            ),
                            child: Row(
                              children: [
                                Expanded(child: Text(formattedDate, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600))),
                                const Icon(Icons.calendar_today_outlined, size: 16, color: HdfcColors.navy),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 18),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFFF1F5F9),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: HdfcColors.border),
                ),
                child: Row(
                  children: const [
                    Icon(Icons.info_outline, size: 16, color: HdfcColors.navy),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'The added holding will be visible to all family members in real-time.',
                        style: TextStyle(fontSize: 12, color: HdfcColors.textMuted, fontWeight: FontWeight.w500),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: HdfcColors.textDark,
                        side: const BorderSide(color: HdfcColors.border),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      child: const Text('Cancel', style: TextStyle(fontWeight: FontWeight.w700)),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _submit,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: HdfcColors.navy,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        elevation: 0,
                      ),
                      child: Text(
                        isEditing ? 'Save Changes' : 'Add Holding',
                        style: const TextStyle(fontWeight: FontWeight.w700),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Text(text, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: HdfcColors.textDark));
  }

  Widget _buildTextField(
    TextEditingController controller,
    String hint, {
    bool isNumber = false,
    String? errorText,
    ValueChanged<String>? onChanged,
  }) {
    return TextField(
      controller: controller,
      keyboardType: isNumber ? const TextInputType.numberWithOptions(decimal: true) : TextInputType.text,
      onChanged: onChanged,
      style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
      decoration: InputDecoration(
        hintText: hint,
        errorText: errorText,
        hintStyle: const TextStyle(color: HdfcColors.textSubtle, fontWeight: FontWeight.normal),
      ),
    );
  }

  String _monthName(int month) {
    const m = ['', 'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return m[month];
  }
}
