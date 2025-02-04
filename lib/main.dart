import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:planus/views/home_screen.dart';
import 'package:planus/views/calendar_screen.dart';
import 'package:planus/views/splash_screen.dart';
import 'package:planus/views/new_task_screen.dart';
import 'package:planus/viewmodels/new_task_viewmodel.dart';
import 'package:planus/utils/local_notifications_helper.dart';
import 'components/custom_bottom_navigator.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await LocalNotificationsHelper
      .initialize(); //　new taskに記述した local alarm 初期化→こちらはAwaitで実行
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => NewTaskViewModel()),
      ],
      child: const MaterialApp(
        debugShowCheckedModeBanner: false,
        home: SplashScreen(),
      ),
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    const HomeScreen(),
    const CalendarScreen(),
    const Center(child: Text('Groups Page')),
    const Center(child: Text('Settings Page')),
  ];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Scaffold(
        body: _pages[_currentIndex],
        bottomNavigationBar: CustomBottomNavigationBar(
          currentIndex: _currentIndex,
          onTabSelected: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
        ),
      ),
    );
  }
}
