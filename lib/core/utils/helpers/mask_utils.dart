class MaskUtils {
  static String maskPhone(String phone) {
    if (phone.length < 4) return phone;

    final start = phone.substring(0, 2);
    final end = phone.substring(phone.length - 2);
    final maskedLength = phone.length - 4;

    return "$start${'*' * maskedLength}$end";
  }

  static String maskEmail(String email) {
    if (!email.contains("@")) return email;

    final parts = email.split("@");
    final username = parts[0];
    final domain = parts[1];

    if (username.length <= 2) {
      return "$username****@$domain";
    }

    final visible = username.substring(0, 2);
    final hidden = "*" * (username.length - 2);

    return "$visible$hidden@$domain";
  }
}
