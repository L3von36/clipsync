import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ClipboardProvider with ChangeNotifier {
  String _clipboardContent = '';
  List<String> _clipboardHistory = [];
  bool _isSyncEnabled = true;
  String? _deletedItem;
  bool _isDarkMode = false;

  String get clipboardContent => _clipboardContent;
  List<String> get clipboardHistory => _clipboardHistory;
  bool get isSyncEnabled => _isSyncEnabled;
  String? get deletedItem => _deletedItem;
  bool get isDarkMode => _isDarkMode;

  // Keys for shared preferences
  static const String _historyKey = 'clipboardHistory';
  static const String _themeKey = 'isDarkMode';
  static const String _syncKey = 'isSyncEnabled';

  ClipboardProvider() {
    _loadHistory();
    _loadTheme();
    _loadSync();
  }

  // Load history from shared preferences
  Future<void> _loadHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final history = prefs.getStringList(_historyKey) ?? [];
    _clipboardHistory = history;
    notifyListeners();
  }

  // Save history to shared preferences
  Future<void> _saveHistory() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_historyKey, _clipboardHistory);
  }

  // Load theme from shared preferences
  Future<void> _loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    _isDarkMode = prefs.getBool(_themeKey) ?? false;
    notifyListeners();
  }

  // Save theme to shared preferences
  Future<void> _saveTheme() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_themeKey, _isDarkMode);
  }

  // Load sync preference from shared preferences
  Future<void> _loadSync() async {
    final prefs = await SharedPreferences.getInstance();
    _isSyncEnabled = prefs.getBool(_syncKey) ?? true;
    notifyListeners();
  }

  // Save sync preference to shared preferences
  Future<void> _saveSync() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_syncKey, _isSyncEnabled);
  }

  void updateClipboardContent(String content) {
    _clipboardContent = content;
    _addToHistory(content);
    notifyListeners();
  }

  void _addToHistory(String content) {
    _clipboardHistory.insert(0, content);
    if (_clipboardHistory.length > 10) {
      _clipboardHistory.removeLast();
    }
    _saveHistory(); // Save history after updating
    notifyListeners();
  }

  void clearHistory() {
    _clipboardHistory.clear();
    _saveHistory(); // Save history after clearing
    notifyListeners();
  }

  void toggleSync(bool value) {
    _isSyncEnabled = value;
    _saveSync(); // Save sync preference after toggling
    notifyListeners();
  }

  void removeFromHistory(int index) {
    if (index >= 0 && index < _clipboardHistory.length) {
      _deletedItem = _clipboardHistory[index];
      _clipboardHistory.removeAt(index);
      _saveHistory(); // Save history after deleting
      notifyListeners();
    }
  }

  void undoDelete() {
    if (_deletedItem != null) {
      _clipboardHistory.insert(0, _deletedItem!);
      _deletedItem = null;
      _saveHistory(); // Save history after undoing
      notifyListeners();
    }
  }

  void toggleTheme(bool value) {
    _isDarkMode = value;
    _saveTheme(); // Save theme after toggling
    notifyListeners();
  }
}