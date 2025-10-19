import 'package:shared_preferences/shared_preferences.dart';

class SavedGrantsService {
  static const String _savedGrantsKey = 'saved_grants';

  // Get all saved grant IDs
  static Future<List<int>> getSavedGrantIds() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String>? savedIds = prefs.getStringList(_savedGrantsKey);
    if (savedIds == null) return [];
    return savedIds.map((id) => int.parse(id)).toList();
  }

  // Check if a grant is saved
  static Future<bool> isGrantSaved(int grantId) async {
    final savedIds = await getSavedGrantIds();
    return savedIds.contains(grantId);
  }

  // Save a grant
  static Future<void> saveGrant(int grantId) async {
    final prefs = await SharedPreferences.getInstance();
    final savedIds = await getSavedGrantIds();
    if (!savedIds.contains(grantId)) {
      savedIds.add(grantId);
      await prefs.setStringList(
        _savedGrantsKey,
        savedIds.map((id) => id.toString()).toList(),
      );
    }
  }

  // Remove a saved grant
  static Future<void> unsaveGrant(int grantId) async {
    final prefs = await SharedPreferences.getInstance();
    final savedIds = await getSavedGrantIds();
    savedIds.remove(grantId);
    await prefs.setStringList(
      _savedGrantsKey,
      savedIds.map((id) => id.toString()).toList(),
    );
  }

  // Toggle save state
  static Future<bool> toggleSave(int grantId) async {
    final isSaved = await isGrantSaved(grantId);
    if (isSaved) {
      await unsaveGrant(grantId);
      return false;
    } else {
      await saveGrant(grantId);
      return true;
    }
  }
}
