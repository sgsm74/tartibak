import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tartibak/l10n.dart';
import 'package:tartibak/viewmodels/locale_provider.dart';
import '../viewmodels/settings_view_model.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> with TickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<Offset> _titleOffset;
  late final Animation<double> _titleOpacity;
  late final Animation<Offset> _listOffset;
  late final Animation<double> _listOpacity;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(duration: const Duration(milliseconds: 900), vsync: this)..forward();

    _titleOffset = Tween<Offset>(
      begin: const Offset(0, -0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: const Interval(0, 0.4, curve: Curves.easeOut)));

    _titleOpacity = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(parent: _controller, curve: const Interval(0, 0.4, curve: Curves.easeIn)));

    _listOffset = Tween<Offset>(
      begin: const Offset(0, 0.5),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: const Interval(0.4, 1.0, curve: Curves.easeOut)));

    _listOpacity = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(parent: _controller, curve: const Interval(0.4, 1.0, curve: Curves.easeIn)));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<SettingsViewModel>();
    final colorScheme = Theme.of(context).colorScheme;
    final theme = Theme.of(context);
    final localeProvider = context.watch<LocaleProvider>();
    final loc = AppLocalizations(Localizations.localeOf(context));

    return Scaffold(
      appBar: AppBar(),
      extendBodyBehindAppBar: true,
      body: Stack(
        fit: StackFit.expand,
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [colorScheme.primaryContainer, colorScheme.secondaryContainer],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),

          // پنل بلور با شفافیت
          Center(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(32),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
                child: Container(
                  width: MediaQuery.sizeOf(context).width * 0.9,
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: colorScheme.surface.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(32),
                    border: Border.all(color: colorScheme.onSurface.withOpacity(0.15)),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // عنوان با انیمیشن اسلاید و فید
                      SlideTransition(
                        position: _titleOffset,
                        child: FadeTransition(
                          opacity: _titleOpacity,
                          child: Text(
                            loc.get('settings')!,
                            style: theme.textTheme.headlineMedium?.copyWith(
                              color: colorScheme.onSurface,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'IranSans',
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 24),

                      // لیست تنظیمات با انیمیشن اسلاید و فید
                      SlideTransition(
                        position: _listOffset,
                        child: FadeTransition(
                          opacity: _listOpacity,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Card(
                                color: colorScheme.secondaryContainer,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                                elevation: 4,
                                child: SwitchListTile(
                                  contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                                  title: Text(
                                    loc.get('dark_theme')!,
                                    style: theme.textTheme.titleMedium?.copyWith(
                                      fontWeight: FontWeight.w600,
                                      color: colorScheme.onSecondaryContainer,
                                    ),
                                  ),
                                  secondary: Icon(
                                    settings.themeMode == ThemeMode.dark ? Icons.dark_mode : Icons.light_mode,
                                    color: colorScheme.primary,
                                  ),
                                  value: settings.themeMode == ThemeMode.dark,
                                  onChanged: (val) => settings.toggleTheme(val),
                                  activeColor: colorScheme.primary,
                                ),
                              ),
                              const SizedBox(height: 16),
                              Card(
                                color: colorScheme.secondaryContainer,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                                elevation: 4,
                                child: SwitchListTile(
                                  contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                                  title: Text(
                                    loc.get('click_sound')!,
                                    style: theme.textTheme.titleMedium?.copyWith(
                                      fontWeight: FontWeight.w600,
                                      color: colorScheme.onSecondaryContainer,
                                    ),
                                  ),
                                  secondary: Icon(Icons.volume_up, color: colorScheme.primary),
                                  value: settings.soundEnabled,
                                  onChanged: (val) => settings.toggleSound(val),
                                  activeColor: colorScheme.primary,
                                ),
                              ),
                              const SizedBox(height: 16),
                              Card(
                                color: colorScheme.secondaryContainer,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                                elevation: 4,
                                child: SwitchListTile(
                                  contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                                  title: Text(
                                    loc.get('vibration')!,
                                    style: theme.textTheme.titleMedium?.copyWith(
                                      fontWeight: FontWeight.w600,
                                      color: colorScheme.onSecondaryContainer,
                                    ),
                                  ),
                                  secondary: Icon(Icons.vibration, color: colorScheme.primary),
                                  value: settings.vibrationEnabled,
                                  onChanged: (val) => settings.toggleVibration(val),
                                  activeColor: colorScheme.primary,
                                ),
                              ),
                              const SizedBox(height: 24),
                              Card(
                                color: colorScheme.secondaryContainer,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                                elevation: 4,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                  child: DropdownButtonFormField<Locale>(
                                    decoration: InputDecoration(
                                      labelText: loc.get('language'),
                                      labelStyle: theme.textTheme.titleMedium?.copyWith(color: colorScheme.onSecondaryContainer),
                                      prefixIcon: Icon(Icons.language, color: colorScheme.primary),
                                      border: InputBorder.none,
                                    ),
                                    value: localeProvider.locale,
                                    isExpanded: true,
                                    items: const [
                                      DropdownMenuItem(value: Locale('fa'), child: Text('فارسی')),
                                      DropdownMenuItem(value: Locale('en'), child: Text('English')),
                                    ],
                                    onChanged: (locale) {
                                      if (locale != null) {
                                        localeProvider.setLocale(locale);
                                      }
                                    },
                                    style: theme.textTheme.bodyLarge?.copyWith(color: colorScheme.onSecondaryContainer),
                                    dropdownColor: colorScheme.secondaryContainer,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
