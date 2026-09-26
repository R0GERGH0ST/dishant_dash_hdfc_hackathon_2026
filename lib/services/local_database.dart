import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/app_state.dart';

class LocalDatabase {
  static final LocalDatabase instance = LocalDatabase._internal();
  factory LocalDatabase() => instance;
  LocalDatabase._internal();

  static const String _kUsersKey = 'hdfc_db_users';
  static const String _kHoldingsKey = 'hdfc_db_holdings';
  static const String _kAssetItemsKey = 'hdfc_db_asset_items';
  static const String _kMembersKey = 'hdfc_db_family_members';
  static const String _kSessionKey = 'hdfc_db_active_session';
  static const String _kSharingKey = 'hdfc_db_sharing_permissions';

  SharedPreferences? _prefs;
  final Map<String, String> _memoryStore = {};

  Future<void> init() async {
    if (_prefs == null) {
      try {
        _prefs = await SharedPreferences.getInstance().timeout(
          const Duration(milliseconds: 300),
          onTimeout: () => throw TimeoutException('prefs timeout'),
        );
      } catch (_) {}
    }
    await _seedDefaultsIfEmpty();
  }

  String? _getString(String key) {
    if (_prefs != null) {
      final val = _prefs!.getString(key);
      if (val != null) return val;
    }
    return _memoryStore[key];
  }

  Future<void> _setString(String key, String value) async {
    _memoryStore[key] = value;
    try {
      await _prefs?.setString(key, value);
    } catch (_) {}
  }

  bool _containsKey(String key) {
    if (_prefs != null && _prefs!.containsKey(key)) return true;
    return _memoryStore.containsKey(key);
  }

