import 'dart:async';
import 'package:flutter/material.dart';
import '../models/app_state.dart';
import '../services/local_database.dart';
import '../theme/hdfc_theme.dart';
import '../utils/validators.dart';
import 'main_navigation_screen.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const HdfcFullLogoWidget(height: 22),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: HdfcColors.lightRed,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: const Text(
                      'WEALTH',
                      style: TextStyle(
                        fontSize: 9,
                        fontWeight: FontWeight.bold,
                        color: HdfcColors.red,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                ],
              ),
              Column(
                children: [
                  Container(
                    width: 96,
                    height: 96,
                    decoration: BoxDecoration(
                      color: const Color(0xFFF8FAFC),
                      border: Border.all(color: HdfcColors.border, width: 2),
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                          color: HdfcColors.navy.withValues(alpha: 0.08),
                          blurRadius: 16,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        const Positioned(
                          top: 14,
                          child: Icon(Icons.roofing_rounded, size: 42, color: HdfcColors.navy),
                        ),
                        Positioned(
                          bottom: 16,
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Container(width: 6, height: 16, decoration: BoxDecoration(color: HdfcColors.red, borderRadius: BorderRadius.circular(2))),
                              const SizedBox(width: 4),
                              Container(width: 6, height: 28, decoration: BoxDecoration(color: HdfcColors.navy, borderRadius: BorderRadius.circular(2))),
                              const SizedBox(width: 4),
                              Container(width: 6, height: 20, decoration: BoxDecoration(color: HdfcColors.gold, borderRadius: BorderRadius.circular(2))),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 28),
                  const Text(
                    'Family Asset Tracker',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.w800,
                      letterSpacing: -0.5,
                      color: HdfcColors.textDark,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Track. Manage. Grow Together.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 15,
                      color: HdfcColors.textMuted,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF1F5F9),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: const [
                        Icon(Icons.shield_outlined, size: 14, color: HdfcColors.navy),
                        SizedBox(width: 6),
                        Text(
                          'Bank-Grade 256-Bit SSL Protection',
                          style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: HdfcColors.navy),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Column(
                children: [
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const LoginScreen()),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: HdfcColors.navy,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        elevation: 1,
                      ),
                      child: const Text('Login', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
                    ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: OutlinedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const SignUpScreen()),
                        );
                      },
                      style: OutlinedButton.styleFrom(
                        foregroundColor: HdfcColors.navy,
                        side: const BorderSide(color: HdfcColors.navy, width: 1.4),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text('Sign Up', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
                    ),
                  ),
                  const SizedBox(height: 14),
                  const Text(
                    'Regulated by Reserve Bank of India (RBI)',
                    style: TextStyle(fontSize: 11, color: HdfcColors.textSubtle, fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _phoneController = TextEditingController(text: '9876543210');
  final _pinController = TextEditingController(text: '1234');
  bool _obscurePin = true;
  String? _phoneError;
  String? _pinError;
  String? _authError;
  bool _isLoading = false;

  @override
  void dispose() {
    _phoneController.dispose();
    _pinController.dispose();
    super.dispose();
  }

  Future<void> _onLogin() async {
    setState(() {
      _phoneError = FormValidators.validateMobile(_phoneController.text);
      _pinError = FormValidators.validatePin(_pinController.text);
      _authError = null;
    });

    if (_phoneError != null || _pinError != null) {
      return;
    }

    setState(() => _isLoading = true);

    final cleanPhone = _phoneController.text.replaceAll(RegExp(r'\D'), '');
    final pin = _pinController.text.trim();

    // Authenticate with local database
    final db = LocalDatabase.instance;
    await db.init();
    final user = await db.authenticateUser(cleanPhone, pin);

    setState(() => _isLoading = false);

    if (user != null) {
      AppState().login(user['fullName'] as String, cleanPhone);
      if (!mounted) return;
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const MainNavigationScreen()),
        (route) => false,
      );
    } else {
      // Check if user exists but PIN was wrong
      final exists = await db.userExists(cleanPhone);
      setState(() {
        if (!exists) {
          _authError = 'Mobile number not registered in local database. Please Sign Up.';
        } else {
          _authError = 'Incorrect PIN. Default PIN is 1234. Please try again.';
        }
      });
    }
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
            Text('Login', style: TextStyle(color: HdfcColors.textDark, fontSize: 17, fontWeight: FontWeight.w700)),
          ],
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 12),
              const Center(
                child: Text(
                  'Welcome Back!',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: HdfcColors.textDark),
                ),
              ),
              const SizedBox(height: 4),
              const Center(
                child: Text(
                  'Access your consolidated family wealth portfolio',
                  style: TextStyle(fontSize: 13, color: HdfcColors.textMuted),
                ),
              ),
              // Quick Family Member Account Selector
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                decoration: BoxDecoration(
                  color: const Color(0xFFF8FAFC),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: HdfcColors.border),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: const [
                        Icon(Icons.family_restroom, size: 16, color: HdfcColors.navy),
                        SizedBox(width: 6),
                        Text(
                          'Quick Family Account Login (PIN: 1234)',
                          style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: HdfcColors.textDark),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: AppState().allFamilyProfiles.map((p) {
                          return Padding(
                            padding: const EdgeInsets.only(right: 8.0),
                            child: _buildAccountChip(p['name']!, p['phone']!),
                          );
                        }).toList(),
                      ),
                    ),
                  ],
                ),
              ),
              if (_authError != null) ...[
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: HdfcColors.lightRed,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: HdfcColors.red.withValues(alpha: 0.3)),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.error_outline, size: 18, color: HdfcColors.red),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          _authError!,
                          style: const TextStyle(fontSize: 12, color: HdfcColors.red, fontWeight: FontWeight.w600),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 14),
              ],

              const Text('Mobile Number', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: HdfcColors.textDark)),
              const SizedBox(height: 8),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: _phoneError != null ? HdfcColors.red : HdfcColors.border),
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.white,
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 13),
                      decoration: const BoxDecoration(
                        border: Border(right: BorderSide(color: HdfcColors.border)),
                      ),
                      child: Row(
                        children: const [
                          Text('+91', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14, color: HdfcColors.textDark)),
                          SizedBox(width: 4),
                          Icon(Icons.keyboard_arrow_down, size: 16, color: HdfcColors.textMuted),
                        ],
                      ),
                    ),
                    Expanded(
                      child: TextField(
                        controller: _phoneController,
                        keyboardType: TextInputType.phone,
                        maxLength: 10,
                        onChanged: (_) {
                          if (_phoneError != null) setState(() => _phoneError = null);
                        },
                        decoration: const InputDecoration(
                          counterText: '',
                          hintText: 'Enter 10-digit mobile number',
                          border: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(horizontal: 14),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              if (_phoneError != null)
                Padding(
                  padding: const EdgeInsets.only(top: 6, left: 4),
                  child: Text(_phoneError!, style: const TextStyle(color: HdfcColors.red, fontSize: 12)),
                ),

              const SizedBox(height: 18),
              const Text('PIN', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: HdfcColors.textDark)),
              const SizedBox(height: 8),
              TextField(
                controller: _pinController,
                obscureText: _obscurePin,
                keyboardType: TextInputType.number,
                maxLength: 6,
                onChanged: (_) {
                  if (_pinError != null) setState(() => _pinError = null);
                },
                decoration: InputDecoration(
                  counterText: '',
                  hintText: 'Enter 4-6 digit MPIN',
                  errorText: _pinError,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                  suffixIcon: IconButton(
                    icon: Icon(_obscurePin ? Icons.visibility_outlined : Icons.visibility_off_outlined, color: HdfcColors.textMuted),
                    onPressed: () => setState(() => _obscurePin = !_obscurePin),
                  ),
                ),
              ),

              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Default PIN is 1234 for all accounts (Shiva Guru (Self), Sunita Guru (Mother), Rajesh Guru (Father), Aarav Guru (Son), Ananya Guru (Daughter))'),
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  },
                  child: const Text('Forgot PIN?', style: TextStyle(color: HdfcColors.navy, fontSize: 13, fontWeight: FontWeight.w600)),
                ),
              ),
              const SizedBox(height: 32),

              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _onLogin,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: HdfcColors.navy,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  child: _isLoading
                      ? const SizedBox(width: 22, height: 22, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2.5))
                      : const Text('Login', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
                ),
              ),
              const SizedBox(height: 16),
              Center(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text('New to Family Asset Tracker? ', style: TextStyle(color: HdfcColors.textMuted, fontSize: 13)),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (_) => const SignUpScreen()),
                        );
                      },
                      child: const Text(
                        'Sign Up',
                        style: TextStyle(color: HdfcColors.red, fontWeight: FontWeight.bold, fontSize: 13),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAccountChip(String name, String phone) {
    final isSelected = _phoneController.text == phone;
    return InkWell(
      onTap: () {
        setState(() {
          _phoneController.text = phone;
          _pinController.text = '1234';
          _phoneError = null;
          _pinError = null;
          _authError = null;
        });
      },
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? HdfcColors.navy : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: isSelected ? HdfcColors.navy : HdfcColors.border),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.person, size: 14, color: isSelected ? Colors.white : HdfcColors.navy),
            const SizedBox(width: 4),
            Text(
              name,
              style: TextStyle(
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                color: isSelected ? Colors.white : HdfcColors.textDark,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _nameController = TextEditingController(text: 'Shiva Guru');
  final _phoneController = TextEditingController(text: '9876543210');
  final _pinController = TextEditingController(text: '1234');
  bool _obscurePin = true;

  String? _nameError;
  String? _phoneError;
  String? _pinError;

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _pinController.dispose();
    super.dispose();
  }

  void _onSignUpPressed() {
    setState(() {
      _nameError = FormValidators.validateFullName(_nameController.text);
      _phoneError = FormValidators.validateMobile(_phoneController.text);
      _pinError = FormValidators.validatePin(_pinController.text);
    });

    if (_nameError != null || _phoneError != null || _pinError != null) {
      return;
    }

    _showOtpVerificationDialog();
  }

  void _showOtpVerificationDialog() {
    final cleanPhone = _phoneController.text.replaceAll(RegExp(r'\D'), '');
    final maskedPhone = cleanPhone.length == 10
        ? '+91 ${cleanPhone.substring(0, 2)}****${cleanPhone.substring(6)}'
        : '+91 $cleanPhone';

    final otpController = TextEditingController(text: '482619');
    String? otpError;
    int secondsRemaining = 30;
    Timer? countdownTimer;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      backgroundColor: Colors.white,
      builder: (bottomSheetContext) {
        return StatefulBuilder(
          builder: (ctx, setModalState) {
            countdownTimer ??= Timer.periodic(const Duration(seconds: 1), (t) {
              if (secondsRemaining > 0) {
                setModalState(() => secondsRemaining--);
              } else {
                t.cancel();
              }
            });

            return Padding(
              padding: EdgeInsets.fromLTRB(
                24,
                20,
                24,
                MediaQuery.of(ctx).viewInsets.bottom + 28,
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
                  const SizedBox(height: 20),
                  Row(
                    children: const [
                      Icon(Icons.mark_email_unread_outlined, size: 28, color: HdfcColors.navy),
                      SizedBox(width: 10),
                      Text(
                        'Verify Mobile OTP',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: HdfcColors.textDark),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'An SMS with a 6-digit OTP was sent to $maskedPhone',
                    style: const TextStyle(fontSize: 13, color: HdfcColors.textMuted),
                  ),
                  const SizedBox(height: 16),

                  // Demo OTP Helper Pill
                  InkWell(
                    onTap: () {
                      setModalState(() {
                        otpController.text = '482619';
                        otpError = null;
                      });
                    },
                    borderRadius: BorderRadius.circular(8),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        color: HdfcColors.lightGold,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: HdfcColors.gold.withValues(alpha: 0.3)),
                      ),
                      child: Row(
                        children: const [
                          Icon(Icons.touch_app_outlined, size: 16, color: HdfcColors.gold),
                          SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'Demo OTP: 482619 (Tap to Auto-fill)',
                              style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: HdfcColors.gold),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 18),

                  const Text(
                    'Enter 6-Digit OTP',
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: HdfcColors.textDark),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: otpController,
                    keyboardType: TextInputType.number,
                    maxLength: 6,
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, letterSpacing: 8),
                    decoration: InputDecoration(
                      counterText: '',
                      hintText: '••••••',
                      errorText: otpError,
                    ),
                    onChanged: (val) {
                      if (otpError != null) setModalState(() => otpError = null);
                    },
                  ),
                  const SizedBox(height: 12),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        secondsRemaining > 0 ? 'Resend code in ${secondsRemaining}s' : 'Didn\'t receive OTP?',
                        style: const TextStyle(fontSize: 12, color: HdfcColors.textMuted),
                      ),
                      TextButton(
                        onPressed: secondsRemaining == 0
                            ? () {
                                setModalState(() => secondsRemaining = 30);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('New OTP sent to mobile number.')),
                                );
                              }
                            : null,
                        child: const Text('Resend OTP', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () async {
                        final err = FormValidators.validateOtp(otpController.text, '482619');
                        if (err != null) {
                          setModalState(() => otpError = err);
                          return;
                        }

                        countdownTimer?.cancel();
                        Navigator.pop(bottomSheetContext);

                        // Save user in LocalDatabase
                        final db = LocalDatabase.instance;
                        final name = _nameController.text.trim();
                        final pin = _pinController.text.trim();
                        await db.createUser(
                          fullName: name,
                          phone: cleanPhone,
                          pin: pin,
                          role: 'Member',
                        );
                        if (!AppState().familyMembers.any((m) => AppState.isOwnerMatch(m.name, name))) {
                          await AppState().addFamilyMember(
                            fullName: name,
                            relation: 'Member',
                            phone: cleanPhone,
                            pin: pin,
                          );
                        }

                        _showAccountCreatedDialog();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: HdfcColors.navy,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                      child: const Text('Verify & Create Account', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700)),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    ).then((_) {
      countdownTimer?.cancel();
    });
  }

  void _showAccountCreatedDialog() {
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
                'Account Created Successfully!',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold, color: HdfcColors.textDark),
              ),
              const SizedBox(height: 8),
              const Text(
                'You can now start tracking and managing your family assets.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14, color: HdfcColors.textMuted),
              ),
              const SizedBox(height: 28),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    AppState().login(_nameController.text, _phoneController.text);
                    Navigator.pop(ctx);
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (_) => const MainNavigationScreen()),
                      (route) => false,
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: HdfcColors.navy,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  child: const Text('Continue', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
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
            Text('Sign Up', style: TextStyle(color: HdfcColors.textDark, fontSize: 17, fontWeight: FontWeight.w700)),
          ],
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 12),
              const Center(
                child: Text(
                  'Create Your Account',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: HdfcColors.textDark),
                ),
              ),
              const SizedBox(height: 4),
              const Center(
                child: Text(
                  'Setup your secure family portfolio in minutes',
                  style: TextStyle(fontSize: 13, color: HdfcColors.textMuted),
                ),
              ),
              const SizedBox(height: 28),
              const Text('Full Name', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: HdfcColors.textDark)),
              const SizedBox(height: 8),
              TextField(
                controller: _nameController,
                onChanged: (_) {
                  if (_nameError != null) setState(() => _nameError = null);
                },
                decoration: InputDecoration(
                  hintText: 'Enter your full name',
                  errorText: _nameError,
                ),
              ),
              const SizedBox(height: 18),
              const Text('Mobile Number', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: HdfcColors.textDark)),
              const SizedBox(height: 8),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: _phoneError != null ? HdfcColors.red : HdfcColors.border),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 13),
                      decoration: const BoxDecoration(
                        border: Border(right: BorderSide(color: HdfcColors.border)),
                      ),
                      child: Row(
                        children: const [
                          Text('+91', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14, color: HdfcColors.textDark)),
                          SizedBox(width: 4),
                          Icon(Icons.keyboard_arrow_down, size: 16, color: HdfcColors.textMuted),
                        ],
                      ),
                    ),
                    Expanded(
                      child: TextField(
                        controller: _phoneController,
                        keyboardType: TextInputType.phone,
                        maxLength: 10,
                        onChanged: (_) {
                          if (_phoneError != null) setState(() => _phoneError = null);
                        },
                        decoration: const InputDecoration(
                          counterText: '',
                          hintText: 'Enter 10-digit mobile number',
                          border: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(horizontal: 14),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              if (_phoneError != null)
                Padding(
                  padding: const EdgeInsets.only(top: 6, left: 4),
                  child: Text(_phoneError!, style: const TextStyle(color: HdfcColors.red, fontSize: 12)),
                ),

              const SizedBox(height: 18),
              const Text('Create PIN', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: HdfcColors.textDark)),
              const SizedBox(height: 8),
              TextField(
                controller: _pinController,
                obscureText: _obscurePin,
                keyboardType: TextInputType.number,
                maxLength: 6,
                onChanged: (_) {
                  if (_pinError != null) setState(() => _pinError = null);
                },
                decoration: InputDecoration(
                  counterText: '',
                  hintText: '•••••',
                  helperText: 'Use a 4–6 digit PIN',
                  errorText: _pinError,
                  helperStyle: const TextStyle(color: HdfcColors.textMuted, fontSize: 12),
                  suffixIcon: IconButton(
                    icon: Icon(_obscurePin ? Icons.visibility_outlined : Icons.visibility_off_outlined, color: HdfcColors.textMuted),
                    onPressed: () => setState(() => _obscurePin = !_obscurePin),
                  ),
                ),
              ),
              const SizedBox(height: 36),

              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: _onSignUpPressed,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: HdfcColors.navy,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  child: const Text('Sign Up', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
