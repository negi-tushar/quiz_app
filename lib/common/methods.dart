String getFirstName(String fullName) {
  if (fullName.trim().isEmpty) {
    return 'Guest';
  } else {
    List<String> parts = fullName.trim().split(RegExp(r'\s+'));
    // If there are parts, return the first one. Otherwise, return an empty string.
    return parts.isNotEmpty ? parts.first : 'Guest';
  }
}