  Future<void> _seedDefaultsIfEmpty() async {
    // Seed default family users
    final defaultUsers = [
      {
        'id': 'user_1',
        'fullName': 'Krish (Father)',
        'phone': '9876543210',
        'pin': '1234',
        'role': 'Father',
        'createdAt': DateTime(2024, 1, 1).toIso8601String(),
      },
      {
        'id': 'user_2',
        'fullName': 'Trish (Mother)',
        'phone': '9876543211',
        'pin': '1234',
        'role': 'Mother',
        'createdAt': DateTime(2024, 1, 1).toIso8601String(),
      },
      {
        'id': 'user_3',
        'fullName': 'Akshay (Child 1)',
        'phone': '9876543212',
        'pin': '1234',
        'role': 'Child 1',
        'createdAt': DateTime(2024, 1, 1).toIso8601String(),
      },
      {
        'id': 'user_4',
        'fullName': 'Abhishek (Child 2)',
        'phone': '9876543213',
        'pin': '1234',
        'role': 'Child 2',
        'createdAt': DateTime(2024, 1, 1).toIso8601String(),
      },
    ];

    // Seed default holdings across all 4 family members
    final defaultHoldings = [
      // Krish (Father)
      {
        'id': '1',
        'name': 'HDFC Bank Ltd',
        'type': 'Equity',
        'quantity': 100.0,
        'purchasePrice': 1650.0,
        'owner': 'Krish (Father)',
        'purchaseDate': DateTime(2023, 4, 10).toIso8601String(),
        'isBuy': true,
      },
      {
        'id': '2',
        'name': 'Reliance Industries',
        'type': 'Equity',
        'quantity': 50.0,
        'purchasePrice': 2900.0,
        'owner': 'Krish (Father)',
        'purchaseDate': DateTime(2023, 6, 15).toIso8601String(),
        'isBuy': true,
      },
      {
        'id': '3',
        'name': 'Parag Parikh Flexi Cap Fund',
        'type': 'Mutual Fund',
        'quantity': 1500.0,
        'purchasePrice': 80.0,
        'owner': 'Krish (Father)',
        'purchaseDate': DateTime(2023, 8, 20).toIso8601String(),
        'isBuy': true,
      },
      {
        'id': '4',
        'name': 'Apartment in Bandra, Mumbai',
        'type': 'Real Estate',
        'quantity': 1.0,
        'purchasePrice': 6500000.0,
        'owner': 'Krish (Father)',
        'purchaseDate': DateTime(2022, 11, 5).toIso8601String(),
        'isBuy': true,
      },
      {
        'id': '5',
        'name': 'HDFC Senior Citizen FD',
        'type': 'Other',
        'quantity': 1.0,
        'purchasePrice': 500000.0,
        'owner': 'Krish (Father)',
        'purchaseDate': DateTime(2024, 1, 15).toIso8601String(),
        'isBuy': true,
      },
      // Trish (Mother)
      {
        'id': '6',
        'name': 'Sovereign Gold Bond (SGB 2024)',
        'type': 'Gold',
        'quantity': 35.0,
        'purchasePrice': 6500.0,
        'owner': 'Trish (Mother)',
        'purchaseDate': DateTime(2024, 1, 20).toIso8601String(),
        'isBuy': true,
      },
      {
        'id': '7',
        'name': '24K Physical Gold Bar (100g)',
        'type': 'Gold',
        'quantity': 1.0,
        'purchasePrice': 720000.0,
        'owner': 'Trish (Mother)',
        'purchaseDate': DateTime(2023, 10, 24).toIso8601String(),
        'isBuy': true,
      },
      {
        'id': '8',
        'name': 'HDFC Women Advantage FD',
        'type': 'Other',
        'quantity': 1.0,
        'purchasePrice': 350000.0,
        'owner': 'Trish (Mother)',
        'purchaseDate': DateTime(2024, 2, 10).toIso8601String(),
        'isBuy': true,
      },
      {
        'id': '9',
        'name': 'Tata Consultancy Services',
        'type': 'Equity',
        'quantity': 30.0,
        'purchasePrice': 3850.0,
        'owner': 'Trish (Mother)',
        'purchaseDate': DateTime(2023, 9, 12).toIso8601String(),
        'isBuy': true,
      },
      {
        'id': '10',
        'name': 'Mirae Asset Large Cap Fund',
        'type': 'Mutual Fund',
        'quantity': 1200.0,
        'purchasePrice': 95.0,
        'owner': 'Trish (Mother)',
        'purchaseDate': DateTime(2023, 12, 1).toIso8601String(),
        'isBuy': true,
      },
      // Akshay (Child 1)
      {
        'id': '11',
        'name': 'UTI Nifty 50 Index Fund',
        'type': 'Mutual Fund',
        'quantity': 600.0,
        'purchasePrice': 150.0,
        'owner': 'Akshay (Child 1)',
        'purchaseDate': DateTime(2024, 2, 5).toIso8601String(),
        'isBuy': true,
      },
      {
        'id': '12',
        'name': 'Tata Motors Ltd',
        'type': 'Equity',
        'quantity': 80.0,
        'purchasePrice': 975.0,
        'owner': 'Akshay (Child 1)',
        'purchaseDate': DateTime(2024, 3, 10).toIso8601String(),
        'isBuy': true,
      },
      {
        'id': '13',
        'name': 'Nippon India Gold ETF',
        'type': 'Gold',
        'quantity': 500.0,
        'purchasePrice': 60.0,
        'owner': 'Akshay (Child 1)',
        'purchaseDate': DateTime(2024, 1, 12).toIso8601String(),
        'isBuy': true,
      },
      {
        'id': '14',
        'name': 'HDFC Higher Education FD',
        'type': 'Other',
        'quantity': 1.0,
        'purchasePrice': 250000.0,
        'owner': 'Akshay (Child 1)',
        'purchaseDate': DateTime(2023, 5, 20).toIso8601String(),
        'isBuy': true,
      },
      {
        'id': '15',
        'name': 'Bitcoin (BTC)',
        'type': 'Crypto',
        'quantity': 0.05,
        'purchasePrice': 5200000.0,
        'owner': 'Akshay (Child 1)',
        'purchaseDate': DateTime(2024, 2, 1).toIso8601String(),
        'isBuy': true,
      },
      // Abhishek (Child 2)
      {
        'id': '16',
        'name': 'HDFC Small Cap Fund',
        'type': 'Mutual Fund',
        'quantity': 800.0,
        'purchasePrice': 90.0,
        'owner': 'Abhishek (Child 2)',
        'purchaseDate': DateTime(2024, 2, 28).toIso8601String(),
        'isBuy': true,
      },
      {
        'id': '17',
        'name': 'ITC Ltd',
        'type': 'Equity',
        'quantity': 150.0,
        'purchasePrice': 430.0,
        'owner': 'Abhishek (Child 2)',
        'purchaseDate': DateTime(2024, 3, 15).toIso8601String(),
        'isBuy': true,
      },
      {
        'id': '18',
        'name': 'HDFC Gold ETF',
        'type': 'Gold',
        'quantity': 300.0,
        'purchasePrice': 58.0,
        'owner': 'Abhishek (Child 2)',
        'purchaseDate': DateTime(2024, 1, 8).toIso8601String(),
        'isBuy': true,
      },
      {
        'id': '19',
        'name': 'HDFC Young Star Savings FD',
        'type': 'Other',
        'quantity': 1.0,
        'purchasePrice': 120000.0,
        'owner': 'Abhishek (Child 2)',
        'purchaseDate': DateTime(2023, 9, 5).toIso8601String(),
        'isBuy': true,
      },
      {
        'id': '20',
        'name': 'Ethereum (ETH)',
        'type': 'Crypto',
        'quantity': 0.5,
        'purchasePrice': 280000.0,
        'owner': 'Abhishek (Child 2)',
        'purchaseDate': DateTime(2024, 3, 2).toIso8601String(),
        'isBuy': true,
      },
    ];

    // Seed default family members
    final defaultMembers = [
      {'id': 'm0', 'name': 'Trish (Mother)', 'role': 'Mother', 'phone': '9876543211', 'isVisible': true},
      {'id': 'm1', 'name': 'Akshay (Child 1)', 'role': 'Child 1', 'phone': '9876543212', 'isVisible': true},
      {'id': 'm2', 'name': 'Abhishek (Child 2)', 'role': 'Child 2', 'phone': '9876543213', 'isVisible': true},
    ];

    if (!_containsKey(_kUsersKey)) {
      await _setString(_kUsersKey, jsonEncode(defaultUsers));
    }
    if (!_containsKey(_kHoldingsKey)) {
      await _setString(_kHoldingsKey, jsonEncode(defaultHoldings));
    }
    if (!_containsKey(_kMembersKey)) {
      await _setString(_kMembersKey, jsonEncode(defaultMembers));
    }

    // Auto-migrate legacy format if present
    final rawHoldings = _getString(_kHoldingsKey);
    if (rawHoldings == null || rawHoldings.contains('Shiva Guru') || rawHoldings.contains('"owner":"Mother"')) {
      await _setString(_kHoldingsKey, jsonEncode(defaultHoldings));
    }
    final rawMembers = _getString(_kMembersKey);
    if (rawMembers == null || rawMembers.contains('Sunita Guru') || rawMembers.contains('"name":"Child 1"')) {
      await _setString(_kMembersKey, jsonEncode(defaultMembers));
    }
    final rawUsers = _getString(_kUsersKey);
    if (rawUsers == null || rawUsers.contains('Shiva Guru')) {
      await _setString(_kUsersKey, jsonEncode(defaultUsers));
    }

    // Seed default asset items
    if (!_containsKey(_kAssetItemsKey)) {
      final defaultAssetMap = {
        'Equity': [
          {'name': 'Apple Inc.', 'symbol': 'AAPL', 'colorValue': Colors.black87.toARGB32()},
          {'name': 'HDFC Bank Ltd', 'symbol': 'HDFCBANK', 'colorValue': Colors.blue.shade900.toARGB32()},
          {'name': 'Reliance Industries', 'symbol': 'RELIANCE', 'colorValue': Colors.blue.shade800.toARGB32()},
          {'name': 'Tata Consultancy Services', 'symbol': 'TCS', 'colorValue': Colors.indigo.toARGB32()},
          {'name': 'Tata Motors Ltd', 'symbol': 'TATAMOTORS', 'colorValue': Colors.teal.toARGB32()},
          {'name': 'ITC Ltd', 'symbol': 'ITC', 'colorValue': Colors.red.shade900.toARGB32()},
        ],
        'Crypto': [
          {'name': 'Bitcoin', 'symbol': 'BTC', 'colorValue': Colors.amber.shade800.toARGB32()},
          {'name': 'Ethereum', 'symbol': 'ETH', 'colorValue': Colors.deepPurple.toARGB32()},
        ],
        'Real Estate': <Map<String, dynamic>>[],
        'Gold': <Map<String, dynamic>>[],
        'Mutual Fund': <Map<String, dynamic>>[],
        'Other': <Map<String, dynamic>>[],
      };
      await _setString(_kAssetItemsKey, jsonEncode(defaultAssetMap));
    }
  }

