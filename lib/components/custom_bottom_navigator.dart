import 'package:flutter/material.dart';
import 'package:planus/views/calendar_screen.dart';
import 'package:planus/views/group_screen.dart';
import 'package:planus/views/home_screen.dart';
import 'package:planus/views/new_task_screen.dart';

class CustomBottomNavigationBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTabSelected;
  final double fabPosition;

  const CustomBottomNavigationBar({
    super.key,
    required this.currentIndex,
    required this.onTabSelected,
    this.fabPosition = 15,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          height: 70,
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border(
              top: BorderSide(color: Colors.grey[300]!),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildTabIcon(
                context,
                index: 0,
                icon: Icons.home,
                isSelected: currentIndex == 0,
              ),
              _buildTabIcon(
                context,
                index: 1,
                icon: Icons.calendar_today,
                isSelected: currentIndex == 1,
              ),
              const SizedBox(width: 60), // FAB 공간 확보
              _buildTabIcon(
                context,
                index: 2,
                icon: Icons.people,
                isSelected: currentIndex == 2,
              ),
              _buildTabIcon(
                context,
                index: 3,
                icon: Icons.settings,
                isSelected: currentIndex == 3,
              ),
            ],
          ),
        ),
        // ✅ FAB 버튼 클릭 시 NewTaskScreen으로 이동
        Positioned(
          bottom: fabPosition,
          child: FloatingActionButton(
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const NewTaskScreen()),
              );
            },
            backgroundColor: const Color(0xFFBCE4A3),
            child: const Icon(Icons.add, size: 30, color: Colors.white),
          ),
        ),
      ],
    );
  }

  Widget _buildTabIcon(
    BuildContext context, {
    required int index,
    required IconData icon,
    required bool isSelected,
  }) {
    return GestureDetector(
      onTap: () {
        if (index != currentIndex) {
          // ✅ 현재 페이지가 아닐 때만 이동하도록 수정
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) {
                if (index == 0) return const HomeScreen();
                if (index == 1) return const CalendarScreen();
                if (index == 2) return const GroupScreen();
                if (index == 3)
                  return const Center(child: Text('Settings Page'));
                return const HomeScreen();
              },
            ),
          );
        }
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFFFF3E0) : Colors.transparent,
          shape: BoxShape.circle,
        ),
        child: Icon(
          icon,
          size: 30,
          color: isSelected ? const Color(0xFFFFA726) : Colors.grey,
        ),
      ),
    );
  }
}
