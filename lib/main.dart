import 'dart:math';
import 'package:flutter/material.dart';

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
  final TextEditingController _cityController = TextEditingController();

  // Weather data storage for each tab (except MAIN)
  Map<String, Map<String, String>> weatherData = {};

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
    tabIndex.dispose();
    _cityController.dispose();
    super.dispose();
  }

  // Function to simulate fetching weather for all day tabs
  void _fetchWeather(String inputCity) {
    final random = Random();
    final conditions = ['Sunny', 'Cloudy', 'Rainy'];

    final city = inputCity.isEmpty ? 'Unknown' : inputCity;

    final tabs = [
      'MAIN',
      'SUNDAY',
      'MONDAY',
      'TUESDAY',
      'WEDNESDAY',
      'THURSDAY',
      'FRIDAY',
      'SATURDAY',
    ];

    // Generate random data for each day tab
    final newWeatherData = <String, Map<String, String>>{};
    for (var i = 1; i < tabs.length; i++) {
      final temp = 15 + random.nextInt(16); // 15 to 30
      final condition = conditions[random.nextInt(conditions.length)];

      newWeatherData[tabs[i]] = {
        'city': city,
        'temperature': '$temp°C',
        'condition': condition,
      };
    }

    setState(() {
      weatherData = newWeatherData;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Weather simulated for $city')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final tabs = [
      'MAIN',
      'SUNDAY',
      'MONDAY',
      'TUESDAY',
      'WEDNESDAY',
      'THURSDAY',
      'FRIDAY',
      'SATURDAY',
    ];

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('Tabs Demo'),
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          tabs: [
            for (final tab in tabs) Tab(text: tab),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // MAIN TAB (City input + Fetch button)
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: _cityController,
                  decoration: InputDecoration(
                    labelText: 'Enter city name',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    _fetchWeather(_cityController.text);
                  },
                  child: const Text('Fetch Weather'),
                ),
              ],
            ),
          ),

          // OTHER TABS (each gets its own simulated data)
          for (int i = 1; i < tabs.length; i++)
            Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'City: ${weatherData[tabs[i]]?['city'] ?? "[Placeholder]"}',
                    style: TextStyle(fontSize: 20),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Temperature: ${weatherData[tabs[i]]?['temperature'] ?? "[Placeholder]"}',
                    style: TextStyle(fontSize: 20),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Condition: ${weatherData[tabs[i]]?['condition'] ?? "[Placeholder]"}',
                    style: TextStyle(fontSize: 20),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