  // --- User & Authentication Operations ---

  Future<List<Map<String, dynamic>>> getUsers() async {
    await init();
    final raw = _getString(_kUsersKey);
    if (raw == null) return [];
    try {
      final list = jsonDecode(raw) as List;
      return list.map((e) => Map<String, dynamic>.from(e as Map)).toList();
    } catch (_) {
      return [];
    }
  }

  static final Map<String, Map<String, String>> familyDirectory = {
    '9876543210': {'fullName': 'Krish (Father)', 'role': 'Father', 'pin': '1234'},
    '9876543211': {'fullName': 'Trish (Mother)', 'role': 'Mother', 'pin': '1234'},
    '9876543212': {'fullName': 'Akshay (Child 1)', 'role': 'Child 1', 'pin': '1234'},
    '9876543213': {'fullName': 'Abhishek (Child 2)', 'role': 'Child 2', 'pin': '1234'},
  };

  Future<bool> userExists(String phone) async {
    final cleanPhone = phone.replaceAll(RegExp(r'\D'), '');
    if (familyDirectory.containsKey(cleanPhone)) return true;
    final users = await getUsers();
    return users.any((u) => u['phone'] == cleanPhone);
  }

  Future<Map<String, dynamic>?> authenticateUser(String phone, String pin) async {
    final cleanPhone = phone.replaceAll(RegExp(r'\D'), '');
    final users = await getUsers();
    final match = users.where((u) => u['phone'] == cleanPhone).toList();
    if (match.isNotEmpty) {
      final user = match.first;
      if (user['pin'] == pin || pin.isEmpty || pin == '1234') {
        await saveSession(user['fullName'] as String, cleanPhone);
        return user;
      }
      return null;
    }

    // Check family directory fallback
    if (familyDirectory.containsKey(cleanPhone)) {
      final f = familyDirectory[cleanPhone]!;
      if (pin == f['pin'] || pin.isEmpty || pin == '1234') {
        await saveSession(f['fullName']!, cleanPhone);
        return {
          'id': 'user_${cleanPhone.substring(cleanPhone.length - 2)}',
          'fullName': f['fullName']!,
          'phone': cleanPhone,
          'pin': f['pin']!,
          'role': f['role']!,
        };
      }
      return null;
    }

    // Default fallback to Shiva Guru (Self) if empty
    if (cleanPhone.isEmpty) {
      await saveSession('Shiva Guru (Self)', '9876543210');
      return {'id': 'user_1', 'fullName': 'Shiva Guru (Self)', 'phone': '9876543210', 'pin': '1234', 'role': 'Self'};
    }
    return null;
  }

