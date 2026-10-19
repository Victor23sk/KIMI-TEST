import 'package:flutter/material.dart';

import '../../core/l10n/app_strings.dart';
import 'feed_panel.dart';
import 'swipe_deck.dart';

class SearchTab extends StatefulWidget {
  const SearchTab({super.key});

  @override
  State<SearchTab> createState() => _SearchTabState();
}

class _SearchTabState extends State<SearchTab>
    with SingleTickerProviderStateMixin {
  late final TabController _tabs;

  @override
  void initState() {
    super.initState();
    _tabs = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabs.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return NestedScrollView(
      headerSliverBuilder: (context, _) => [
        SliverAppBar.large(
          title: const Text(S.tabSearch),
          bottom: TabBar(
            controller: _tabs,
            tabs: const [
              Tab(text: S.cards),
              Tab(text: S.feed),
            ],
          ),
        ),
      ],
      body: TabBarView(
        controller: _tabs,
        children: const [
          SwipeDeck(),
          FeedPanel(),
        ],
      ),
    );
  }
}
