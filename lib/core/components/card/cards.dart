import 'package:flutter/material.dart';

class GlobalCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final Color? backgroundColor;
  final double? elevation;
  final BorderRadius? borderRadius;
  final bool isResponsive;

  const GlobalCard({
    Key? key,
    required this.child,
    this.padding,
    this.backgroundColor,
    this.elevation,
    this.borderRadius,
    this.isResponsive = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: elevation ?? 2,
      shape: RoundedRectangleBorder(
        borderRadius: borderRadius ?? BorderRadius.circular(8),
      ),
      color: backgroundColor ?? Theme.of(context).cardColor,
      child: Container(
        padding: padding ?? const EdgeInsets.all(16),
        constraints: isResponsive
            ? const BoxConstraints(minHeight: 50)
            : const BoxConstraints(),
        child: child,
      ),
    );
  }
}

class GlobalCardGrid extends StatelessWidget {
  final List<Widget> children;
  final int crossAxisCount;
  final double spacing;
  final double runSpacing;
  final EdgeInsetsGeometry? padding;
  final double? childAspectRatio;

  const GlobalCardGrid({
    Key? key,
    required this.children,
    this.crossAxisCount = 2,
    this.spacing = 16,
    this.runSpacing = 16,
    this.padding,
    this.childAspectRatio,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: crossAxisCount,
      crossAxisSpacing: spacing,
      mainAxisSpacing: runSpacing,
      padding: padding ?? const EdgeInsets.all(16),
      childAspectRatio: childAspectRatio ?? 0.75, // Adjusted for better card proportions
      children: children,
    );
  }
}
