import 'package:flutter/material.dart';
import '../services/local_database.dart';

class HoldingItem {
  final String id;
  final String name;
  final String type;
  final String? symbol;
  final double quantity;
  final double purchasePrice;
  final String owner;
  final DateTime purchaseDate;
  final bool isBuy;

  HoldingItem({
    required this.id,
    required this.name,
    required this.type,
    this.symbol,
    required this.quantity,
    required this.purchasePrice,
    required this.owner,
    required this.purchaseDate,
    this.isBuy = true,
  });

  double get totalValue => quantity * purchasePrice;
}

class AssetItem {
  final String name;
  final String symbol;
  final IconData icon;
  final Color color;

  AssetItem({
    required this.name,
    required this.symbol,
    required this.icon,
    required this.color,
  });
}

class FamilyMember {
  final String id;
  final String name;
  final String role;
  final String? phone;
  bool isVisible;

  FamilyMember({
    required this.id,
    required this.name,
    required this.role,
    this.phone,
    this.isVisible = true,
  });
}

class AppState extends ChangeNotifier {
  static final AppState instance = AppState._internal();
  factory AppState() => instance;
  AppState._internal() {
    _initFromDatabase();
  }

  String userName = 'Krish (Father)';
  String userPhone = '9876543210';
  bool isLoggedIn = true;

