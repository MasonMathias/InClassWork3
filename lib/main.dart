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
    final tabs = ['TextWidget', 'ImageWidget', 'ButtonWidget', 'ListViewWidget'];

    return Scaffold(

      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          'Tabs Demo',
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

          Center( // TEXT AND ALERT TAB lol
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('Stylized text', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),),
                const SizedBox(height: 8),
                ElevatedButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (_) => AlertDialog(
                        title: const Text('Hello'),
                        content: const Text('Alert Dialogue'),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text('OK'),
                          ),
                        ],
                      ),
                    );
                  },
                  child: const Text('Show Alert'),
                ),
              ],
            ),
          ),

          Center( // IMAGE TAB
            child: Image.network(
	              'https://i.imgur.com/CzXTtJV.jpg',
	              width: 300,
	              height: 300,
	            ),
          ),

          Center( // BUTTON TAB
            child: ElevatedButton(
               onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Button pressed in ${tabs[2]} tab!'),),
                );
              },
              child: Text('Click me'),
            ),
          ),

          Center( // LISTVIEW TAB
            child: ListView(
              children: const [
                Card(
                  child: ListTile(leading: Icon(Icons.list), title: Text('Item 1'), subtitle: Text('Details about item 1'),),
                ),
                Card(
                  child: ListTile(leading: Icon(Icons.list), title: Text('Item 2'), subtitle: Text('Details about item 2'),),
                ),
                Card(
                  child: ListTile(leading: Icon(Icons.list), title: Text('Item 3'), subtitle: Text('Details about item 3'),),
                ),
              ],
            ),
          ),

        ],
      ),
    );
  }
}
