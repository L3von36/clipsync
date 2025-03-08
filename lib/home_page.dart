import 'package:flutter/material.dart';
import 'package:clipboard_watcher/clipboard_watcher.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import 'clipboard_provider.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with ClipboardListener {
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    clipboardWatcher.addListener(this);
    clipboardWatcher.start();
    _loadClipboardContent();
  }

  @override
  void dispose() {
    clipboardWatcher.removeListener(this);
    clipboardWatcher.stop();
    super.dispose();
  }

  void _loadClipboardContent() async {
    setState(() {
      _isLoading = true;
    });
    final content = await Clipboard.getData('text/plain');
    await Future.delayed(Duration(seconds: 1)); // Simulate loading delay
    if (content != null) {
      context.read<ClipboardProvider>().updateClipboardContent(content.text!);
    }
    setState(() {
      _isLoading = false;
    });
  }

  @override
  void onClipboardChanged() {
    _loadClipboardContent();
  }

  @override
  Widget build(BuildContext context) {
    final clipboardContent = context.watch<ClipboardProvider>().clipboardContent;
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Clipboard Content:',
                style: GoogleFonts.poppins(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 20),
              _isLoading
                  ? CircularProgressIndicator()
                  : Text(
                clipboardContent,
                style: GoogleFonts.poppins(fontSize: 18),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _loadClipboardContent,
        child: Icon(Icons.refresh),
      ),
    );
  }
}