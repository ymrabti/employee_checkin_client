import "package:flutter/services.dart";
// ignore: duplicate_import
import "package:flutter/services.dart";
import "package:employee_checks/lib.dart";

class UsernameFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    // Example: Allows only alphanumeric characters and underscores
    final String newText = newValue.text.replaceAll(RegExp(r'[^a-zA-Z0-9_]'), '');

    // Return the updated text
    return newValue.copyWith(
      text: newText,
      selection: TextSelection.collapsed(offset: newText.length),
    );
  }
}

class PhoneNumberFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    // Remove all non-digit characters from the input
    String digits = newValue.text.replaceAll(RegExp(r'\D'), '');

    String formatted = digits.replaceAllMapped(RegExp(r'(\d{2})(\d{2})(\d{2})(\d{2})(\d{2})'), (Match match) {
      return '${match[1]} ${match[2]} ${match[3]} ${match[4]} ${match[5]}';
    });

    // Ensure only up to 10 digits are considered
    if (digits.length <= 10) {
      formatted = digits.replaceAllMapped(RegExp(r'(\d{2})(\d{2})(\d{2})(\d{2})?(\d{2})?'), (Match match) {
        return <String?>[match[1], match[2], match[3], match[4], match[5]].where((String? e) => e != null).join(' ');
      });
    }

    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }

  static String? validator(BuildContext context, String? value) {
    // Validation for non-empty input
    if (value == null || value.isEmpty) {
      return context.tr.enterPhoneNumberText;
    }
    // Validation for length
    if (value.replaceAll(' ', '').length != 10) {
      return context.tr.phoneNumberLengthText;
    }
    // Validation for starting with 0
    if (!value.startsWith('0')) {
      return context.tr.phoneNumberStartWithText;
    }
    return null;
  }
}
