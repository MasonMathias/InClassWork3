import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: DefaultTabController(
        length: 4,
        child: _TabsNonScrollableDemo(),
      ),
    );
  }
}

class _TabsNonScrollableDemo extends StatefulWidget {
  @override
  __TabsNonScrollableDemoState createState() => __TabsNonScrollableDemoState();
}

class __TabsNonScrollableDemoState extends State<_TabsNonScrollableDemo>
    with SingleTickerProviderStateMixin, RestorationMixin {
  late TabController _tabController;

  final RestorableInt tabIndex = RestorableInt(0);

  @override
  String get restorationId => 'tab_non_scrollable_demo';

  @override
  void restoreState(RestorationBucket? oldBucket, bool initialRestore) {
    registerForRestoration(tabIndex, 'tab_index');
    _tabController.index = tabIndex.value;
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      initialIndex: 0,
      length: 4,
      vsync: this,
    );
    _tabController.addListener(() {
      setState(() {
        tabIndex.value = _tabController.index;
      });
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    tabIndex.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
// For the To do task hint: consider defining the widget and name of the tabs here
    final tabs = ['Pet 1', 'Pet 2', 'Pet 3', 'Pet 4'];

    return Scaffold(

      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          'Digital Pet Demo',
        ),
        bottom: TabBar(
          controller: _tabController,
          isScrollable: false,
          tabs: [
            for (final tab in tabs) Tab(text: tab),
          ],
        ),
      ),

      body: TabBarView(
        controller: _tabController,
        children: [

          Center( // Pet 1 TAB
            child: Image.network('https://static.vecteezy.com/system/resources/thumbnails/053/242/313/small/endearing-baby-toy-spaniel-dog-sitting-clipart-vector.jpg')
          ),

          Center( // Pet 2 TAB
            child: Image.network('https://www.shutterstock.com/image-vector/cat-kitten-sitting-face-head-600nw-2422795839.jpg')
          ),

          Center( // Pet 3 TAB
            child: Image.network('https://i.etsystatic.com/13434992/r/il/7cb82b/3712276052/il_570xN.3712276052_7w8r.jpg')
          ),

          Center( // Pet 4 TAB
            child: Image.network('https://media.istockphoto.com/id/929253078/vector/budgerigar-isolated-on-white-background-vector-illustration.jpg?s=612x612&w=0&k=20&c=po-njcI5Q1KXbKTxoGMX71U1SjByr_UnIv-_UPULdPU=')
          ),

        ],
      ),
    );
  }
}
