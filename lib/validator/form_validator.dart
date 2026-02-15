class FormValidator {
  static String? email(String? value) {
    if (value == null || value.isEmpty) {
      return "Email is required!";
    }
    if (!value.contains("@")) {
      return "Enter valid email!";
    }
    return null;
  }

  static String? password(String? value) {
    if (value == null || value.isEmpty) {
      return "Password is required!";
    }
    return null;
  }

  static String? username(String? value) {
    if (value == null || value.isEmpty) {
      return "Username is required!";
    }
    return null;
  }
}
