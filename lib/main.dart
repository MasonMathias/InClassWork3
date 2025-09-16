import 'package:flutter/material.dart';
import 'dart:math';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: DefaultTabController(
        length: 8,
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
      length: 8,
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
    _cityController.dispose();
    tabIndex.dispose();
    super.dispose();
  }

  final TextEditingController _cityController = TextEditingController();

  String city = "placeholder city";
  String temperature = "placeholder temp";
  String condition = "rainy";

  void fetchWeather() {
    final r = Random();
    final temp = 15 + r.nextInt(16); // 15–30
    const options = ['sunny', 'rainy', 'cloudy'];
    final cond = options[r.nextInt(options.length)];

    setState(() {
      city = _cityController.text.isEmpty ? "Unknown city" : _cityController.text;
      temperature = "$temp °C";
      condition = cond;
  });
  }

  @override
  Widget build(BuildContext context) {
    final tabs = ['Main', 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'];

    return Scaffold(

      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          '7-Day Weather App Demo',
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
          // MAIN
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [

                // Fetch weather button
                ElevatedButton(
                  onPressed: fetchWeather,
                  child: const Text("Fetch Weather"),
                ),

                // text box to enter city name
                TextField(
                  controller: _cityController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: "Enter city",
                  ),
                ),
              ],
            )
          ),

          // Days of the week
          for (int i = 1; i < tabs.length; i++)
            Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text("City: $city"),
                  Text("Temperature: $temperature"),
                  Text("Weather condition: $condition"),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
