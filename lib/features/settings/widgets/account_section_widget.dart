import 'package:flutter/material.dart';
import 'package:to_do_app/features/settings/widgets/settings_section_widget.dart';

class AccountSection extends StatelessWidget {
  const AccountSection({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        SettingsTile(icon: Icons.person, title: 'Change account name'),
        SettingsTile(icon: Icons.lock, title: 'Change account password'),
        SettingsTile(icon: Icons.image, title: 'Change account image'),
      ],
    );
  }
}
