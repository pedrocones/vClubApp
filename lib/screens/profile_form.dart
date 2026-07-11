import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:geolocator/geolocator.dart';
import '../providers/auth_provider.dart';

class ProfileFormScreen extends StatefulWidget {
  const ProfileFormScreen({super.key});

  @override
  State<ProfileFormScreen> createState() => _ProfileFormScreenState();
}

class _ProfileFormScreenState extends State<ProfileFormScreen> {
  final _userController = TextEditingController();
  final _locationController = TextEditingController();
  late String _coachId;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Retrieve query parameter from current URL string
    final uri = GoRouterState.of(context).uri;
    _coachId = uri.queryParameters['coach'] ?? 'none';
  }

  // 🗺️ Network Location Auto-Detection Method
  Future<void> _detectCurrentLocation() async {
    try {
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      if (permission == LocationPermission.always ||
          permission == LocationPermission.whileInUse) {
        Position position = await Geolocator.getCurrentPosition();
        if (!mounted) return;
        setState(() {
          // Temporarily store raw coordinates until reversed to municipal strings in step 3
          _locationController.text =
              '${position.latitude.toStringAsFixed(4)}, ${position.longitude.toStringAsFixed(4)}';
        });
      }
    } catch (e) {
      debugPrint('Location detection error fallback: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final authProv = context.watch<AppAuthProvider>();

    return Scaffold(
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 450),
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Complete Profile',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                TextField(
                  controller: _userController,
                  decoration: const InputDecoration(labelText: 'Username'),
                ),
                const SizedBox(height: 10),
                TextFormField(
                  initialValue: _coachId,
                  enabled: false,
                  decoration: const InputDecoration(labelText: 'Your Coach'),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _locationController,
                        decoration: const InputDecoration(
                          labelText: 'Municipal Location',
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.my_location, color: Colors.indigo),
                      onPressed: _detectCurrentLocation,
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () async {
                    await authProv.saveProfileMetadata(
                      username: _userController.text,
                      coachId: _coachId,
                      location: _locationController.text,
                    );
                    if (context.mounted) context.go('/');
                  },
                  child: const Text('Save and Finish'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
