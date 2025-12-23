import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../data/location_service.dart';
import '../data/sun_time_service.dart';

enum DayPhase {
  brahmaMuhurtam,
  sunrise,
  day,
  sunset,
  night,
  unknown
}

class TimePhaseProvider extends ChangeNotifier {
  final LocationService _locationService = LocationService();
  final SunTimeService _sunTimeService = SunTimeService();

  DateTime? _sunrise;
  DateTime? _sunset;
  DateTime? _brahmaMuhurtamStart;
  DateTime? _brahmaMuhurtamEnd;

  DayPhase _currentPhase = DayPhase.unknown;
  String _locationName = "Loading...";

  DayPhase get currentPhase => _currentPhase;
  DateTime? get sunrise => _sunrise;
  DateTime? get sunset => _sunset;
  DateTime? get brahmaMuhurtamStart => _brahmaMuhurtamStart;
  DateTime? get brahmaMuhurtamEnd => _brahmaMuhurtamEnd;
  String get locationName => _locationName;

  TimePhaseProvider() {
    _init();
  }

  Future<void> _init() async {
    // Default to Bangalore if location fails
    double lat = 12.9716;
    double lng = 77.5946;
    _locationName = "Bangalore (Default)";

    try {
      final position = await _locationService.getCurrentLocation();
      if (position != null) {
        lat = position.latitude;
        lng = position.longitude;
        _locationName = "Current Location";
      }
    } catch (e) {
      print("Location error: $e");
    }

    final times = await _sunTimeService.getSunTimes(lat, lng);
    if (times != null) {
      _sunrise = times['sunrise'];
      _sunset = times['sunset'];

      // Calculate Brahma Muhurtam: 96 minutes (2 muhurtas) before sunrise?
      // Actually BM starts 96 mins before sunrise and ends 48 mins before sunrise (approx).
      // Or it is the last quarter of the night.
      // Common definition: Starts 1 hour 36 mins before sunrise, ends 48 mins before sunrise.

      if (_sunrise != null) {
        _brahmaMuhurtamStart = _sunrise!.subtract(const Duration(minutes: 96));
        _brahmaMuhurtamEnd = _sunrise!.subtract(const Duration(minutes: 48));
        _updatePhase();
      }
    }
    notifyListeners();
  }

  void _updatePhase() {
    final now = DateTime.now();

    if (_brahmaMuhurtamStart != null && _brahmaMuhurtamEnd != null) {
      if (now.isAfter(_brahmaMuhurtamStart!) && now.isBefore(_brahmaMuhurtamEnd!)) {
        _currentPhase = DayPhase.brahmaMuhurtam;
      } else if (now.isAfter(_brahmaMuhurtamEnd!) && now.isBefore(_sunrise!.add(const Duration(minutes: 30)))) {
        // Sunrise phase (approx 30 mins window around sunrise)
        _currentPhase = DayPhase.sunrise;
      } else if (now.isAfter(_sunrise!) && now.isBefore(_sunset!)) {
        _currentPhase = DayPhase.day;
      } else if (now.isAfter(_sunset!) && now.isBefore(_sunset!.add(const Duration(minutes: 40)))) {
        _currentPhase = DayPhase.sunset;
      } else {
        _currentPhase = DayPhase.night;
      }
    }
    notifyListeners();
  }
}