  List<HoldingItem> _holdings = [
    // Krish (Father)
    HoldingItem(
      id: '1',
      name: 'HDFC Bank Ltd',
      type: 'Equity',
      quantity: 100,
      purchasePrice: 1650,
      owner: 'Krish (Father)',
      purchaseDate: DateTime(2023, 4, 10),
    ),
    HoldingItem(
      id: '2',
      name: 'Reliance Industries',
      type: 'Equity',
      quantity: 50,
      purchasePrice: 2900,
      owner: 'Krish (Father)',
      purchaseDate: DateTime(2023, 6, 15),
    ),
    HoldingItem(
      id: '3',
      name: 'Parag Parikh Flexi Cap Fund',
      type: 'Mutual Fund',
      quantity: 1500,
      purchasePrice: 80,
      owner: 'Krish (Father)',
      purchaseDate: DateTime(2023, 8, 20),
    ),
    HoldingItem(
      id: '4',
      name: 'Apartment in Bandra, Mumbai',
      type: 'Real Estate',
      quantity: 1,
      purchasePrice: 6500000,
      owner: 'Krish (Father)',
      purchaseDate: DateTime(2022, 11, 5),
    ),
    HoldingItem(
      id: '5',
      name: 'HDFC Senior Citizen FD',
      type: 'Other',
      quantity: 1,
      purchasePrice: 500000,
      owner: 'Krish (Father)',
      purchaseDate: DateTime(2024, 1, 15),
    ),
    // Trish (Mother)
    HoldingItem(
      id: '6',
      name: 'Sovereign Gold Bond (SGB 2024)',
      type: 'Gold',
      quantity: 35,
      purchasePrice: 6500,
      owner: 'Trish (Mother)',
      purchaseDate: DateTime(2024, 1, 20),
    ),
    HoldingItem(
      id: '7',
      name: '24K Physical Gold Bar (100g)',
      type: 'Gold',
      quantity: 1,
      purchasePrice: 720000,
      owner: 'Trish (Mother)',
      purchaseDate: DateTime(2023, 10, 24),
    ),
    HoldingItem(
      id: '8',
      name: 'HDFC Women Advantage FD',
      type: 'Other',
      quantity: 1,
      purchasePrice: 350000,
      owner: 'Trish (Mother)',
      purchaseDate: DateTime(2024, 2, 10),
    ),
    HoldingItem(
      id: '9',
      name: 'Tata Consultancy Services',
      type: 'Equity',
      quantity: 30,
      purchasePrice: 3850,
      owner: 'Trish (Mother)',
      purchaseDate: DateTime(2023, 9, 12),
    ),
    HoldingItem(
      id: '10',
      name: 'Mirae Asset Large Cap Fund',
      type: 'Mutual Fund',
      quantity: 1200,
      purchasePrice: 95,
      owner: 'Trish (Mother)',
      purchaseDate: DateTime(2023, 12, 1),
    ),
    // Akshay (Child 1)
    HoldingItem(
      id: '11',
      name: 'UTI Nifty 50 Index Fund',
      type: 'Mutual Fund',
      quantity: 600,
      purchasePrice: 150,
      owner: 'Akshay (Child 1)',
      purchaseDate: DateTime(2024, 2, 5),
    ),
    HoldingItem(
      id: '12',
      name: 'Tata Motors Ltd',
      type: 'Equity',
      quantity: 80,
      purchasePrice: 975,
      owner: 'Akshay (Child 1)',
      purchaseDate: DateTime(2024, 3, 10),
    ),
    HoldingItem(
      id: '13',
      name: 'Nippon India Gold ETF',
      type: 'Gold',
      quantity: 500,
      purchasePrice: 60,
      owner: 'Akshay (Child 1)',
      purchaseDate: DateTime(2024, 1, 12),
    ),
    HoldingItem(
      id: '14',
      name: 'HDFC Higher Education FD',
      type: 'Other',
      quantity: 1,
      purchasePrice: 250000,
      owner: 'Akshay (Child 1)',
      purchaseDate: DateTime(2023, 5, 20),
    ),
    HoldingItem(
      id: '15',
      name: 'Bitcoin (BTC)',
      type: 'Crypto',
      quantity: 0.05,
      purchasePrice: 5200000,
      owner: 'Akshay (Child 1)',
      purchaseDate: DateTime(2024, 2, 1),
    ),
    // Abhishek (Child 2)
    HoldingItem(
      id: '16',
      name: 'HDFC Small Cap Fund',
      type: 'Mutual Fund',
      quantity: 800,
      purchasePrice: 90,
      owner: 'Abhishek (Child 2)',
      purchaseDate: DateTime(2024, 2, 28),
    ),
    HoldingItem(
      id: '17',
      name: 'ITC Ltd',
      type: 'Equity',
      quantity: 150,
      purchasePrice: 430,
      owner: 'Abhishek (Child 2)',
      purchaseDate: DateTime(2024, 3, 15),
    ),
    HoldingItem(
      id: '18',
      name: 'HDFC Gold ETF',
      type: 'Gold',
      quantity: 300,
      purchasePrice: 58,
      owner: 'Abhishek (Child 2)',
      purchaseDate: DateTime(2024, 1, 8),
    ),
    HoldingItem(
      id: '19',
      name: 'HDFC Young Star Savings FD',
      type: 'Other',
      quantity: 1,
      purchasePrice: 120000,
      owner: 'Abhishek (Child 2)',
      purchaseDate: DateTime(2023, 9, 5),
    ),
    HoldingItem(
      id: '20',
      name: 'Ethereum (ETH)',
      type: 'Crypto',
      quantity: 0.5,
      purchasePrice: 280000,
      owner: 'Abhishek (Child 2)',
      purchaseDate: DateTime(2024, 3, 2),
    ),
  ];

  Map<String, List<AssetItem>> _assetItems = {
    'Equity': [
      AssetItem(name: 'Apple Inc.', symbol: 'AAPL', icon: Icons.apple, color: Colors.black87),
      AssetItem(name: 'HDFC Bank Ltd', symbol: 'HDFCBANK', icon: Icons.account_balance, color: Colors.blue.shade900),
      AssetItem(name: 'Reliance Industries', symbol: 'RELIANCE', icon: Icons.oil_barrel, color: Colors.blue.shade800),
      AssetItem(name: 'Tata Consultancy Services', symbol: 'TCS', icon: Icons.computer, color: Colors.indigo),
      AssetItem(name: 'Tata Motors Ltd', symbol: 'TATAMOTORS', icon: Icons.directions_car, color: Colors.teal),
      AssetItem(name: 'ITC Ltd', symbol: 'ITC', icon: Icons.shopping_bag, color: Colors.red.shade900),
    ],
    'Crypto': [
      AssetItem(name: 'Bitcoin', symbol: 'BTC', icon: Icons.currency_bitcoin, color: Colors.amber.shade800),
      AssetItem(name: 'Ethereum', symbol: 'ETH', icon: Icons.diamond_outlined, color: Colors.deepPurple),
    ],
    'Real Estate': [],
    'Gold': [],
    'Mutual Fund': [],
    'Other': [],
  };

