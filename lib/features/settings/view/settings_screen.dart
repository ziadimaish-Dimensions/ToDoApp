import 'package:flutter/material.dart';
import 'package:to_do_app/features/settings/widgets/account_section_widget.dart';
import 'package:to_do_app/features/settings/widgets/logout_button.dart';
import 'package:to_do_app/features/settings/widgets/profile_header_widget.dart';
import 'package:to_do_app/features/settings/widgets/settings_section_widget.dart';
import 'package:to_do_app/features/settings/widgets/update_section_widget.dart';

/// The `SettingsScreen` displays the user's profile settings, including options
/// to change the username, password, account image, and to log out.
/// It also includes sections for app settings and other information.

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          automaticallyImplyLeading: false,
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
              SizedBox(height: 20),
              SettingsSection(),
              AccountSection(),
              UpdateSectionWidget(),
              LogoutButton(),
            ],
          ),
        ),
      ),
    );
  }
}
