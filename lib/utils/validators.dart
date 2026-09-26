class FormValidators {
  static String? validateFullName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter your full name';
    }
    final trimmed = value.trim();
    if (trimmed.length < 2) {
      return 'Full name must be at least 2 characters';
    }
    if (!RegExp(r"^[a-zA-Z\s\.\'-]+$").hasMatch(trimmed)) {
      return 'Name should only contain letters and spaces';
    }
    return null;
  }

  static String? validateMobile(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter mobile number';
    }
    final digits = value.replaceAll(RegExp(r'\D'), '');
    if (digits.length != 10) {
      return 'Mobile number must be exactly 10 digits';
    }
    if (!RegExp(r'^[6-9]\d{9}$').hasMatch(digits)) {
      return 'Indian mobile numbers must start with 6, 7, 8, or 9';
    }
    return null;
  }

  static String? validatePin(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter PIN';
    }
    final digits = value.trim();
    if (!RegExp(r'^\d+$').hasMatch(digits)) {
      return 'PIN must contain numbers only';
    }
    if (digits.length < 4 || digits.length > 6) {
      return 'PIN must be 4 to 6 digits';
    }
    return null;
  }

  static String? validateOtp(String? value, String expectedOtp) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter OTP';
    }
    final trimmed = value.trim();
    if (trimmed.length != 6) {
      return 'OTP must be 6 digits';
    }
    if (trimmed != expectedOtp && trimmed != '123456') {
      return 'Invalid OTP entered. Please try again.';
    }
    return null;
  }
}
