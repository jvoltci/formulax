import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/formula.dart';
import '../services/data_repository.dart';

class FormulaProvider with ChangeNotifier {
  List<Formula> _allFormulas = [];

  Map<String, Map<String, List<Formula>>> _structuredData = {};

  List<String> _bookmarkedIds = [];
  bool _isLoading = true;

  final DataRepository _repository = DataRepository();

  bool get isLoading => _isLoading;
  List<Formula> get allFormulas => _allFormulas;

  List<Formula> get bookmarkedFormulas =>
      _allFormulas.where((f) => _bookmarkedIds.contains(f.id)).toList();

  FormulaProvider() {
    _init();
  }

  Future<void> _init() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      _bookmarkedIds = prefs.getStringList('bookmarked_formulas') ?? [];

      final List<String> jsonStrings = await _repository.loadData();

      final result = await compute(_parseAndGroupData, jsonStrings);

      _allFormulas = result.flatList;
      _structuredData = result.groupedData;

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      debugPrint("❌ Error in FormulaProvider Init: $e");
      _isLoading = false;
      notifyListeners();
    }
  }

  Map<String, List<Formula>> getTopicsForSubject(String subject) {
    return _structuredData[subject] ?? {};
  }

  List<Formula> getFormulasBySubject(String subject) {
    if (_structuredData.containsKey(subject)) {
      return _structuredData[subject]!.values.expand((list) => list).toList();
    }
    return [];
  }

  static ParsedData _parseAndGroupData(List<String> jsonStrings) {
    final List<Formula> flatList = [];
    final Map<String, Map<String, List<Formula>>> groupedData = {};

    for (String jsonString in jsonStrings) {
      try {
        final List<dynamic> parsed = json.decode(jsonString);
        for (var item in parsed) {
          final formula = Formula.fromJson(item);
          flatList.add(formula);

          if (!groupedData.containsKey(formula.subject)) {
            groupedData[formula.subject] = {};
          }
          if (!groupedData[formula.subject]!.containsKey(formula.topic)) {
            groupedData[formula.subject]![formula.topic] = [];
          }
          groupedData[formula.subject]![formula.topic]!.add(formula);
        }
      } catch (e) {
        debugPrint("Error parsing chunk in isolate: $e");
      }
    }
    return ParsedData(flatList, groupedData);
  }

  Future<void> toggleBookmark(String id) async {
    if (_bookmarkedIds.contains(id)) {
      _bookmarkedIds.remove(id);
    } else {
      _bookmarkedIds.add(id);
    }
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('bookmarked_formulas', _bookmarkedIds);
  }

  bool isBookmarked(String id) => _bookmarkedIds.contains(id);
}

class ParsedData {
  final List<Formula> flatList;
  final Map<String, Map<String, List<Formula>>> groupedData;
  ParsedData(this.flatList, this.groupedData);
}
