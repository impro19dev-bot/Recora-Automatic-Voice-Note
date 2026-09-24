import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/recording_filter_tab.dart';
import '../models/recording_item.dart';
import '../models/recording_sort.dart';
import '../features/recording/recording_type.dart';
import 'recording_storage_service.dart';

class RecordingsRepository extends ChangeNotifier {
  RecordingsRepository({RecordingStorageService? storage})
    : _storage = storage ?? RecordingStorageService();

  static const _storageKey = 'recora_recordings_metadata';

  final RecordingStorageService _storage;
  final List<RecordingItem> _items = [];
  bool _isLoaded = false;

  bool get isLoaded => _isLoaded;

  List<RecordingItem> get items => List.unmodifiable(_items);

  List<RecordingItem> getAllRecordings() => items;

  RecordingItem? findById(String id) {
    for (final item in _items) {
      if (item.id == id) return item;
    }
    return null;
  }

  int get count => _items.length;

  Duration get totalDuration => _items.fold<Duration>(
        Duration.zero,
        (sum, item) => sum + item.duration,
      );

  int get favoriteCount => _items.where((item) => item.isFavorite).length;

  List<RecordingItem> forTab(
    RecordingFilterTab tab, {
    String query = '',
    RecordingSort sort = RecordingSort.newest,
  }) {
    Iterable<RecordingItem> source = _items;
    switch (tab) {
      case RecordingFilterTab.all:
        break;
      case RecordingFilterTab.incoming:
        source = source.where((item) => item.type == RecordingType.incomingNote);
      case RecordingFilterTab.outgoing:
        source = source.where((item) => item.type == RecordingType.outgoingNote);
      case RecordingFilterTab.favorites:
        source = source.where((item) => item.isFavorite);
    }

    final needle = query.trim().toLowerCase();
    if (needle.isNotEmpty) {
      source = source.where((item) {
        return item.title.toLowerCase().contains(needle) ||
            (item.contactName?.toLowerCase().contains(needle) ?? false) ||
            (item.note?.toLowerCase().contains(needle) ?? false);
      });
    }

    return _sorted(source, sort);
  }

  List<RecordingItem> _sorted(Iterable<RecordingItem> source, RecordingSort sort) {
    final list = source.toList();
    switch (sort) {
      case RecordingSort.newest:
        list.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      case RecordingSort.oldest:
        list.sort((a, b) => a.createdAt.compareTo(b.createdAt));
      case RecordingSort.longest:
        list.sort((a, b) => b.duration.compareTo(a.duration));
      case RecordingSort.title:
        list.sort(
          (a, b) => a.title.toLowerCase().compareTo(b.title.toLowerCase()),
        );
    }
    return list;
  }

  Future<void> loadRecordings() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final raw = prefs.getString(_storageKey);

      if (raw == null || raw.isEmpty) {
        _items.clear();
        _isLoaded = true;
        notifyListeners();
        return;
      }

      final decoded = jsonDecode(raw);
      if (decoded is! List) {
        debugPrint('Invalid recordings JSON: expected a list.');
        await _resetStorage();
        return;
      }

      final loaded = <RecordingItem>[];
      for (final entry in decoded) {
        if (entry is! Map) continue;
        try {
          loaded.add(RecordingItem.fromJson(Map<String, dynamic>.from(entry)));
        } catch (error) {
          debugPrint('Skipping invalid recording entry: $error');
        }
      }

      _items
        ..clear()
        ..addAll(loaded);

      _isLoaded = true;
      notifyListeners();
    } catch (error) {
      debugPrint('Failed to load recordings: $error');
      _items.clear();
      _isLoaded = true;
      notifyListeners();
    }
  }

  Future<void> saveRecordings() async {
    final prefs = await SharedPreferences.getInstance();
    final encoded = jsonEncode(_items.map((item) => item.toJson()).toList());
    await prefs.setString(_storageKey, encoded);
  }

  Future<void> addRecording(RecordingItem item) async {
    _items.insert(0, item);
    await saveRecordings();
    notifyListeners();
  }

  Future<void> updateRecording(RecordingItem item) async {
    final index = _items.indexWhere((element) => element.id == item.id);
    if (index == -1) return;
    _items[index] = item;
    await saveRecordings();
    notifyListeners();
  }

  Future<void> toggleFavorite(String id) async {
    final index = _items.indexWhere((item) => item.id == id);
    if (index == -1) return;
    final current = _items[index];
    _items[index] = current.copyWith(isFavorite: !current.isFavorite);
    await saveRecordings();
    notifyListeners();
  }

  Future<bool> deleteRecording(String id) async {
    final index = _items.indexWhere((item) => item.id == id);
    if (index == -1) return false;

    final item = _items[index];
    await _storage.deleteFile(item.filePath);
    _items.removeAt(index);
    await saveRecordings();
    notifyListeners();
    return true;
  }

  /// Removes metadata only (used when the audio file is already missing).
  Future<bool> removeRecordingMetadata(String id) async {
    final index = _items.indexWhere((item) => item.id == id);
    if (index == -1) return false;

    _items.removeAt(index);
    await saveRecordings();
    notifyListeners();
    return true;
  }

  Future<void> _resetStorage() async {
    _items.clear();
    _isLoaded = true;
    await saveRecordings();
    notifyListeners();
  }
}
