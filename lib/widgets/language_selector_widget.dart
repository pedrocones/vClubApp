import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/language_app_state.dart'; // Mapped cleanly to your providers folder paths

class LanguageSelectorWidget extends StatelessWidget {
  const LanguageSelectorWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final languageState = context.watch<LanguageAppState>();
    final currentLang = languageState.currentLanguageCode;

    // Localized hover configurations
    final String tooltipMessage = currentLang == 'es'
        ? 'Cambiar idioma del sistema'
        : 'Change system language';

    return Tooltip(
      message: tooltipMessage,
      waitDuration: const Duration(
        milliseconds: 600,
      ), // Standard delay boundary before displaying tooltip
      child: PopupMenuButton<String>(
        // 💡 FIXED: 'value' changed to 'initialValue' to match standard PopupMenuButton properties
        initialValue: currentLang,
        icon: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              currentLang == 'es' ? '🇪🇸' : '🇺🇸',
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(width: 6),
            Text(
              currentLang == 'es' ? 'ESP' : 'ENG',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 13,
                color: Colors.blue,
              ),
            ),
            const Icon(Icons.arrow_drop_down, size: 16, color: Colors.blue),
          ],
        ),
        onSelected: (String nextLanguageCode) {
          context.read<LanguageAppState>().updateLanguage(nextLanguageCode);
        },
        itemBuilder: (BuildContext context) => [
          const PopupMenuItem<String>(
            value: 'en',
            child: Row(
              children: [
                Text('🇺🇸 ', style: TextStyle(fontSize: 16)),
                SizedBox(width: 8),
                Text(
                  'English (ENG)',
                  style: TextStyle(fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ),
          const PopupMenuItem<String>(
            value: 'es',
            child: Row(
              children: [
                Text('🇪🇸 ', style: TextStyle(fontSize: 16)),
                SizedBox(width: 8),
                Text(
                  'Español (ESP)',
                  style: TextStyle(fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
