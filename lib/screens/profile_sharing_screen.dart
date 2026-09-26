import 'package:flutter/material.dart';
import '../models/app_state.dart';
import '../services/local_database.dart';
import '../theme/hdfc_theme.dart';
import 'add_holding_screen.dart';

class MemberDetailsScreen extends StatefulWidget {
  final String memberName;
  final String role;

  const MemberDetailsScreen({
    super.key,
    this.memberName = 'Mother',
    this.role = 'Member',
  });

  @override
  State<MemberDetailsScreen> createState() => _MemberDetailsScreenState();
}

class _MemberDetailsScreenState extends State<MemberDetailsScreen> {
  late String _currentName;
  late String _currentRole;

  @override
  void initState() {
    super.initState();
    _currentName = widget.memberName;
    _currentRole = widget.role;
  }

  void _showEditProfileDialog() {
    final nameController = TextEditingController(text: _currentName);
    const availableRoles = [
      'Self',
      'Mother',
      'Father',
      'Son',
      'Daughter',
      'Primary Account Holder (Self)',
      'Spouse / Guardian',
      'Primary Guardian',
      'Member',
      'Brother',
      'Sister',
    ];
    String selectedRole = availableRoles.contains(_currentRole) ? _currentRole : 'Member';
    final initialPhone = LocalDatabase.familyDirectory.entries
        .firstWhere(
          (e) => AppState.isOwnerMatch(e.value['fullName'] ?? '', _currentName),
          orElse: () => const MapEntry('9876543210', {}),
        )
        .key;
    final phoneController = TextEditingController(text: initialPhone);

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
                24,
                20,
                24,
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
                  const SizedBox(height: 18),
                  const Text(
                    'Edit Member Profile',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: HdfcColors.textDark),
                  ),
                  const SizedBox(height: 16),
                  const Text('Member Name', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 6),
                  TextField(
                    controller: nameController,
                    decoration: const InputDecoration(hintText: 'Enter name'),
                  ),
                  const SizedBox(height: 14),
                  const Text('Role', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 6),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      border: Border.all(color: HdfcColors.border),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: selectedRole,
                        isExpanded: true,
                        items: availableRoles
                            .map((r) => DropdownMenuItem(value: r, child: Text(r, style: const TextStyle(fontSize: 14))))
                            .toList(),
                        onChanged: (val) {
                          if (val != null) setModalState(() => selectedRole = val);
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),
                  const Text('Mobile Number', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 6),
                  TextField(
                    controller: phoneController,
                    keyboardType: TextInputType.phone,
                    decoration: const InputDecoration(hintText: 'Enter 10-digit mobile number'),
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(
                      onPressed: () {
                        if (nameController.text.trim().isNotEmpty) {
                          final newName = nameController.text.trim();
                          final newPhone = phoneController.text.trim();
                          AppState().updateMember(_currentName, newName, selectedRole, newPhone);
                          setState(() {
                            _currentName = newName;
                            _currentRole = selectedRole;
                          });
                          Navigator.pop(ctx);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Member profile for $newName updated successfully!'),
                              backgroundColor: HdfcColors.green,
                              behavior: SnackBarBehavior.floating,
                            ),
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(backgroundColor: HdfcColors.navy),
                      child: const Text('Save Changes', style: TextStyle(fontWeight: FontWeight.bold)),
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

  void _showRemoveConfirmation() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Remove Member?', style: TextStyle(fontWeight: FontWeight.bold)),
        content: Text('Are you sure you want to remove $_currentName from your family portfolio?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel', style: TextStyle(color: HdfcColors.textMuted)),
          ),
          ElevatedButton(
            onPressed: () {
              final removedName = _currentName;
              AppState().removeMember(removedName);
              Navigator.pop(ctx); // Close dialog
              Navigator.pop(context); // Go back to Settings
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('$removedName was removed from family portfolio.'),
                  backgroundColor: HdfcColors.red,
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: HdfcColors.red),
            child: const Text('Remove'),
          ),
        ],
      ),
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
              'Member Details',
              style: TextStyle(color: HdfcColors.textDark, fontSize: 17, fontWeight: FontWeight.w700),
            ),
          ],
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          children: [
            const SizedBox(height: 12),
            Center(
              child: Stack(
                children: [
                  Container(
                    width: 92,
                    height: 92,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: HdfcColors.navy.withValues(alpha: 0.3), width: 2.5),
                      color: const Color(0xFFF1F5F9),
                    ),
                    child: const Icon(Icons.person, size: 56, color: HdfcColors.navy),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: InkWell(
                      onTap: _showEditProfileDialog,
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: HdfcColors.navy,
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 2),
                        ),
                        child: const Icon(Icons.edit, size: 14, color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Center(
              child: Text(
                _currentName,
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: HdfcColors.textDark),
              ),
            ),
            Center(
              child: Container(
                margin: const EdgeInsets.only(top: 4),
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                decoration: BoxDecoration(
                  color: const Color(0xFFF1F5F9),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '$_currentRole • Family Circle',
                  style: const TextStyle(fontSize: 12, color: HdfcColors.textMuted, fontWeight: FontWeight.w600),
                ),
              ),
            ),
            const SizedBox(height: 28),

            // Option 1: Share My Profile
            _buildOptionTile(
              icon: Icons.people_outline,
              title: 'Share My Profile',
              subtitle: 'Control who can see my holdings',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => ShareMyProfileScreen(memberName: _currentName)),
                );
              },
            ),
            const SizedBox(height: 12),

            // Option 2: My Holdings (Fully working view)
            _buildOptionTile(
              icon: Icons.bar_chart_outlined,
              title: 'My Holdings',
              subtitle: 'View and manage my assets',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => MemberHoldingsScreen(memberName: _currentName)),
                );
              },
            ),
            const SizedBox(height: 12),

            // Option 3: Edit Profile (Fully working modal)
            _buildOptionTile(
              icon: Icons.edit_note_outlined,
              title: 'Edit Profile',
              subtitle: 'Update name, mobile number',
              onTap: _showEditProfileDialog,
            ),
            const SizedBox(height: 12),

            // Option 4: Remove Member (With confirmation dialog)
            _buildOptionTile(
              icon: Icons.delete_outline_rounded,
              title: 'Remove Member',
              subtitle: 'Remove from family',
              isDestructive: true,
              onTap: _showRemoveConfirmation,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOptionTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    bool isDestructive = false,
  }) {
    return Material(
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(color: HdfcColors.border),
      ),
      child: ListTile(
        onTap: onTap,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        leading: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: isDestructive ? HdfcColors.lightRed : const Color(0xFFF1F5F9),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: isDestructive ? HdfcColors.red : HdfcColors.navy, size: 20),
        ),
        title: Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 14,
            color: isDestructive ? HdfcColors.red : HdfcColors.textDark,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: const TextStyle(fontSize: 12, color: HdfcColors.textMuted),
        ),
        trailing: const Icon(Icons.arrow_forward_ios, size: 14, color: HdfcColors.textSubtle),
      ),
    );
  }
}

