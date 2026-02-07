import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import 'package:flutter_math_fork/flutter_math.dart';
import '../models/formula.dart';
import '../providers/formula_provider.dart';
import '../widgets/formula_search_delegate.dart';
import 'formula_detail_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<FormulaProvider>(context);

    final subjects = [
      {"name": "Physics", "color": const Color(0xFF3B82F6), "icon": Icons.bolt},
      {
        "name": "Math",
        "color": const Color(0xFF8B5CF6),
        "icon": Icons.functions
      },
      {
        "name": "Chemistry",
        "color": const Color(0xFFF59E0B),
        "icon": Icons.science_outlined
      },
      {"name": "Biology", "color": const Color(0xFF10B981), "icon": Icons.spa},
    ];

    return Scaffold(
      backgroundColor: const Color(0xFF0B1120),
      body: provider.isLoading
          ? const Center(
              child: CircularProgressIndicator(color: Color(0xFF38BDF8)))
          : SafeArea(
              child: CustomScrollView(
                physics: const BouncingScrollPhysics(),
                slivers: [
                  SliverPadding(
                    padding: const EdgeInsets.all(24),
                    sliver: SliverList(
                      delegate: SliverChildListDelegate([
                        _buildHeader(),
                        const SizedBox(height: 32),
                        _buildSearchBar(context, provider.allFormulas),
                        const SizedBox(height: 40),
                        const SectionTitle(title: "BROWSE BY SUBJECT"),
                        const SizedBox(height: 16),
                      ]),
                    ),
                  ),
                  SliverPadding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    sliver: SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 16),
                            child: _SubjectCard(
                              subject: subjects[index],
                              count: provider
                                  .getFormulasBySubject(
                                      subjects[index]['name'] as String)
                                  .length,
                            )
                                .animate()
                                .fadeIn(delay: (100 * index).ms)
                                .slideX(),
                          );
                        },
                        childCount: subjects.length,
                      ),
                    ),
                  ),
                  if (provider.bookmarkedFormulas.isNotEmpty) ...[
                    SliverPadding(
                      padding: const EdgeInsets.fromLTRB(24, 40, 24, 16),
                      sliver: SliverToBoxAdapter(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const SectionTitle(title: "QUICK ACCESS"),
                            Text(
                              "${provider.bookmarkedFormulas.length} Saved",
                              style: TextStyle(
                                  color: Colors.white.withOpacity(0.5),
                                  fontSize: 12),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SliverToBoxAdapter(
                      child: SizedBox(
                        height: 150,
                        child: ListView.separated(
                          padding: const EdgeInsets.symmetric(horizontal: 24),
                          scrollDirection: Axis.horizontal,
                          itemCount: provider.bookmarkedFormulas.length,
                          separatorBuilder: (_, __) =>
                              const SizedBox(width: 16),
                          itemBuilder: (context, index) {
                            return _BookmarkCard(
                                    formula: provider.bookmarkedFormulas[index])
                                .animate()
                                .scale(delay: (50 * index).ms);
                          },
                        ),
                      ),
                    ),
                    const SliverToBoxAdapter(child: SizedBox(height: 40)),
                  ],
                ],
              ),
            ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Welcome back,",
                style: TextStyle(color: Color(0xFF94A3B8), fontSize: 16)),
            SizedBox(height: 4),
            Text("Formula Deck",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.5)),
          ],
        ),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: const Color(0xFF1E293B),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: Colors.white10),
          ),
          child: const Icon(Icons.auto_awesome, color: Color(0xFF38BDF8)),
        ),
      ],
    );
  }

  Widget _buildSearchBar(BuildContext context, List<Formula> formulas) {
    return GestureDetector(
      onTap: () => showSearch(
          context: context, delegate: FormulaSearchDelegate(formulas)),
      child: Hero(
        tag: 'searchBar',
        child: Material(
          color: Colors.transparent,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
            decoration: BoxDecoration(
              color: const Color(0xFF1E293B),
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: Colors.white10),
            ),
            child: Row(
              children: [
                const Icon(Icons.search, color: Color(0xFF94A3B8)),
                const SizedBox(width: 14),
                Text("Search formulas, topics...",
                    style: TextStyle(
                        color: const Color(0xFF94A3B8).withOpacity(0.7),
                        fontSize: 16)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class SectionTitle extends StatelessWidget {
  final String title;
  const SectionTitle({super.key, required this.title});
  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: const TextStyle(
        color: Color(0xFF64748B),
        fontSize: 12,
        fontWeight: FontWeight.bold,
        letterSpacing: 1.5,
      ),
    );
  }
}

class _SubjectCard extends StatelessWidget {
  final Map<String, dynamic> subject;
  final int count;

  const _SubjectCard({required this.subject, required this.count});

  @override
  Widget build(BuildContext context) {
    final color = subject['color'] as Color;
    final name = subject['name'] as String;

    return Material(
      color: const Color(0xFF1E293B),
      borderRadius: BorderRadius.circular(20),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => SubjectListScreen(title: name, color: color),
            ),
          );
        },
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.white.withOpacity(0.05)),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(16),
                ),
                child:
                    Icon(subject['icon'] as IconData, color: color, size: 28),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(name,
                        style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white)),
                    const SizedBox(height: 4),
                    Text("$count Formulas",
                        style: TextStyle(
                            fontSize: 14,
                            color: const Color(0xFF94A3B8).withOpacity(0.8))),
                  ],
                ),
              ),
              Icon(Icons.arrow_forward_ios_rounded,
                  size: 16, color: Colors.white.withOpacity(0.3)),
            ],
          ),
        ),
      ),
    );
  }
}

