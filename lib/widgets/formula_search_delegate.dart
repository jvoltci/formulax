import 'package:flutter/material.dart';
import '../models/formula.dart';
import '../screens/formula_detail_screen.dart';

class FormulaSearchDelegate extends SearchDelegate {
  final List<Formula> formulas;

  FormulaSearchDelegate(this.formulas);

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(icon: const Icon(Icons.clear), onPressed: () => query = '')
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: () => close(context, null));
  }

  @override
  Widget buildResults(BuildContext context) {
    return _buildList(context);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return _buildList(context);
  }

  Widget _buildList(BuildContext context) {
    final results = formulas.where((f) {
      final q = query.toLowerCase();
      return f.title.toLowerCase().contains(q) ||
          f.topic.toLowerCase().contains(q);
    }).toList();

    return ListView.builder(
      itemCount: results.length,
      itemBuilder: (context, index) {
        final formula = results[index];
        return ListTile(
          title: Text(formula.title),
          subtitle: Text("${formula.subject} • ${formula.topic}"),
          trailing: const Icon(Icons.north_west, size: 16),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (_) => FormulaDetailScreen(formula: formula)),
            );
          },
        );
      },
    );
  }
}
