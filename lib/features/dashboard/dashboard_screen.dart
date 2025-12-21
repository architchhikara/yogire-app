import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../domain/time_phase_provider.dart';
import 'sun_dial_widget.dart';
import 'package:intl/intl.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Yogi Re Companion"),
        actions: [
          IconButton(icon: const Icon(Icons.person), onPressed: () {}),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Date Header
            Text(
              DateFormat('EEEE, d MMMM').format(DateTime.now()),
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontSize: 18),
            ),
            const SizedBox(height: 20),

            // Sun Dial
            Consumer<TimePhaseProvider>(
              builder: (context, provider, child) {
                return Column(
                  children: [
                    SunDialWidget(
                      phase: provider.currentPhase,
                      sunrise: provider.sunrise,
                      sunset: provider.sunset,
                      bmStart: provider.brahmaMuhurtamStart,
                    ),
                    const SizedBox(height: 10),
                    Text(
                      provider.locationName,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    if (provider.brahmaMuhurtamStart != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Text(
                          "Brahma Muhurtam: ${DateFormat('h:mm a').format(provider.brahmaMuhurtamStart!)}",
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                  ],
                );
              },
            ),

            const SizedBox(height: 30),

            // Quote Card
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    const Icon(Icons.format_quote, color: Colors.orange, size: 30),
                    const SizedBox(height: 10),
                    Text(
                      "The only way to experience true wellbeing is to turn inward. This is what Yoga means – not up, not out, but in.",
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            fontStyle: FontStyle.italic,
                          ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 10),
                    Text(
                      "- Sadhguru",
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