class MemberHoldingsScreen extends StatelessWidget {
  final String memberName;
  const MemberHoldingsScreen({super.key, required this.memberName});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: AppState(),
      builder: (context, _) {
        final state = AppState();
        final canView = state.canUserSeeMemberHoldings(memberName);

        if (!canView) {
          return Scaffold(
            backgroundColor: HdfcColors.bg,
            appBar: AppBar(
              backgroundColor: Colors.white,
              elevation: 0,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back_ios_new, size: 18, color: HdfcColors.navy),
                onPressed: () => Navigator.pop(context),
              ),
              title: Text(
                '$memberName\'s Holdings',
                style: const TextStyle(color: HdfcColors.textDark, fontSize: 17, fontWeight: FontWeight.w700),
              ),
            ),
            body: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 36),
                  decoration: HdfcStyles.cardDecoration,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 68,
                        height: 68,
                        decoration: BoxDecoration(
                          color: const Color(0xFFFEF2F2),
                          shape: BoxShape.circle,
                          border: Border.all(color: const Color(0xFFFECACA), width: 1.5),
                        ),
                        child: const Icon(Icons.lock_outline_rounded, size: 34, color: HdfcColors.red),
                      ),
                      const SizedBox(height: 18),
                      const Text(
                        'Holdings Not Shared',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: HdfcColors.textDark),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        '$memberName has set their profile visibility to private for your account (${state.userName}). Their holdings and asset values cannot be viewed.',
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontSize: 13, color: HdfcColors.textMuted, height: 1.4),
                      ),
                      const SizedBox(height: 24),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: () => Navigator.pop(context),
                          icon: const Icon(Icons.arrow_back, size: 16),
                          label: const Text('Back to Family Circle'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: HdfcColors.navy,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        }

        final memberHoldings = state.holdings
            .where((h) => AppState.isOwnerMatch(h.owner, memberName))
            .toList();
        final totalVal = memberHoldings.fold(0.0, (acc, h) => acc + h.totalValue);

        return Scaffold(
          backgroundColor: HdfcColors.bg,
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new, size: 18, color: HdfcColors.navy),
              onPressed: () => Navigator.pop(context),
            ),
            title: Text(
              '$memberName\'s Holdings',
              style: const TextStyle(color: HdfcColors.textDark, fontSize: 17, fontWeight: FontWeight.w700),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.add_circle_outline, color: HdfcColors.navy),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => AddHoldingScreen(initialOwner: memberName)),
                  );
                },
              ),
            ],
          ),
          body: SafeArea(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: HdfcStyles.cardDecoration,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Total Assets for $memberName', style: const TextStyle(fontSize: 13, color: HdfcColors.textMuted)),
                      const SizedBox(height: 6),
                      Text(
                        _formatCr(totalVal),
                        style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: HdfcColors.textDark),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 18),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Holdings (${memberHoldings.length})',
                      style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: HdfcColors.textDark),
                    ),
                    TextButton.icon(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => AddHoldingScreen(initialOwner: memberName)),
                        );
                      },
                      icon: const Icon(Icons.add, size: 16, color: HdfcColors.navy),
                      label: const Text('Add Holding', style: TextStyle(color: HdfcColors.navy, fontWeight: FontWeight.bold, fontSize: 12)),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                if (memberHoldings.isEmpty)
                  Container(
                    padding: const EdgeInsets.all(32),
                    alignment: Alignment.center,
                    decoration: HdfcStyles.cardDecoration,
                    child: Column(
                      children: [
                        const Icon(Icons.account_balance_wallet_outlined, size: 44, color: HdfcColors.textSubtle),
                        const SizedBox(height: 10),
                        Text('No holdings registered for $memberName', style: const TextStyle(color: HdfcColors.textMuted, fontSize: 13)),
                        const SizedBox(height: 14),
                        ElevatedButton.icon(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (_) => AddHoldingScreen(initialOwner: memberName)),
                            );
                          },
                          icon: const Icon(Icons.add, size: 16),
                          label: const Text('Add Holding for this Member'),
                        ),
                      ],
                    ),
                  )
                else
                  Material(
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: const BorderSide(color: HdfcColors.border),
                    ),
                    child: ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: memberHoldings.length,
                      separatorBuilder: (_, index) => const Divider(height: 1, color: HdfcColors.borderLight),
                      itemBuilder: (ctx, i) {
                        final h = memberHoldings[i];
                        return ListTile(
                          contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
                          leading: Container(
                            width: 38,
                            height: 38,
                            decoration: BoxDecoration(
                              color: const Color(0xFFF1F5F9),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Icon(Icons.bar_chart_rounded, color: HdfcColors.navy, size: 20),
                          ),
                          title: Text(h.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                          subtitle: Text('${h.type} • ${h.quantity} units', style: const TextStyle(fontSize: 12, color: HdfcColors.textMuted)),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                '₹${h.totalValue.toStringAsFixed(0)}',
                                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                              ),
                              PopupMenuButton<String>(
                                icon: const Icon(Icons.more_horiz, color: HdfcColors.textSubtle, size: 18),
                                onSelected: (val) {
                                  if (val == 'edit') {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => AddHoldingScreen(
                                          initialHolding: h,
                                          initialOwner: memberName,
                                        ),
                                      ),
                                    );
                                  } else if (val == 'delete') {
                                    state.removeHolding(h.id);
                                    ScaffoldMessenger.of(context).clearSnackBars();
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text('${h.name} removed from $memberName\'s holdings'),
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
                            ],
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

  String _formatCr(double val) {
    if (val >= 10000000) {
      return '₹${(val / 10000000).toStringAsFixed(2)} Cr';
    } else if (val >= 100000) {
      return '₹${(val / 100000).toStringAsFixed(2)} L';
    }
    return '₹${val.toStringAsFixed(0)}';
  }
}

class ShareMyProfileScreen extends StatelessWidget {
  final String? memberName;
  const ShareMyProfileScreen({super.key, this.memberName});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: AppState(),
      builder: (context, _) {
        final state = AppState();
        final currentOwner = (memberName != null && memberName!.isNotEmpty)
            ? memberName!
            : state.userName;

        // All other family members from the full family circle
        final otherMembers = state.allFamilyProfiles
            .where((p) => !AppState.isOwnerMatch(p['name']!, currentOwner))
            .toList();

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
                  'Share My Profile',
                  style: TextStyle(color: HdfcColors.textDark, fontSize: 17, fontWeight: FontWeight.w700),
                ),
              ],
            ),
            centerTitle: true,
          ),
          body: SafeArea(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              children: [
                const SizedBox(height: 8),
                Center(
                  child: Container(
                    width: 76,
                    height: 76,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: HdfcColors.navy.withValues(alpha: 0.3), width: 2),
                      color: const Color(0xFFF1F5F9),
                    ),
                    child: const Icon(Icons.person, size: 46, color: HdfcColors.navy),
                  ),
                ),
                const SizedBox(height: 8),
                Center(
                  child: Text(
                    currentOwner,
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: HdfcColors.textDark),
                  ),
                ),
                const SizedBox(height: 4),
                const Center(
                  child: Text(
                    'Control which family members can view your holdings & portfolio.',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 13, color: HdfcColors.textMuted),
                  ),
                ),
                const SizedBox(height: 24),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF1F5F9),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Family Members',
                        style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13, color: HdfcColors.textDark),
                      ),
                      Text(
                        '${otherMembers.length} Members in Circle',
                        style: const TextStyle(fontSize: 11, color: HdfcColors.textMuted, fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                Material(
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: const BorderSide(color: HdfcColors.border),
                  ),
                  child: ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: otherMembers.length,
                    separatorBuilder: (_, index) => const Divider(height: 1, color: HdfcColors.borderLight),
                    itemBuilder: (ctx, i) {
                      final m = otherMembers[i];
                      final targetName = m['name']!;
                      final targetRole = m['role'] ?? 'Member';
                      final isShared = state.isProfileSharedWith(owner: currentOwner, target: targetName);

                      return ListTile(
                        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
                        leading: Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: isShared ? HdfcColors.border : const Color(0xFFFECACA)),
                            color: isShared ? const Color(0xFFF8FAFC) : const Color(0xFFFEF2F2),
                          ),
                          child: Icon(
                            isShared ? Icons.person_outline : Icons.person_off_outlined,
                            size: 22,
                            color: isShared ? HdfcColors.navy : HdfcColors.red,
                          ),
                        ),
                        title: Row(
                          children: [
                            Flexible(
                              child: Text(
                                targetName,
                                style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14, color: HdfcColors.textDark),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: isShared ? HdfcColors.greenBg : const Color(0xFFFEE2E2),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                isShared ? 'SHARED' : 'HIDDEN',
                                style: TextStyle(
                                  fontSize: 9,
                                  fontWeight: FontWeight.w800,
                                  color: isShared ? HdfcColors.green : HdfcColors.red,
                                ),
                              ),
                            ),
                          ],
                        ),
                        subtitle: Text(
                          isShared
                              ? '$targetRole • Can view your holdings'
                              : '$targetRole • Cannot view your holdings',
                          style: TextStyle(
                            fontSize: 11,
                            color: isShared ? HdfcColors.textMuted : HdfcColors.red,
                            fontWeight: isShared ? FontWeight.normal : FontWeight.w600,
                          ),
                        ),
                        trailing: Switch(
                          value: isShared,
                          activeThumbColor: HdfcColors.green,
                          activeTrackColor: HdfcColors.greenBg,
                          inactiveThumbColor: Colors.white,
                          inactiveTrackColor: HdfcColors.border,
                          onChanged: (val) {
                            state.setProfileSharing(owner: currentOwner, target: targetName, isShared: val);
                            ScaffoldMessenger.of(context).hideCurrentSnackBar();
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                backgroundColor: HdfcColors.deepNavy,
                                behavior: SnackBarBehavior.floating,
                                content: Row(
                                  children: [
                                    Icon(
                                      val ? Icons.check_circle_outline : Icons.visibility_off_outlined,
                                      color: Colors.white,
                                      size: 18,
                                    ),
                                    const SizedBox(width: 8),
                                    const Expanded(
                                      child: Text(
                                        'Visibility settings updated successfully.',
                                        style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w500),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 20),
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF8FAFC),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: HdfcColors.border),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Icon(Icons.shield_outlined, size: 18, color: HdfcColors.navy),
                      SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          'Directional Privacy: Turning off visibility for a member hides your portfolio and holdings from them. You will still be able to view their holdings unless they also choose to turn off sharing with you.',
                          style: TextStyle(fontSize: 12, color: HdfcColors.textMuted, height: 1.4),
                        ),
                      ),
                    ],
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
