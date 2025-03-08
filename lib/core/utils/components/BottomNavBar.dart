import 'package:flutter/material.dart';

class CustomDotNavigationBar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onTap;
  final Color selectedColor;
  final Color unselectedColor;
  final Duration duration;
  final Color dotColor;

  const CustomDotNavigationBar({
    super.key,
    required this.selectedIndex,
    required this.onTap,
    this.selectedColor = Colors.blue,
    this.unselectedColor = Colors.grey,
    this.duration = const Duration(milliseconds: 300),
    this.dotColor = Colors.blue,
  });

  @override
  Widget build(BuildContext context) {
    final items = [
      _NavigationItem(icon: Icons.home_rounded, label: 'Home'),
      _NavigationItem(icon: Icons.medical_services, label: 'Search'),
      _NavigationItem(icon: Icons.notifications_rounded, label: 'Alerts'),
      _NavigationItem(icon: Icons.person_rounded, label: 'Profile'),
    ];

    return SafeArea(
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.secondary,
          borderRadius: BorderRadius.circular(50),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 1,
              blurRadius: 15,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        height: 75,
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(items.length, (index) {
            return _DotNavigationItem(
              icon: items[index].icon,
              isSelected: selectedIndex == index,
              onTap: () => onTap(index),
              selectedColor: selectedColor,
              unselectedColor: unselectedColor,
              duration: duration,
              dotColor: dotColor,
            );
          }),
        ),
      ),
    );
  }
}

class _NavigationItem {
  final IconData icon;
  final String label;

  _NavigationItem({required this.icon, required this.label});
}

class _DotNavigationItem extends StatelessWidget {
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;
  final Color selectedColor;
  final Color unselectedColor;
  final Duration duration;
  final Color dotColor;

  const _DotNavigationItem({
    required this.icon,
    required this.isSelected,
    required this.onTap,
    required this.selectedColor,
    required this.unselectedColor,
    required this.duration,
    required this.dotColor,
  });

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(end: isSelected ? 1.0 : 0.0),
      curve: Curves.easeInOut,
      duration: duration,
      builder: (context, t, _) {
        final _iconColor = Color.lerp(unselectedColor, selectedColor, t);

        return Material(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(8),
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            onTap: onTap,
            radius: 10,
            splashColor: selectedColor.withOpacity(0.1),
            highlightColor: selectedColor.withOpacity(0.1),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Icon(
                icon,
                color: _iconColor,
                size: 24 + (t * 2.5),
              ),
            ),
          ),
        );
      },
    );
  }
}
