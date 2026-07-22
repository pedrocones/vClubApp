import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';

class LanguageSelectorWidget extends StatelessWidget {
  const LanguageSelectorWidget({super.key});

  static const Map<String, Map<String, String>> langMetadata = {
    'en': {'flag': '🇺🇸', 'name': 'ENG'},
    'es': {'flag': '🇪🇸', 'name': 'ESP'},
    'fr': {'flag': '🇫🇷', 'name': 'FRA'},
    'hi': {'flag': '🇮🇳', 'name': 'HIN'},
    'ar': {'flag': '🇸🇦', 'name': 'ARA'},
    'zn': {'flag': '🇨🇳', 'name': 'ZHO'},
  };

  @override
  Widget build(BuildContext context) {
    // 1. Watch the provider for the current session language
    final auth = context.watch<AppAuthProvider>();
    final currentLang = auth.currentLanguage;
    final metadata = langMetadata[currentLang] ?? langMetadata['en']!;

    return PopupMenuButton<String>(
      tooltip: "Change Language",
      onSelected: (String newLang) {
        // 2. Update the provider (Session only)
        context.read<AppAuthProvider>().updateLanguage(newLang);
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
        child: Row(
          children: [
            Text(metadata['flag']!, style: const TextStyle(fontSize: 20)),
            const SizedBox(width: 6),
            Text(
              metadata['name']!,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 13,
              ),
            ),
            const Icon(Icons.arrow_drop_down, color: Colors.white70, size: 18),
          ],
        ),
      ),
      itemBuilder: (context) => langMetadata.entries.map((entry) {
        return PopupMenuItem<String>(
          value: entry.key,
          child: Row(
            children: [
              Text(entry.value['flag']!),
              const SizedBox(width: 12),
              Text(entry.value['name']!),
            ],
          ),
        );
      }).toList(),
    );
  }
}