  List<FamilyMember> _familyMembers = [
    FamilyMember(id: 'm0', name: 'Trish (Mother)', role: 'Mother', phone: '9876543211', isVisible: true),
    FamilyMember(id: 'm1', name: 'Akshay (Child 1)', role: 'Child 1', phone: '9876543212', isVisible: true),
    FamilyMember(id: 'm2', name: 'Abhishek (Child 2)', role: 'Child 2', phone: '9876543213', isVisible: true),
  ];

  Map<String, Map<String, bool>> _sharingPermissions = {};

  List<HoldingItem> get holdings => List.unmodifiable(_holdings);
  Map<String, List<AssetItem>> get assetItems => _assetItems;
  List<FamilyMember> get familyMembers => _familyMembers;

  List<Map<String, String>> get allFamilyProfiles {
    final list = <Map<String, String>>[
      {
        'name': 'Krish (Father)',
        'role': 'Father (Primary Account Holder)',
        'phone': '9876543210',
      },
    ];
    for (final m in _familyMembers) {
      if (!list.any((p) => p['name']?.toLowerCase() == m.name.toLowerCase())) {
        list.add({
          'name': m.name,
          'role': m.role,
          'phone': m.phone ?? '9876543211',
        });
      }
    }
    return list;
  }

  static bool isOwnerMatch(String holdingOwner, String target) {
    final h = holdingOwner.trim().toLowerCase();
    final t = target.trim().toLowerCase();
    if (h.isEmpty || t.isEmpty) return false;
    if (h == t) return true;
    if (h.contains(t) || t.contains(h)) return true;

    if (t == 'self' || t == '(self)') {
      return isOwnerMatch(holdingOwner, AppState.instance.userName);
    }

    final cleanT = t.replaceAll('(self)', '').trim();
    if (cleanT.isNotEmpty && (h == cleanT || h.contains(cleanT) || cleanT.contains(h))) {
      return true;
    }

    final hName = h.split('(').first.trim();
    final tName = cleanT.split('(').first.trim();
    if (hName.isNotEmpty && tName.isNotEmpty && (hName == tName || hName.contains(tName) || tName.contains(hName))) {
      return true;
    }

    final hRole = RegExp(r'\((.*?)\)').firstMatch(h)?.group(1)?.trim().toLowerCase() ?? '';
    final tRole = RegExp(r'\((.*?)\)').firstMatch(t)?.group(1)?.trim().toLowerCase() ?? '';
    if (hRole.isNotEmpty && tRole.isNotEmpty && hRole == tRole) return true;
    if (hRole.isNotEmpty && (t.contains(hRole) || t == hRole)) return true;
    if (tRole.isNotEmpty && (h.contains(tRole) || h == tRole)) return true;

    if ((t.contains('krish') || t.contains('father')) && (h.contains('krish') || h.contains('father'))) return true;
    if ((t.contains('trish') || t.contains('mother')) && (h.contains('trish') || h.contains('mother'))) return true;
    if ((t.contains('akshay') || t.contains('child 1')) && (h.contains('akshay') || h.contains('child 1'))) return true;
    if ((t.contains('abhishek') || t.contains('child 2')) && (h.contains('abhishek') || h.contains('child 2'))) return true;

    return false;
  }

  bool isProfileSharedWith({required String owner, required String target}) {
    if (isOwnerMatch(owner, target)) return true;
    for (final o in _sharingPermissions.entries) {
      if (isOwnerMatch(o.key, owner)) {
        for (final t in o.value.entries) {
          if (isOwnerMatch(t.key, target)) {
            return t.value;
          }
        }
      }
    }
    return true; // Default: shared
  }

