import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'clipboard_provider.dart';
import 'main_navigation.dart';


void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => ClipboardProvider(),
      child: ClipboardSyncApp(),
    ),
  );
}

class ClipboardSyncApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Clipboard Sync',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MainNavigation(),
    );
  }
}