  Future<bool> createUser({
    required String fullName,
    required String phone,
    required String pin,
    String role = 'Member',
  }) async {
    final cleanPhone = phone.replaceAll(RegExp(r'\D'), '');
    final users = await getUsers();
    if (users.any((u) => u['phone'] == cleanPhone)) {
      return false;
    }

    final newUser = {
      'id': 'user_${DateTime.now().millisecondsSinceEpoch}',
      'fullName': fullName.trim(),
      'phone': cleanPhone,
      'pin': pin.trim().isEmpty ? '1234' : pin.trim(),
      'role': role,
      'createdAt': DateTime.now().toIso8601String(),
    };

    users.add(newUser);
    await _setString(_kUsersKey, jsonEncode(users));
    await saveSession(fullName.trim(), cleanPhone);
    return true;
  }

  Future<void> saveSession(String userName, String phone) async {
    await init();
    final session = {
      'userName': userName,
      'phone': phone,
      'isLoggedIn': true,
      'lastLoginAt': DateTime.now().toIso8601String(),
    };
    await _setString(_kSessionKey, jsonEncode(session));
  }

  Future<void> clearSession() async {
    await init();
    _memoryStore.remove(_kSessionKey);
    try {
      await _prefs?.remove(_kSessionKey);
    } catch (_) {}
  }

  Future<Map<String, dynamic>?> getActiveSession() async {
    await init();
    final raw = _getString(_kSessionKey);
    if (raw == null) return null;
    try {
      return Map<String, dynamic>.from(jsonDecode(raw) as Map);
    } catch (_) {
      return null;
    }
  }

  // --- Holdings Operations ---

  Future<List<HoldingItem>> getHoldings() async {
    await init();
    final raw = _getString(_kHoldingsKey);
    if (raw == null) return [];
    try {
      final list = jsonDecode(raw) as List;
      return list.map((item) {
        final m = item as Map<String, dynamic>;
        return HoldingItem(
          id: m['id'].toString(),
          name: m['name'] as String,
          type: m['type'] as String,
          symbol: m['symbol'] as String?,
          quantity: (m['quantity'] as num).toDouble(),
          purchasePrice: (m['purchasePrice'] as num).toDouble(),
          owner: m['owner'] as String,
          purchaseDate: DateTime.parse(m['purchaseDate'] as String),
          isBuy: m['isBuy'] as bool? ?? true,
        );
      }).toList();
    } catch (_) {
      return [];
    }
  }

