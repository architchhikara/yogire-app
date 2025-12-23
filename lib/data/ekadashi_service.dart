class EkadashiService {
  // Hardcoded Ekadashi dates for 2025 (Sample)
  // In a real app, this should be fetched from a reliable API or calculated using Tithi logic.
  static final List<DateTime> _ekadashiDates2025 = [
    DateTime(2025, 1, 11), // Pausha Putrada Ekadashi
    DateTime(2025, 1, 25), // Shattila Ekadashi
    DateTime(2025, 2, 9),  // Jaya Ekadashi
    DateTime(2025, 2, 24), // Vijaya Ekadashi
    DateTime(2025, 3, 11), // Amalaki Ekadashi
    DateTime(2025, 3, 25), // Papmochani Ekadashi
    DateTime(2025, 4, 9),  // Kamada Ekadashi
    DateTime(2025, 4, 23), // Varuthini Ekadashi
    // ... add more as needed
  ];

  static List<DateTime> getUpcomingEkadashis() {
    final now = DateTime.now();
    return _ekadashiDates2025.where((date) => date.isAfter(now)).toList();
  }

  static bool isEkadashi(DateTime date) {
    return _ekadashiDates2025.any((d) =>
      d.year == date.year && d.month == date.month && d.day == date.day);
  }
}
