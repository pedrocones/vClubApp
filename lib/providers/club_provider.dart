import 'package:flutter/material.dart';

// A simple template definition for your local hub content
class ClubEvent {
  final String id;
  final String title;
  final String description;
  final String date;
  final String assetImage;

  ClubEvent({
    required this.id,
    required this.title,
    required this.description,
    required this.date,
    required this.assetImage,
  });
}

class ClubProvider extends ChangeNotifier {
  // Central simulated data cache representing incoming network / database payloads
  final List<ClubEvent> _localEvents = [
    ClubEvent(
      id: 'ev-1',
      title: 'Loving Local Living Clean Up',
      description:
          'Join your neighbors at the central park commons for our monthly green space restoration day.',
      date: 'Saturday, Aug 15 at 9:00 AM',
      assetImage: 'assets/branding/strongerTogether.png',
    ),
    ClubEvent(
      id: 'ev-2',
      title: 'Vicinum Annual Membership Drive',
      description:
          'Help us grow our local footprint! Learn about volunteer tiers, local sponsorships, and civic benefits.',
      date: 'Friday, Sep 4 at 6:00 PM',
      assetImage: 'assets/branding/vicinumShield_TranspBG.png',
    ),
  ];

  bool _isLoading = false;

  // Public Getters to securely expose internal states to your UI screens
  List<ClubEvent> get localEvents => [..._localEvents];
  bool get isLoading => _isLoading;

  // A framework method ready to wire into your future backend (Firebase / REST API)
  Future<void> fetchUpcomingEvents() async {
    _isLoading = true;
    notifyListeners();

    // Simulating a minor network response latency delay
    await Future.delayed(const Duration(seconds: 1));

    // Here is where you will map backend JSON arrays to your ClubEvent model classes

    _isLoading = false;
    notifyListeners(); // Tells Flutter screens to automatically redraw with new data
  }
}
