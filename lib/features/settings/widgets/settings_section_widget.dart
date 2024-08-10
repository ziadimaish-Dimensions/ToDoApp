import 'package:flutter/material.dart';

/// The `SettingsSection` represents a section of settings options within the profile.
/// It includes tiles for navigating to specific app settings.

class SettingsSection extends StatelessWidget {
  const SettingsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        SettingsTile(icon: Icons.settings, title: 'App Settings'),
      ],
    );
  }
}

/// The `SettingsTile` is a reusable widget that displays an icon, title, and
/// navigates to another screen or performs an action when tapped.

class SettingsTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback? onTap;

  const SettingsTile({
    super.key,
    required this.icon,
    required this.title,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: Colors.white),
      title: Text(title, style: const TextStyle(color: Colors.white)),
      trailing: const Icon(Icons.arrow_forward_ios, color: Colors.white),
      onTap: onTap,
    );
  }
}
