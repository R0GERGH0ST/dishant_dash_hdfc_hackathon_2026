import 'package:flutter/material.dart';
import '../models/app_state.dart';
import '../theme/hdfc_theme.dart';
import 'asset_types_screen.dart';
import 'auth_screens.dart';
import 'profile_sharing_screen.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  void _showSwitchProfileDialog(BuildContext context) {
    final state = AppState();
    final familyProfiles = state.allFamilyProfiles;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      backgroundColor: Colors.white,
      builder: (ctx) {
        return SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: const [
                  Icon(Icons.switch_account_outlined, color: HdfcColors.navy, size: 24),
                  SizedBox(width: 8),
                  Text(
                    'Switch Member Profile',
                    style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: HdfcColors.textDark),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              const Text(
                'Select a family member to view their portfolio perspective',
                style: TextStyle(fontSize: 12, color: HdfcColors.textMuted),
              ),
              const SizedBox(height: 16),
              ...familyProfiles.map((p) {
                final isCurrent = AppState.isOwnerMatch(p['name']!, state.userName);
                return ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  leading: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isCurrent ? HdfcColors.navy : const Color(0xFFF1F5F9),
                    ),
                    child: Icon(
                      Icons.person,
                      color: isCurrent ? Colors.white : HdfcColors.navy,
                      size: 22,
                    ),
                  ),
                  title: Text(
                    p['name']!,
                    style: TextStyle(
                      fontWeight: isCurrent ? FontWeight.bold : FontWeight.w600,
                      fontSize: 14,
                      color: isCurrent ? HdfcColors.navy : HdfcColors.textDark,
                    ),
                  ),
                  subtitle: Text(
                    p['role']!,
                    style: const TextStyle(fontSize: 11, color: HdfcColors.textMuted),
                  ),
                  trailing: isCurrent
                      ? const Icon(Icons.check_circle, color: HdfcColors.green, size: 20)
                      : const Icon(Icons.arrow_forward_ios, size: 12, color: HdfcColors.textSubtle),
                  onTap: () {
                    state.switchUser(p['name']!, p['phone']!);
                    Navigator.pop(ctx);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Switched active profile to ${p['name']}'),
                        backgroundColor: HdfcColors.navy,
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  },
                );
              }),
            ],
          ),
        );
      },
    );
  }

  void _showAddMemberDialog(BuildContext context) {
    final nameCtrl = TextEditingController();
    final phoneCtrl = TextEditingController();
    final pinCtrl = TextEditingController(text: '1234');
    String selectedRelation = 'Son';
    final relations = [
      'Father',
      'Mother',
      'Son',
      'Daughter',
      'Spouse',
      'Brother',
      'Sister',
      'Grandfather',
      'Grandmother',
      'Other'
    ];
    String? errorText;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      backgroundColor: Colors.white,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: EdgeInsets.fromLTRB(
                20,
                16,
                20,
                MediaQuery.of(ctx).viewInsets.bottom + 24,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: const [
                      Icon(Icons.person_add_outlined, color: HdfcColors.navy, size: 24),
                      SizedBox(width: 8),
                      Text(
                        'Add Family Member',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: HdfcColors.textDark),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Members will receive their own login credential (Name (Relation)) with real-time portfolio sync.',
                    style: TextStyle(fontSize: 12, color: HdfcColors.textMuted),
                  ),
                  if (errorText != null) ...[
                    const SizedBox(height: 10),
                    Text(errorText!, style: const TextStyle(color: HdfcColors.red, fontSize: 12, fontWeight: FontWeight.w600)),
                  ],
                  const SizedBox(height: 16),
                  const Text('Full Name *', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 6),
                  TextField(
                    controller: nameCtrl,
                    decoration: const InputDecoration(hintText: 'e.g. Rohan Guru'),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Relation *', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
                            const SizedBox(height: 6),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10),
                              decoration: BoxDecoration(
                                border: Border.all(color: HdfcColors.border),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton<String>(
                                  value: selectedRelation,
                                  isExpanded: true,
                                  items: relations
                                      .map((r) => DropdownMenuItem(value: r, child: Text(r, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600))))
                                      .toList(),
                                  onChanged: (v) {
                                    if (v != null) setModalState(() => selectedRelation = v);
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
                            const Text('Security PIN', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
                            const SizedBox(height: 6),
                            TextField(
                              controller: pinCtrl,
                              keyboardType: TextInputType.number,
                              maxLength: 4,
                              decoration: const InputDecoration(hintText: '1234', counterText: ''),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  const Text('Mobile Number (10 digits) *', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 6),
                  TextField(
                    controller: phoneCtrl,
                    keyboardType: TextInputType.phone,
                    decoration: const InputDecoration(hintText: 'e.g. 9876543215'),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(
                      onPressed: () async {
                        final name = nameCtrl.text.trim();
                        final phone = phoneCtrl.text.replaceAll(RegExp(r'\D'), '');
                        final pin = pinCtrl.text.trim().isEmpty ? '1234' : pinCtrl.text.trim();
                        if (name.isEmpty) {
                          setModalState(() => errorText = 'Please enter member full name');
                          return;
                        }
                        if (phone.length < 10) {
                          setModalState(() => errorText = 'Please enter a valid 10-digit mobile number');
                          return;
                        }
                        await AppState().addFamilyMember(
                          fullName: name,
                          relation: selectedRelation,
                          phone: phone,
                          pin: pin,
                        );
                        if (context.mounted) {
                          Navigator.pop(ctx);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('$name ($selectedRelation) added to Family Circle!'),
                              backgroundColor: HdfcColors.green,
                              behavior: SnackBarBehavior.floating,
                            ),
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(backgroundColor: HdfcColors.navy),
                      child: const Text('Add Family Member', style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Row(
          children: const [
            Icon(Icons.logout, color: HdfcColors.red, size: 22),
            SizedBox(width: 8),
            Text('Logout', style: TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
        content: const Text(
          'Are you sure you want to log out of your HDFC Family Asset Tracker account?',
          style: TextStyle(fontSize: 14, color: HdfcColors.textDark),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel', style: TextStyle(color: HdfcColors.textMuted)),
          ),
          ElevatedButton(
            onPressed: () {
              AppState().logout();
              Navigator.pop(ctx);
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (_) => const WelcomeScreen()),
                (route) => false,
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: HdfcColors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('Logout'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: AppState(),
      builder: (context, _) {
        final state = AppState();

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
                  'Settings',
                  style: TextStyle(color: HdfcColors.textDark, fontWeight: FontWeight.w800, fontSize: 18),
                ),
              ],
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.switch_account_outlined, color: HdfcColors.navy),
                tooltip: 'Switch Member',
                onPressed: () => _showSwitchProfileDialog(context),
              ),
              IconButton(
                icon: const Icon(Icons.logout_rounded, color: HdfcColors.red),
                tooltip: 'Logout',
                onPressed: () => _showLogoutDialog(context),
              ),
              const SizedBox(width: 4),
            ],
          ),
          body: SafeArea(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              children: [
                // User Wealth Profile Header
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [HdfcColors.navy, HdfcColors.deepNavy],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(14),
                    boxShadow: [
                      BoxShadow(
                        color: HdfcColors.navy.withValues(alpha: 0.2),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 52,
                        height: 52,
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.15),
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white.withValues(alpha: 0.3), width: 1.5),
                        ),
                        child: const Icon(Icons.person, color: Colors.white, size: 30),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              state.userName,
                              style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: Colors.white),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              'HDFC Imperia Family Office • +91 ${state.userPhone}',
                              style: const TextStyle(fontSize: 11, color: Color(0xFFCBD5E1)),
                            ),
                          ],
                        ),
                      ),
                      InkWell(
                        onTap: () => _showSwitchProfileDialog(context),
                        borderRadius: BorderRadius.circular(6),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: HdfcColors.lightGold,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: const Text(
                            'SWITCH',
                            style: TextStyle(fontSize: 9, fontWeight: FontWeight.w800, color: HdfcColors.gold),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 18),

                // Core Settings Options (From PDF Requirements)
                Material(
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                    side: const BorderSide(color: HdfcColors.border),
                  ),
                  child: Column(
                    children: [
                      ListTile(
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        leading: Container(
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(
                            color: const Color(0xFFF1F5F9),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Icon(Icons.person_outline_rounded, color: HdfcColors.navy, size: 24),
                        ),
                        title: const Text(
                          'Share My Profile',
                          style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14, color: HdfcColors.textDark),
                        ),
                        subtitle: const Text(
                          'Control what data is used in your portfolio',
                          style: TextStyle(fontSize: 12, color: HdfcColors.textMuted),
                        ),
                        trailing: const Icon(Icons.arrow_forward_ios, size: 14, color: HdfcColors.textSubtle),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => MemberDetailsScreen(
                                memberName: state.userName,
                                role: 'Primary Account Holder (Self)',
                              ),
                            ),
                          );
                        },
                      ),
                      const Divider(height: 1, indent: 64, color: HdfcColors.borderLight),
                      ListTile(
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        leading: Container(
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(
                            color: const Color(0xFFF1F5F9),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Icon(Icons.layers_outlined, color: HdfcColors.navy, size: 24),
                        ),
                        title: const Text(
                          'Manage Asset Types',
                          style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14, color: HdfcColors.textDark),
                        ),
                        subtitle: const Text(
                          'Add and manage asset types',
                          style: TextStyle(fontSize: 12, color: HdfcColors.textMuted),
                        ),
                        trailing: const Icon(Icons.arrow_forward_ios, size: 14, color: HdfcColors.textSubtle),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => const AssetTypesScreen()),
                          );
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // Family Circle & Member Details Section
                Material(
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                    side: const BorderSide(color: HdfcColors.border),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16, 14, 16, 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Expanded(
                              child: Text(
                                'Family Circle',
                                style: TextStyle(fontWeight: FontWeight.w800, fontSize: 14, color: HdfcColors.textDark),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                InkWell(
                                  onTap: () => _showAddMemberDialog(context),
                                  borderRadius: BorderRadius.circular(4),
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                    decoration: BoxDecoration(
                                      color: HdfcColors.lightRed,
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: const [
                                        Icon(Icons.person_add_alt_1, size: 13, color: HdfcColors.red),
                                        SizedBox(width: 4),
                                        Text(
                                          '+ Add Member',
                                          style: TextStyle(color: HdfcColors.red, fontWeight: FontWeight.bold, fontSize: 11),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                InkWell(
                                  onTap: () => _showSwitchProfileDialog(context),
                                  child: const Text('Switch Active', style: TextStyle(color: HdfcColors.navy, fontWeight: FontWeight.bold, fontSize: 12)),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const Divider(height: 1, color: HdfcColors.borderLight),
                      ...state.familyMembers.map((m) {
                        final isCurrent = AppState.isOwnerMatch(m.name, state.userName);
                        return ListTile(
                          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
                          leading: Container(
                            width: 36,
                            height: 36,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: isCurrent ? HdfcColors.navy : const Color(0xFFF1F5F9),
                              border: Border.all(color: isCurrent ? HdfcColors.navy : HdfcColors.border),
                            ),
                            child: Icon(
                              Icons.person_outline,
                              size: 20,
                              color: isCurrent ? Colors.white : HdfcColors.navy,
                            ),
                          ),
                          title: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  m.name,
                                  style: TextStyle(
                                    fontWeight: isCurrent ? FontWeight.w800 : FontWeight.w700,
                                    fontSize: 13,
                                    color: isCurrent ? HdfcColors.navy : HdfcColors.textDark,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              if (isCurrent)
                                Container(
                                  margin: const EdgeInsets.only(left: 6),
                                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
                                  decoration: BoxDecoration(
                                    color: HdfcColors.greenBg,
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: const Text(
                                    'ACTIVE',
                                    style: TextStyle(color: HdfcColors.green, fontSize: 9, fontWeight: FontWeight.w800),
                                  ),
                                ),
                            ],
                          ),
                          subtitle: Text(
                            isCurrent
                                ? '${m.role} • Logged In Profile'
                                : '${m.role} • ${state.canUserSeeMemberHoldings(m.name) ? "Holdings Shared" : "Holdings Private"}',
                            style: TextStyle(
                              fontSize: 11,
                              color: isCurrent
                                  ? HdfcColors.navy
                                  : (state.canUserSeeMemberHoldings(m.name) ? HdfcColors.textMuted : HdfcColors.red),
                              fontWeight: isCurrent ? FontWeight.w600 : FontWeight.normal,
                            ),
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.tune_rounded, size: 18, color: HdfcColors.navy),
                                tooltip: 'Details & Settings',
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => MemberDetailsScreen(memberName: m.name, role: m.role),
                                    ),
                                  );
                                },
                              ),
                              IconButton(
                                icon: const Icon(Icons.bar_chart_outlined, size: 18, color: HdfcColors.green),
                                tooltip: 'Holdings',
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => MemberHoldingsScreen(memberName: m.name),
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => MemberDetailsScreen(memberName: m.name, role: m.role),
                              ),
                            );
                          },
                        );
                      }),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // Quick Switch Profile Button
                OutlinedButton.icon(
                  onPressed: () => _showSwitchProfileDialog(context),
                  icon: const Icon(Icons.people_alt_outlined, size: 18),
                  label: const Text('Switch Family Member Profile'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: HdfcColors.navy,
                    side: const BorderSide(color: HdfcColors.navy, width: 1.2),
                    padding: const EdgeInsets.symmetric(vertical: 13),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                ),
                const SizedBox(height: 12),

                // Explicit Logout Button
                OutlinedButton.icon(
                  onPressed: () => _showLogoutDialog(context),
                  icon: const Icon(Icons.logout, size: 18, color: HdfcColors.red),
                  label: const Text('Logout', style: TextStyle(color: HdfcColors.red, fontWeight: FontWeight.bold)),
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: HdfcColors.red.withValues(alpha: 0.5)),
                    padding: const EdgeInsets.symmetric(vertical: 13),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                ),
                const SizedBox(height: 20),

                // Production Security Footer
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: HdfcColors.border),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.verified_user_outlined, size: 28, color: HdfcColors.navy),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Text(
                              'HDFC Bank 256-Bit Financial Privacy',
                              style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: HdfcColors.textDark),
                            ),
                            SizedBox(height: 2),
                            Text(
                              'Your asset records are protected with bank-grade encryption and access controls.',
                              style: TextStyle(fontSize: 11, color: HdfcColors.textMuted, height: 1.2),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        );
      },
    );
  }
}
