import 'package:shared_preferences/shared_preferences.dart';

class BookmarkService {
  static const String _key = 'bookmarked_formulas';

  static Future<List<String>> getBookmarkedIds() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(_key) ?? [];
  }

  static Future<bool> toggleBookmark(String id) async {
    final prefs = await SharedPreferences.getInstance();

    final List<String> bookmarks = prefs.getStringList(_key) ?? [];

    bool isNowBookmarked = false;

    if (bookmarks.contains(id)) {
      bookmarks.remove(id);
      isNowBookmarked = false;
    } else {
      bookmarks.add(id);
      isNowBookmarked = true;
    }

    await prefs.setStringList(_key, bookmarks);
    return isNowBookmarked;
  }

  static Future<bool> isBookmarked(String id) async {
    final prefs = await SharedPreferences.getInstance();
    final list = prefs.getStringList(_key) ?? [];
    return list.contains(id);
  }
}
