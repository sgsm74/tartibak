import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/settings_view_model.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<SettingsViewModel>();
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text("تنظیمات", style: TextStyle(fontWeight: FontWeight.bold, color: colorScheme.onSurface, fontFamily: 'IranSans')),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
      ),
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            children: [
              Card(
                color: colorScheme.secondaryContainer,
                child: SwitchListTile(
                  title: const Text('تم تاریک', style: TextStyle(fontWeight: FontWeight.w600)),
                  secondary: Icon(settings.themeMode == ThemeMode.dark ? Icons.dark_mode : Icons.light_mode, color: colorScheme.primary),
                  value: settings.themeMode == ThemeMode.dark,
                  onChanged: (val) => settings.toggleTheme(val),
                  activeColor: colorScheme.primary,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                ),
              ),
              const SizedBox(height: 16),
              Card(
                color: colorScheme.secondaryContainer,
                child: SwitchListTile(
                  title: const Text('صدای کلیک', style: TextStyle(fontWeight: FontWeight.w600)),
                  secondary: Icon(Icons.volume_up, color: colorScheme.primary),
                  value: settings.soundEnabled,
                  onChanged: (val) => settings.toggleSound(val),
                  activeColor: colorScheme.primary,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                ),
              ),
              const SizedBox(height: 16),
              Card(
                color: colorScheme.secondaryContainer,
                child: SwitchListTile(
                  title: const Text('ویبره', style: TextStyle(fontWeight: FontWeight.w600)),
                  secondary: Icon(Icons.vibration, color: colorScheme.primary),
                  value: settings.vibrationEnabled,
                  onChanged: (val) => settings.toggleVibration(val),
                  activeColor: colorScheme.primary,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
