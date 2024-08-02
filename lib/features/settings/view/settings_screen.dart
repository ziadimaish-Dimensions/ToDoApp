import 'package:flutter/material.dart';
import 'package:to_do_app/features/settings/widgets/account_section_widget.dart';
import 'package:to_do_app/features/settings/widgets/logout_button.dart';
import 'package:to_do_app/features/settings/widgets/profile_header_widget.dart';
import 'package:to_do_app/features/settings/widgets/settings_section_widget.dart';
import 'package:to_do_app/features/settings/widgets/task_info_widget.dart';
import 'package:to_do_app/features/settings/widgets/update_section_widget.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        title: const Text(
          'Profile',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: const SingleChildScrollView(
        child: Column(
          children: [
            ProfileHeader(),
            TaskInfo(),
            SettingsSection(),
            AccountSection(),
            UptodoSection(),
            LogoutButton(),
          ],
        ),
      ),
    );
  }
}
