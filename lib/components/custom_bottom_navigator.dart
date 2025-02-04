import 'package:flutter/material.dart';
import 'package:planus/views/new_task_screen.dart';

class CustomBottomNavigationBar extends StatefulWidget {
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
  _CustomBottomNavigationBarState createState() =>
      _CustomBottomNavigationBarState();
}

class _CustomBottomNavigationBarState extends State<CustomBottomNavigationBar> {
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
                isSelected: widget.currentIndex == 0,
              ),
              _buildTabIcon(
                context,
                index: 1,
                icon: Icons.calendar_today,
                isSelected: widget.currentIndex == 1,
              ),
              const SizedBox(width: 60), // floating button space
              _buildTabIcon(
                context,
                index: 2,
                icon: Icons.people,
                isSelected: widget.currentIndex == 2,
              ),
              _buildTabIcon(
                context,
                index: 3,
                icon: Icons.settings,
                isSelected: widget.currentIndex == 3,
              ),
            ],
          ),
        ),
        // FAB button for new task
        Positioned(
          bottom: widget.fabPosition,
          child: FloatingActionButton(
            onPressed: () {
              // debugPrint('FAB button tapped');
              if (context.mounted) {
                // debugPrint('navigator is mounted');
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text('mounted & navigator waited')));
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const NewTaskScreen(),
                  ),
                );
              }
            },
            backgroundColor: const Color(0xFFBCE4A3),
            child: const Icon(Icons.add, size: 30, color: Colors.white),
          ),
        ),
      ],
    );
  }

  Widget _buildTabIcon(BuildContext context,
      {required int index, required IconData icon, required bool isSelected}) {
    return GestureDetector(
      onTap: () => widget.onTabSelected(index),
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
