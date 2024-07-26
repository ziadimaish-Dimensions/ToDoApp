import 'package:flutter/material.dart';
import 'package:to_do_app/features/settings/widgets/settings_section_widget.dart';

class UptodoSection extends StatelessWidget {
  const UptodoSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: const [
        SettingsTile(icon: Icons.info, title: 'About US'),
        SettingsTile(icon: Icons.help, title: 'FAQ'),
        SettingsTile(icon: Icons.feedback, title: 'Help & Feedback'),
        SettingsTile(icon: Icons.support, title: 'Support US'),
      ],
    );
  }
}
