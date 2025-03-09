import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'clipboard_provider.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadClipboardContent();
  }

  Future<void> _loadClipboardContent() async {
    setState(() {
      _isLoading = true;
    });
    try {
      await context.read<ClipboardProvider>().fetchClipboardHistory();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to load clipboard content: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _addToClipboard(String content) async {
    setState(() {
      _isLoading = true;
    });
    try {
      await context.read<ClipboardProvider>().addToHistory(content);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Successfully added to clipboard history!'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to add clipboard content: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final clipboardProvider = context.watch<ClipboardProvider>();
    final clipboardHistory = clipboardProvider.clipboardHistory;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Home',
          style: TextStyle(
            fontFamily: 'Poppins',
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Clipboard Content:',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 20),
              _isLoading
                  ? CircularProgressIndicator()
                  : Expanded(
                child: ListView.builder(
                  itemCount: clipboardHistory.length,
                  itemBuilder: (context, index) {
                    final item = clipboardHistory[index];
                    return ListTile(
                      title: Text(
                        item,
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 18,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      trailing: IconButton(
                        icon: Icon(Icons.content_copy),
                        onPressed: () async {
                          await Clipboard.setData(ClipboardData(text: item));
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Copied to clipboard: $item'),
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final content = 'New Clipboard Item';
          await _addToClipboard(content);
        },
        child: Icon(Icons.add),
      ),
    );
  }
}