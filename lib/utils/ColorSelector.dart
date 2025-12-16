import 'package:flutter/material.dart';

class ColorSelector extends StatelessWidget {
  final List<Color> colors;
  final int selectedIndex;
  final ValueChanged<int> onColorSelected;

  const ColorSelector({
    super.key,
    required this.colors,
    required this.selectedIndex,
    required this.onColorSelected,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final maxWidth = constraints.maxWidth.isFinite
            ? constraints.maxWidth
            : 120;

        final itemSize = maxWidth / (colors.length * 2.2);
        final borderWidth = itemSize * 0.02;

        return Row(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(
            colors.length,
            (index) => GestureDetector(
              onTap: () => onColorSelected(index),
              child: Container(
                margin: EdgeInsets.only(right: itemSize * 0.1),
                padding: EdgeInsets.all(borderWidth * 5),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: selectedIndex == index
                        ? Colors.black
                        : Colors.transparent,
                    width: borderWidth,
                  ),
                ),
                child: Container(
                  width: itemSize,
                  height: itemSize,
                  decoration: BoxDecoration(
                    color: colors[index],
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class ColorSelector1 extends StatelessWidget {
  final List<Color> colors;
  final int selectedIndex;
  final ValueChanged<int> onColorSelected;

  const ColorSelector1({
    super.key,
    required this.colors,
    required this.selectedIndex,
    required this.onColorSelected,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final maxWidth = constraints.maxWidth.isFinite
            ? constraints.maxWidth
            : 120;

        final itemSize = maxWidth / (colors.length * 2.2);
        final borderWidth = itemSize * 0.02;

        return SizedBox(
          height: itemSize + borderWidth * 10,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            itemCount: colors.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () => onColorSelected(index),
                child: Container(
                  margin: EdgeInsets.only(right: itemSize * 0.2),
                  padding: EdgeInsets.all(borderWidth * 5),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,

                    border: Border.all(
                      color: selectedIndex == index
                          ? Colors.black
                          : Colors.transparent,
                      width: borderWidth,
                    ),
                  ),
                  child: Container(
                    width: itemSize,
                    height: itemSize,
                    decoration: BoxDecoration(
                      color: colors[index],
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