  void setProfileSharing({
    required String owner,
    required String target,
    required bool isShared,
  }) {
    String ownerKey = owner;
    for (final k in _sharingPermissions.keys) {
      if (isOwnerMatch(k, owner)) {
        ownerKey = k;
        break;
      }
    }
    final targetMap = _sharingPermissions.putIfAbsent(ownerKey, () => <String, bool>{});

    String targetKey = target;
    for (final k in targetMap.keys) {
      if (isOwnerMatch(k, target)) {
        targetKey = k;
        break;
      }
    }
    targetMap[targetKey] = isShared;

    // Sync isVisible on family member list if owner is currently logged in user
    if (isOwnerMatch(owner, userName)) {
      final memberIdx = _familyMembers.indexWhere(
        (m) => isOwnerMatch(m.name, target) || isOwnerMatch(m.id, target),
      );
      if (memberIdx != -1) {
        _familyMembers[memberIdx].isVisible = isShared;
        LocalDatabase.instance.saveFamilyMembers(_familyMembers);
      }
    }

    LocalDatabase.instance.saveSharingPermissions(_sharingPermissions);
    notifyListeners();
  }

  bool canUserSeeHolding(HoldingItem holding, {String? viewer}) {
    final viewerName = viewer ?? userName;
    if (isOwnerMatch(holding.owner, viewerName)) return true;
    return isProfileSharedWith(owner: holding.owner, target: viewerName);
  }

  bool canUserSeeMemberHoldings(String memberName, {String? viewer}) {
    final viewerName = viewer ?? userName;
    if (isOwnerMatch(memberName, viewerName)) return true;
    return isProfileSharedWith(owner: memberName, target: viewerName);
  }

  bool isOwnerVisible(String ownerName) {
    return canUserSeeMemberHoldings(ownerName);
  }

  List<HoldingItem> get visibleHoldings {
    return _holdings.where((h) => canUserSeeHolding(h)).toList();
  }

  double get totalPersonalAssets {
    return _holdings
        .where((h) => isOwnerMatch(h.owner, userName))
        .fold(0.0, (acc, item) => acc + item.totalValue);
  }

  double get totalFamilyAssets =>
      visibleHoldings.fold(0.0, (acc, item) => acc + item.totalValue);

  Map<String, double> get categoryTotals {
    final map = <String, double>{};
    for (final h in visibleHoldings) {
      map[h.type] = (map[h.type] ?? 0.0) + h.totalValue;
    }
    return map;
  }

  Map<String, double> get categoryPercentages {
    final total = totalFamilyAssets;
    if (total <= 0) return {};
    final map = <String, double>{};
    categoryTotals.forEach((k, v) {
      map[k] = (v / total) * 100.0;
    });
    return map;
  }

  Future<void> _initFromDatabase() async {
    try {
      final db = LocalDatabase.instance;
      await db.init();
      final savedHoldings = await db.getHoldings();
      if (savedHoldings.isNotEmpty) {
        _holdings = savedHoldings;
      }
      final savedMembers = await db.getFamilyMembers();
      if (savedMembers.isNotEmpty) {
        _familyMembers = savedMembers;
      }
      final savedAssets = await db.getAssetItems();
      if (savedAssets.isNotEmpty) {
        _assetItems = savedAssets;
      }
      final savedSharing = await db.getSharingPermissions();
      if (savedSharing.isNotEmpty) {
        _sharingPermissions = savedSharing;
      }
      final session = await db.getActiveSession();
      if (session != null) {
        userName = session['userName'] as String? ?? userName;
        userPhone = session['phone'] as String? ?? userPhone;
      }
      notifyListeners();
    } catch (_) {}
  }

  void addHolding(HoldingItem item) {
    _holdings.insert(0, item);
    LocalDatabase.instance.saveHoldings(_holdings);
    notifyListeners();
  }

  void updateHolding(HoldingItem updatedItem) {
    final idx = _holdings.indexWhere((h) => h.id == updatedItem.id);
    if (idx != -1) {
      _holdings[idx] = updatedItem;
    } else {
      _holdings.insert(0, updatedItem);
    }
    LocalDatabase.instance.saveHoldings(_holdings);
    notifyListeners();
  }

  void removeHolding(String id) {
    _holdings.removeWhere((h) => h.id == id);
    LocalDatabase.instance.saveHoldings(_holdings);
    notifyListeners();
  }

  void addAssetItem(String type, AssetItem item) {
    _assetItems.putIfAbsent(type, () => []).add(item);
    LocalDatabase.instance.saveAssetItems(_assetItems);
    notifyListeners();
  }

