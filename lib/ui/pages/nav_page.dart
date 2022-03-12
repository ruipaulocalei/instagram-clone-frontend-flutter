import 'package:flutter/material.dart';
import 'package:flutter_instgram_clone_graphql/ui/pages/init_page.dart';
import 'package:flutter_instgram_clone_graphql/ui/pages/search_page.dart';
import 'package:flutter_instgram_clone_graphql/ui/widgets/custom_tab_bar.dart';
class NavPage extends StatefulWidget {
  const NavPage({Key? key}) : super(key: key);
  static const String routeName = '/navpage';

  @override
  _NavPageState createState() => _NavPageState();
}

class _NavPageState extends State<NavPage> {
  final _pages = <Widget>[
    InitPage({}),
    SearchPage(),
    Scaffold(),
    Scaffold(),
  ];

  final _icons = <IconData>[
    Icons.home,
    Icons.search,
    Icons.add_circle_outline,
    Icons.favorite_border,
  ];
  int _selectedIndex = 0;
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: _pages.length,
        initialIndex: _selectedIndex,
        child: Scaffold(
          body: IndexedStack(
            children: _pages,
            index: _selectedIndex,
          ),
          bottomNavigationBar: Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: CustomTabBar(
                icons: _icons,
                selectedIndex: _selectedIndex,
                onTap: (index) => setState(() {
                      _selectedIndex = index;
                    })),
          ),
        ));
  }
}