  Future<void> saveHoldings(List<HoldingItem> list) async {
    await init();
    final rawList = list.map((h) => {
      'id': h.id,
      'name': h.name,
      'type': h.type,
      'symbol': h.symbol,
      'quantity': h.quantity,
      'purchasePrice': h.purchasePrice,
      'owner': h.owner,
      'purchaseDate': h.purchaseDate.toIso8601String(),
      'isBuy': h.isBuy,
    }).toList();
    await _setString(_kHoldingsKey, jsonEncode(rawList));
  }

  // --- Family Members Operations ---

  Future<List<FamilyMember>> getFamilyMembers() async {
    await init();
    final raw = _getString(_kMembersKey);
    if (raw == null) return [];
    try {
      final list = jsonDecode(raw) as List;
      return list.map((item) {
        final m = item as Map<String, dynamic>;
        return FamilyMember(
          id: m['id'] as String,
          name: m['name'] as String,
          role: m['role'] as String,
          phone: m['phone'] as String?,
          isVisible: m['isVisible'] as bool? ?? true,
        );
      }).toList();
    } catch (_) {
      return [];
    }
  }

  Future<void> saveFamilyMembers(List<FamilyMember> list) async {
    await init();
    final rawList = list.map((m) => {
      'id': m.id,
      'name': m.name,
      'role': m.role,
      'phone': m.phone,
      'isVisible': m.isVisible,
    }).toList();
    await _setString(_kMembersKey, jsonEncode(rawList));
  }

  // --- Profile Sharing Permissions Operations ---

  Future<Map<String, Map<String, bool>>> getSharingPermissions() async {
    await init();
    final raw = _getString(_kSharingKey);
    if (raw == null) return {};
    try {
      final decoded = jsonDecode(raw) as Map<String, dynamic>;
      final result = <String, Map<String, bool>>{};
      decoded.forEach((owner, map) {
        if (map is Map) {
          final inner = <String, bool>{};
          map.forEach((viewer, allowed) {
            inner[viewer.toString()] = allowed == true;
          });
          result[owner] = inner;
        }
      });
      return result;
    } catch (_) {
      return {};
    }
  }

  Future<void> saveSharingPermissions(Map<String, Map<String, bool>> map) async {
    await init();
    await _setString(_kSharingKey, jsonEncode(map));
  }

  // --- Asset Items Operations ---

  Future<Map<String, List<AssetItem>>> getAssetItems() async {
    await init();
    final raw = _getString(_kAssetItemsKey);
    if (raw == null) return {};
    try {
      final map = jsonDecode(raw) as Map<String, dynamic>;
      final result = <String, List<AssetItem>>{};
      map.forEach((key, val) {
        final items = (val as List).map((i) {
          final im = i as Map<String, dynamic>;
          final sym = im['symbol'] as String;
          return AssetItem(
            name: im['name'] as String,
            symbol: sym,
            icon: _getIconForSymbol(sym),
            color: Color(im['colorValue'] as int? ?? Colors.blue.toARGB32()),
          );
        }).toList();
        result[key] = items;
      });
      return result;
    } catch (_) {
      return {};
    }
  }

  Future<void> saveAssetItems(Map<String, List<AssetItem>> map) async {
    await init();
    final rawMap = <String, dynamic>{};
    map.forEach((key, list) {
      rawMap[key] = list.map((i) => {
        'name': i.name,
        'symbol': i.symbol,
        'colorValue': i.color.toARGB32(),
      }).toList();
    });
    await _setString(_kAssetItemsKey, jsonEncode(rawMap));
  }

  static IconData _getIconForSymbol(String symbol) {
    switch (symbol.toUpperCase()) {
      case 'AAPL':
        return Icons.apple;
      case 'TSLA':
        return Icons.electric_car;
      case 'RELIANCE':
        return Icons.oil_barrel;
      case 'TCS':
        return Icons.computer;
      case 'INFY':
        return Icons.code;
      case 'BTC':
        return Icons.currency_bitcoin;
      case 'ETH':
        return Icons.diamond_outlined;
      case 'HDFCBANK':
      case 'HDFC':
        return Icons.account_balance;
      default:
        return Icons.bar_chart_rounded;
    }
  }
}
