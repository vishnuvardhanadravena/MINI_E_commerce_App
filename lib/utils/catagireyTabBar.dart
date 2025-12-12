import 'package:flutter/material.dart';

class CategoryTabBarWidget extends StatelessWidget {
  final List<Map<String, dynamic>> categories;
  final int selectedIndex;
  final Function(int) onTap;

  const CategoryTabBarWidget({
    super.key,
    required this.categories,
    required this.selectedIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 85,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final selected = index == selectedIndex;

          return GestureDetector(
            onTap: () => onTap(index),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: selected ? Colors.orange : const Color(0xfff1f1f1),
                    ),
                    child: Icon(
                      categories[index]['icon'],
                      color: selected ? Colors.white : Colors.black54,
                      size: 22,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    categories[index]['label'],
                    style: TextStyle(
                      fontSize: 12,
                      color: selected ? Colors.orange : Colors.black87,
                      fontWeight: selected ? FontWeight.bold : FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
