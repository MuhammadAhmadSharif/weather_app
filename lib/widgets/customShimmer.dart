// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class CustomShimmer extends StatelessWidget {
  final double height;
  final double width;
  final BorderRadius? borderRadius;
  const CustomShimmer({
    Key? key,
    this.height = 32.0,
    this.width = 32.0,
    this.borderRadius,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Theme.of(context).colorScheme.surface.withOpacity(0.6),
      highlightColor: Theme.of(context).colorScheme.surface.withOpacity(0.3),
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: borderRadius,
        ),
        height: height,
        width: width,
      ),
    );
  }
}
