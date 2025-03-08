import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import 'clipboard_provider.dart';

class SettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final clipboardProvider = context.watch<ClipboardProvider>();
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Sync Settings',
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SwitchListTile(
              title: Text('Enable Sync'),
              value: clipboardProvider.isSyncEnabled,
              onChanged: (value) {
                clipboardProvider.toggleSync(value);
              },
            ),
            SizedBox(height: 20),
            Text(
              'Other Settings',
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            ListTile(
              title: Text('Clear History'),
              onTap: () {
                clipboardProvider.clearHistory();
              },
            ),
            SwitchListTile(
              title: Text('Dark Mode'),
              value: clipboardProvider.isDarkMode,
              onChanged: (value) {
                clipboardProvider.toggleTheme(value);
              },
            ),
          ],
        ),
      ),
    );
  }
}