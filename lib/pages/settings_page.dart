import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tartibak/l10n.dart';
import 'package:tartibak/viewmodels/locale_provider.dart';
import '../viewmodels/settings_view_model.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<SettingsViewModel>();
    final colorScheme = Theme.of(context).colorScheme;
    final localeProvider = context.watch<LocaleProvider>();
    final loc = AppLocalizations(Localizations.localeOf(context));

    return Scaffold(
      appBar: AppBar(
        title: Text(
          '${loc.get('settings')}',
          style: TextStyle(fontWeight: FontWeight.bold, color: colorScheme.onSurface, fontFamily: 'IranSans'),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Column(
          children: [
            Card(
              color: colorScheme.secondaryContainer,
              child: SwitchListTile(
                title: Text('${loc.get('dark_theme')}', style: TextStyle(fontWeight: FontWeight.w600)),
                secondary: Icon(settings.themeMode == ThemeMode.dark ? Icons.dark_mode : Icons.light_mode, color: colorScheme.primary),
                value: settings.themeMode == ThemeMode.dark,
                onChanged: (val) => settings.toggleTheme(val),
                activeColor: colorScheme.primary,
              ),
            ),
            const SizedBox(height: 16),
            Card(
              color: colorScheme.secondaryContainer,
              child: SwitchListTile(
                title: Text('${loc.get('click_sound')}', style: TextStyle(fontWeight: FontWeight.w600)),
                secondary: Icon(Icons.volume_up, color: colorScheme.primary),
                value: settings.soundEnabled,
                onChanged: (val) => settings.toggleSound(val),
                activeColor: colorScheme.primary,
              ),
            ),
            const SizedBox(height: 16),
            Card(
              color: colorScheme.secondaryContainer,
              child: SwitchListTile(
                title: Text('${loc.get('vibration')}', style: TextStyle(fontWeight: FontWeight.w600)),
                secondary: Icon(Icons.vibration, color: colorScheme.primary),
                value: settings.vibrationEnabled,
                onChanged: (val) => settings.toggleVibration(val),
                activeColor: colorScheme.primary,
              ),
            ),
            const SizedBox(height: 16),
            Card(
              color: colorScheme.secondaryContainer,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: DropdownButtonFormField<Locale>(
                  decoration: InputDecoration(
                    labelText: loc.get('language'),
                    prefixIcon: Icon(Icons.language, color: colorScheme.primary),
                    border: InputBorder.none,
                  ),
                  value: localeProvider.locale,
                  isExpanded: false,
                  items: const [
                    DropdownMenuItem(value: Locale('fa'), child: Text('فارسی')),
                    DropdownMenuItem(value: Locale('en'), child: Text('English')),
                  ],
                  onChanged: (locale) {
                    if (locale != null) {
                      localeProvider.setLocale(locale);
                    }
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
