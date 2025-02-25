import 'package:flutter/material.dart';
import 'package:planus/views/group_screen.dart';
import 'package:provider/provider.dart';
import 'package:planus/views/home_screen.dart';
import 'package:planus/views/calendar_screen.dart';
import 'package:planus/views/splash_screen.dart';
import 'package:planus/viewmodels/new_task_viewmodel.dart';
import 'package:planus/utils/local_notifications_helper.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'components/custom_bottom_navigator.dart';

void main() async {
  const supabaseUrl = 'https://hhzzknyzejecldijompj.supabase.co';
  const supabaseKey =
      'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Imhoenprbnl6ZWplY2xkaWpvbXBqIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDAwNjI3OTAsImV4cCI6MjA1NTYzODc5MH0.N3gbcfsFlRHIswWhtMBumJMJzrLUvffEZzOKEzfdvdE';
  WidgetsFlutterBinding.ensureInitialized();
  await LocalNotificationsHelper
      .initialize(); //　new taskに記述した local alarm 初期化→こちらはAwaitで実行
  await Supabase.initialize(url: supabaseUrl, anonKey: supabaseKey);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => NewTaskViewModel(),
        ),
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
    const GroupScreen(),
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
