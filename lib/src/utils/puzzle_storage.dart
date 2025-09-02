import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/puzzle_config.dart';

class PuzzleStorage {
  final PuzzleConfig config;

  PuzzleStorage(this.config);

  Map<String, String> get _headers {
    Map<String, String> headers = {'Content-Type': 'application/json'};

    if (config.storageType == StorageType.jwtApi && config.jwtToken != null) {
      headers['Authorization'] = 'Bearer ${config.jwtToken}';
    }

    return headers;
  }

  // Get revealed pieces
  Future<List<bool>?> getRevealedPieces() async {
    switch (config.storageType) {
      case StorageType.sharedPreferences:
        return _getFromSharedPrefs();
      case StorageType.basicApi:
      case StorageType.jwtApi:
        return _getFromApi();
      case StorageType.firebase:
        return _getFromFirebase();
    }
  }

  // Save revealed pieces
  Future<void> saveRevealedPieces(List<bool> revealedPieces) async {
    switch (config.storageType) {
      case StorageType.sharedPreferences:
        await _saveToSharedPrefs(revealedPieces);
        break;
      case StorageType.basicApi:
      case StorageType.jwtApi:
        await _saveToApi(revealedPieces);
        break;
      case StorageType.firebase:
        await _saveToFirebase(revealedPieces);
        break;
    }
  }

  // Clear progress
  Future<void> clearProgress() async {
    switch (config.storageType) {
      case StorageType.sharedPreferences:
        await _clearSharedPrefs();
        break;
      case StorageType.basicApi:
      case StorageType.jwtApi:
        await _clearApi();
        break;
      case StorageType.firebase:
        await _clearFirebase();
        break;
    }
  }

  // SharedPreferences methods
  Future<List<bool>?> _getFromSharedPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    List<String>? savedPieces = prefs.getStringList('revealed_pieces');
    if (savedPieces != null) {
      return savedPieces.map((e) => e == 'true').toList();
    }
    return null;
  }

  Future<void> _saveToSharedPrefs(List<bool> revealedPieces) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(
        'revealed_pieces', revealedPieces.map((e) => e.toString()).toList());
  }

  Future<void> _clearSharedPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('revealed_pieces');
  }

  // API methods
  Future<List<bool>?> _getFromApi() async {
    try {
      if (config.getApiUrl == null) return null;

      final response = await http.get(
        Uri.parse(config.getApiUrl!),
        headers: _headers,
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        List<dynamic> pieces = data['revealed_pieces'] ?? [];
        return pieces.map((e) => e as bool).toList();
      } else if (response.statusCode == 404) {
        return null;
      }
      return null;
    } catch (e) {
      print('API Error getting pieces: $e');
      return null;
    }
  }

  Future<void> _saveToApi(List<bool> revealedPieces) async {
    try {
      if (config.postApiUrl == null) return;

      final body = {
        'revealed_pieces': revealedPieces,
        'total_revealed': revealedPieces.where((e) => e).length,
        'updated_at': DateTime.now().toIso8601String(),
      };

      await http.post(
        Uri.parse(config.postApiUrl!),
        headers: _headers,
        body: json.encode(body),
      );
    } catch (e) {
      print('API Error saving pieces: $e');
    }
  }

  Future<void> _clearApi() async {
    try {
      if (config.deleteApiUrl == null) {
        print('Delete API URL not provided - skipping clear operation');
        return;
      }

      await http.delete(
        Uri.parse(config.deleteApiUrl!),
        headers: _headers,
      );
    } catch (e) {
      print('API Error clearing progress: $e');
    }
  }

  // Firebase methods
  Future<List<bool>?> _getFromFirebase() async {
    try {
      DocumentSnapshot doc = await FirebaseFirestore.instance
          .collection('puzzle_progress')
          .doc(config.userId)
          .get();

      if (!doc.exists) return null;

      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
      List<dynamic> revealedList = data['revealed_pieces'] ?? [];

      return revealedList.map((e) => e as bool).toList();
    } catch (e) {
      print('Firebase Error getting pieces: $e');
      return null;
    }
  }

  Future<void> _saveToFirebase(List<bool> revealedPieces) async {
    try {
      await FirebaseFirestore.instance
          .collection('puzzle_progress')
          .doc(config.userId)
          .set({
        'revealed_pieces': revealedPieces,
        'total_revealed': revealedPieces.where((e) => e).length,
        'last_updated': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
    } catch (e) {
      print('Firebase Error saving pieces: $e');
    }
  }

  Future<void> _clearFirebase() async {
    try {
      await FirebaseFirestore.instance
          .collection('puzzle_progress')
          .doc(config.userId)
          .delete();
    } catch (e) {
      print('Firebase Error clearing progress: $e');
    }
  }
}