class _BookmarkCard extends StatelessWidget {
  final Formula formula;
  const _BookmarkCard({required this.formula});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
              builder: (_) => FormulaDetailScreen(formula: formula))),
      child: Container(
        width: 160,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFF1E293B),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.white10),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Hero(
              tag: 'math_${formula.id}',
              child: DefaultTextStyle(
                style: const TextStyle(color: Color(0xFF38BDF8), fontSize: 14),
                child: SizedBox(
                  height: 30,
                  child: FittedBox(
                    alignment: Alignment.centerLeft,
                    fit: BoxFit.scaleDown,
                    child: Math.tex(formula.latex,
                        textStyle: const TextStyle(
                            color: Color(0xFF38BDF8), fontSize: 20)),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(formula.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 15)),
                const SizedBox(height: 4),
                Text(formula.topic,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                        color: Color(0xFF64748B), fontSize: 12)),
              ],
            )
          ],
        ),
      ),
    );
  }
}

class SubjectListScreen extends StatelessWidget {
  final String title;
  final Color color;

  const SubjectListScreen(
      {super.key, required this.title, required this.color});

  @override
  Widget build(BuildContext context) {
    final topicsMap =
        context.read<FormulaProvider>().getTopicsForSubject(title);
    final topics = topicsMap.keys.toList();

    return Scaffold(
      backgroundColor: const Color(0xFF0B1120),
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          _buildSliverAppBar(context),
          SliverPadding(
            padding: const EdgeInsets.only(bottom: 50),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final topicName = topics[index];
                  final formulas = topicsMap[topicName]!;

                  return _TopicGroup(
                      topicName: topicName,
                      formulas: formulas,
                      color: color,
                      index: index);
                },
                childCount: topics.length,
              ),
            ),
          ),
        ],
      ),
    );
  }

  SliverAppBar _buildSliverAppBar(BuildContext context) {
    return SliverAppBar(
      backgroundColor: const Color(0xFF0B1120),
      expandedHeight: 120,
      pinned: true,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
        onPressed: () => Navigator.pop(context),
      ),
      flexibleSpace: FlexibleSpaceBar(
        title: Text(
          title,
          style:
              const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        background: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [color.withOpacity(0.2), const Color(0xFF0B1120)],
            ),
          ),
        ),
      ),
    );
  }
}

class _TopicGroup extends StatelessWidget {
  final String topicName;
  final List<Formula> formulas;
  final Color color;
  final int index;

  const _TopicGroup({
    required this.topicName,
    required this.formulas,
    required this.color,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          color: const Color(0xFF0B1120),
          child: Row(
            children: [
              Container(width: 4, height: 16, color: color),
              const SizedBox(width: 8),
              Text(
                topicName.toUpperCase(),
                style: TextStyle(
                  color: color,
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                  letterSpacing: 1.2,
                ),
              ),
            ],
          ),
        ),
        ...formulas.map((f) => _FormulaTile(formula: f)),
        const SizedBox(height: 16),
      ],
    ).animate().fadeIn(delay: (50 * index).ms).slideX(begin: 0.05);
  }
}

class _FormulaTile extends StatelessWidget {
  final Formula formula;
  const _FormulaTile({required this.formula});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
      ),
      child: ListTile(
        title: Text(formula.title,
            style: const TextStyle(
                color: Colors.white, fontWeight: FontWeight.w600)),
        trailing:
            const Icon(Icons.chevron_right, color: Color(0xFF64748B), size: 18),
        onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
                builder: (_) => FormulaDetailScreen(formula: formula))),
      ),
    );
  }
}