  void addAssetType(String name) {
    _assetItems.putIfAbsent(name, () => []);
    LocalDatabase.instance.saveAssetItems(_assetItems);
    notifyListeners();
  }

  void toggleMemberVisibility(String memberId, bool visible) {
    final idx = _familyMembers.indexWhere((m) => m.id == memberId || m.name == memberId);
    String targetName = memberId;
    if (idx != -1) {
      _familyMembers[idx].isVisible = visible;
      targetName = _familyMembers[idx].name;
      LocalDatabase.instance.saveFamilyMembers(_familyMembers);
    }
    setProfileSharing(owner: userName, target: targetName, isShared: visible);
  }

  Future<void> addFamilyMember({
    required String fullName,
    required String relation,
    required String phone,
    String pin = '1234',
  }) async {
    final cleanPhone = phone.replaceAll(RegExp(r'\D'), '');
    final bracketName = fullName.contains('(') ? fullName.trim() : '${fullName.trim()} ($relation)';
    final newMember = FamilyMember(
      id: 'm_${DateTime.now().millisecondsSinceEpoch}',
      name: bracketName,
      role: relation,
      phone: cleanPhone,
      isVisible: true,
    );
    _familyMembers.add(newMember);
    await LocalDatabase.instance.saveFamilyMembers(_familyMembers);
    await LocalDatabase.instance.createUser(
      fullName: bracketName,
      phone: cleanPhone,
      pin: pin,
      role: relation,
    );
    notifyListeners();
  }

  void updateMember(String memberIdOrName, String newName, String newRole, [String? newPhone]) {
    final idx = _familyMembers.indexWhere(
      (m) => m.id == memberIdOrName || m.name.toLowerCase() == memberIdOrName.toLowerCase(),
    );
    if (idx != -1) {
      final oldName = _familyMembers[idx].name;
      final existingPhone = _familyMembers[idx].phone;
      _familyMembers[idx] = FamilyMember(
        id: _familyMembers[idx].id,
        name: newName,
        role: newRole,
        phone: newPhone ?? existingPhone,
        isVisible: _familyMembers[idx].isVisible,
      );
      // Also update holding owners if name changed
      if (oldName.toLowerCase() != newName.toLowerCase()) {
        _holdings = _holdings.map((h) {
          if (isOwnerMatch(h.owner, oldName)) {
            return HoldingItem(
              id: h.id,
              name: h.name,
              type: h.type,
              symbol: h.symbol,
              quantity: h.quantity,
              purchasePrice: h.purchasePrice,
              owner: newName,
              purchaseDate: h.purchaseDate,
              isBuy: h.isBuy,
            );
          }
          return h;
        }).toList();
        LocalDatabase.instance.saveHoldings(_holdings);
      }
      if (isOwnerMatch(userName, oldName)) {
        userName = newName;
      }
      LocalDatabase.instance.saveFamilyMembers(_familyMembers);
      notifyListeners();
    } else {
      _familyMembers.add(FamilyMember(
        id: 'm_${DateTime.now().millisecondsSinceEpoch}',
        name: newName,
        role: newRole,
        phone: newPhone,
        isVisible: true,
      ));
      LocalDatabase.instance.saveFamilyMembers(_familyMembers);
      notifyListeners();
    }
  }

  void removeMember(String memberIdOrName) {
    _familyMembers.removeWhere(
      (m) => m.id == memberIdOrName || m.name.toLowerCase() == memberIdOrName.toLowerCase(),
    );
    LocalDatabase.instance.saveFamilyMembers(_familyMembers);
    notifyListeners();
  }

  void login(String name, String phone) {
    userName = name.isNotEmpty ? name : 'Krish (Father)';
    userPhone = phone;
    isLoggedIn = true;
    LocalDatabase.instance.saveSession(userName, userPhone);
    notifyListeners();
  }

  void logout() {
    isLoggedIn = false;
    LocalDatabase.instance.clearSession();
    notifyListeners();
  }

  void switchUser(String name, String phone) {
    userName = name;
    userPhone = phone;
    isLoggedIn = true;
    LocalDatabase.instance.saveSession(userName, userPhone);
    notifyListeners();
  }
}
